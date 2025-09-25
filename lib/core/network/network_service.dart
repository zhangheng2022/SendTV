import 'dart:io';
import 'package:send_tv/utils/logger.dart';

class NetworkService {
  HttpServer? _server;
  int? _runningPort;

  final Map<String, Function(HttpRequest)> _getRoutes = {};
  final Map<String, Function(HttpRequest)> _postRoutes = {};

  bool get isRunning => _server != null;
  int? get currentPort => _runningPort;

  /// 启动服务并返回端口
  Future<int> start({int port = 53331}) async {
    if (isRunning) {
      Log.w("⚠️ HTTP 服务已经在运行");
      return _runningPort!;
    }

    final availablePort = await _findAvailablePort(port);
    _server = await HttpServer.bind(InternetAddress.anyIPv4, availablePort);
    _runningPort = availablePort;

    Log.d("✅ HTTP 服务启动: 端口 $availablePort");

    _server!.listen((HttpRequest request) async {
      final method = request.method;
      final path = request.uri.path;
      Log.d("📩 请求: [$method] $path");
      try {
        if (method == 'GET' && _getRoutes.containsKey(path)) {
          await _getRoutes[path]!(request);
        } else if (method == 'POST' && _postRoutes.containsKey(path)) {
          await _postRoutes[path]!(request);
        } else {
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

    return _runningPort!;
  }

  Future<void> stop() async {
    if (!isRunning) {
      Log.w("⚠️ 服务未运行");
      return;
    }
    await _server?.close(force: true);
    _server = null;
    _runningPort = null;
    Log.w("🛑 HTTP 服务已停止");
  }

  void get(String path, Function(HttpRequest) handler) {
    _getRoutes[path] = handler;
  }

  void post(String path, Function(HttpRequest) handler) {
    _postRoutes[path] = handler;
  }

  Future<int> _findAvailablePort(int startPort) async {
    var port = startPort;
    while (true) {
      try {
        final socket = await ServerSocket.bind(
          InternetAddress.loopbackIPv4,
          port,
        );
        await socket.close();
        return port;
      } catch (_) {
        port++;
      }
    }
  }
}
