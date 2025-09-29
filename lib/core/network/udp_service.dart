import 'dart:async';
import 'dart:convert';
import 'dart:io';

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
          final datagram = _socket?.receive();
          if (datagram != null) {
            final dg = _socket!.receive();
            if (dg != null) {
              final message = utf8.decode(dg.data);
              Log.d("📩 收到来自 ${dg.address.address}:${dg.port} -> $message");
            }
          }
        }
      });
    } catch (e) {
      Log.e('UDP多播监听启动失败: $e');
    }
  }

  /// 启动周期性广播
  void startBroadcast(String deviceName) {
    _broadcastTimer?.cancel();
    _broadcastTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      final msg = "❤️ 心跳来自 $deviceName @ ${DateTime.now()}";
      final data = utf8.encode(msg);
      _socket?.send(data, multicastAddress, port);
    });
  }

  void stop() {
    _broadcastTimer?.cancel();
    _socket?.close();
    Log.d('UDP多播监听已停止');
  }
}
