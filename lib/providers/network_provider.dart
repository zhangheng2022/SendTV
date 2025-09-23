import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:send_tv/core/network/network_service.dart';

class NetworkProvider extends ChangeNotifier {
  final NetworkService _service = NetworkService();

  bool get isRunning => _service.isRunning;
  String? _ip;
  String? get ip => _ip;
  int? get port => _service.currentPort;

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
    await _service.start();
    _ip = await _service.getLocalIP();
    notifyListeners();
  }

  /// 停止服务
  Future<void> stop() async {
    await _service.stop();
    _ip = null;
    notifyListeners();
  }

  /// 手动刷新IP
  Future<void> refreshIP() async {
    _ip = await _service.getLocalIP();
    notifyListeners();
  }

  /// 修改端口
  Future<void> changePort(int newPort) async {
    if (isRunning) {
      await stop();
    }
    await _service.start(port: newPort);
    _ip = await _service.getLocalIP();
    notifyListeners();
  }
}
