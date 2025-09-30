import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:send_tv/model/broadcast_info.dart';
import 'package:send_tv/utils/device_info_helper.dart';
import 'package:send_tv/utils/logger.dart';

class UDPServer {
  RawDatagramSocket? _socket;

  final multicastAddress = InternetAddress("239.255.0.1");
  final port = 53331;

  Timer? _broadcastTimer;

  Future<void> listenMulticast() async {
    try {
      _socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, port);
      _socket?.joinMulticast(multicastAddress);
      _socket?.broadcastEnabled = true;
      Log.d('UDP多播监听已启动，监听地址: ${multicastAddress.address}, 端口: $port');
      // 监听接收数据
      _socket?.listen((event) {
        if (event == RawSocketEvent.read) {
          final dategram = _socket!.receive();
          if (dategram != null) {
            final message = utf8.decode(dategram.data);
            Log.d(
              "📩 收到来自 ${dategram.address.address}:${dategram.port} -> $message",
            );
          }
        }
      });
    } catch (e) {
      Log.e('UDP多播监听启动失败: $e');
    }
  }

  /// 启动周期性广播
  void startBroadcast(DeviceInfoResult deviceInfo) {
    _broadcastTimer?.cancel();
    _broadcastTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      final broadcastData =
          BroadcastInfo(
            alias: deviceInfo.deviceModel,
            deviceModel: deviceInfo.deviceModel,
            deviceType: deviceInfo.deviceType.name,
            fingerprint: DateTime.now().millisecondsSinceEpoch.toString(),
          ).toJson();

      final data = utf8.encode(broadcastData.toString());
      _socket?.send(data, multicastAddress, port);
    });
  }

  void stop() {
    _broadcastTimer?.cancel();
    _socket?.close();
    Log.d('UDP多播监听已停止');
  }
}
