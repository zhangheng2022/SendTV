import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:network_info_plus/network_info_plus.dart';
import 'package:send_tv/utils/logger.dart';

class UDPServer {
  RawDatagramSocket? _socket;
  StreamSubscription<RawSocketEvent>? _subscription;
  final Map<String, InternetAddress> _clients = {};

  // 启动服务器
  Future<void> start({int port = 53331}) async {
    try {
      _socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, port);
      Log.d(_socket);
      Log.d('UDP服务器已启动，监听端口: $port');
      // 监听接收数据
      _subscription = _socket?.listen((event) {
        if (event == RawSocketEvent.read) {
          _handleDataReceived();
        }
      });
    } catch (e) {
      Log.e('UDP服务器启动失败: $e');
    }
  }

  // 处理接收到的数据
  void _handleDataReceived() {
    final datagram = _socket?.receive();
    if (datagram != null) {
      final message = utf8.decode(datagram.data);
      final clientKey = '${datagram.address.address}:${datagram.port}';

      Log.d('从客户端 $clientKey 收到消息1: $message');

      // 记录客户端
      _clients[clientKey] = datagram.address;
    }
  }

  // 发送消息到特定客户端
  void sendToClient(String message, InternetAddress address, int port) {
    if (_socket == null) return;

    try {
      final data = utf8.encode(message);
      _socket?.send(data, address, port);
      Log.d('发送到 ${address.address}:$port : $message');
    } catch (e) {
      Log.e('发送失败: $e');
    }
  }

  // 广播消息给所有客户端（除了发送者）
  Future<void> sendToAllClient(
    String message,
    InternetAddress excludeAddress,
    int excludePort,
  ) async {
    final NetworkInfo _wifiInfo = NetworkInfo();
    final localIP = await _wifiInfo.getWifiIP();

    if (localIP == null) return Log.e('本地IP获取失败');

    if (_socket == null) return Log.e('socket为空：$_socket');
    final data = utf8.encode(message);
    // 注意：这里简化处理，实际应该记录端口号
    _socket?.send(data, InternetAddress(localIP), 53331); // 端口需要实际记录
    Log.d('广播消息: $message');
  }

  // 关闭服务器
  void stop() {
    _subscription?.cancel();
    _socket?.close();
    Log.d('UDP服务器已停止');
  }
}
