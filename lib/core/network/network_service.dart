import 'dart:io';
import 'dart:convert';

import 'package:send_tv/utils/logger.dart';

class NetworkService {
  HttpServer? _server;

  /// 路由表：key = 路径，例如 "/hello"
  /// value = 处理函数
  final Map<String, Function(HttpRequest)> _getRoutes = {};
  final Map<String, Function(HttpRequest)> _postRoutes = {};

  /// 是否正在运行
  bool get isRunning => _server != null;

  /// 启动 HTTP 服务
  Future<void> start({int port = 8080}) async {
    if (isRunning) {
      Log.w("⚠️ HTTP 服务已经在运行，无需重复启动！");
      return;
    }

    _server = await HttpServer.bind(InternetAddress.anyIPv4, port);
    Log.d("✅ HTTP 服务已启动: http://${_server!.address.address}:$port");

    _server!.listen((HttpRequest request) async {
      final method = request.method;
      final path = request.uri.path;
      Log.d("📩 收到请求: [$method] $path");
      try {
        if (method == 'GET' && _getRoutes.containsKey(path)) {
          await _getRoutes[path]!(request);
        } else if (method == 'POST' && _postRoutes.containsKey(path)) {
          await _postRoutes[path]!(request);
        } else {
          // 路由不存在
          request.response
            ..statusCode = HttpStatus.notFound
            ..write("404 Not Found: $path")
            ..close();
        }
      } catch (e) {
        request.response
          ..statusCode = HttpStatus.internalServerError
          ..write("500 Internal Server Error: $e")
          ..close();
      }
    });
  }

  /// 停止 HTTP 服务
  Future<void> stop() async {
    if (!isRunning) {
      Log.w("⚠️ HTTP 服务未启动，无需停止！");
      return;
    }
    await _server?.close(force: true);
    _server = null;
    Log.w("🛑 HTTP 服务已停止");
  }

  /// 注册 GET 路由
  void get(String path, Function(HttpRequest) handler) {
    _getRoutes[path] = handler;
  }

  /// 注册 POST 路由
  void post(String path, Function(HttpRequest) handler) {
    _postRoutes[path] = handler;
  }

  /// 获取本地局域网 IP（过滤掉 127.0.0.1 和 IPv6）
  Future<List<String>> getLocalIPs() async {
    final interfaces = await NetworkInterface.list(
      includeLoopback: false,
      type: InternetAddressType.IPv4,
    );
    final ips = <String>[];
    for (var interface in interfaces) {
      for (var addr in interface.addresses) {
        ips.add(addr.address);
      }
    }
    return ips;
  }
}
