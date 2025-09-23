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

  /// 获取一个可用局域网 IP
  Future<String?> getLocalIP() async {
    if (_runningPort == null) return null;

    final interfaces = await NetworkInterface.list(
      includeLoopback: false,
      type: InternetAddressType.IPv4,
    );

    for (var interface in interfaces) {
      final name = interface.name.toLowerCase();
      if (_isVirtualAdapter(name)) continue;

      for (var addr in interface.addresses) {
        final ip = addr.address;
        if (_isPrivateIP(ip) && await _testReachable(ip, _runningPort!)) {
          return ip;
        }
      }
    }
    return null;
  }

  /// 判断是否虚拟网卡
  bool _isVirtualAdapter(String name) {
    return name.contains("vmnet") ||
        name.contains("vbox") ||
        name.contains("docker") ||
        name.contains("tun") ||
        name.contains("tap");
  }

  /// 判断是否内网IP
  bool _isPrivateIP(String ip) {
    return ip.startsWith("192.") ||
        ip.startsWith("10.") ||
        ip.startsWith("172.");
  }

  Future<bool> _testReachable(String ip, int port) async {
    try {
      final socket = await Socket.connect(
        ip,
        port,
        timeout: const Duration(milliseconds: 500),
      );
      socket.destroy();
      return true;
    } catch (_) {
      return false;
    }
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
