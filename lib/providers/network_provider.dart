import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:send_tv/core/network/network_service.dart';
import 'package:send_tv/core/network/udp_service.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:send_tv/utils/logger.dart';

class NetworkProvider extends ChangeNotifier {
  final NetworkService _service = NetworkService();
  final NetworkInfo _wifiInfo = NetworkInfo();
  final UDPServer _udpServer = UDPServer();

  bool get isRunning => _service.isRunning;
  String? _ip;
  String? get ip => _ip;
  int? get port => _service.currentPort;

  UDPServer get udpServer => _udpServer;

  String? get serviceUrl =>
      (ip != null && port != null) ? "http://$ip:$port" : null;

  NetworkProvider() {
    // 自动启动服务
    start();
    // 监听网络变化
    Connectivity().onConnectivityChanged.listen((event) async {
      if (isRunning) {
        await refreshIP();
      }
    });
  }

  /// 启动服务
  Future<void> start() async {
    try {
      await _service.start();
      await _udpServer.start();
      _ip = await _wifiInfo.getWifiIP();
      Log.d("Service started at $_ip");
      notifyListeners();
    } catch (e) {
      Log.e("Failed to get WiFi IP: $e");
      _ip = null;
      notifyListeners();
      return;
    }
  }

  /// 停止服务
  Future<void> stop() async {
    await _service.stop();
    notifyListeners();
  }

  /// 手动刷新IP
  Future<void> refreshIP() async {
    _ip = await _wifiInfo.getWifiIP();
    notifyListeners();
  }

  /// 修改端口
  Future<void> changePort(int newPort) async {
    if (isRunning) {
      await stop();
    }
    await _service.start(port: newPort);
    notifyListeners();
  }
}
