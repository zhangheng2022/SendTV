import 'package:flutter/material.dart';
import 'dart:io';
import 'package:send_tv/utils/logger.dart';

void main() {
  runApp(const SendTVApp());
}

class SendTVApp extends StatelessWidget {
  const SendTVApp({super.key});
  @override
  Widget build(BuildContext context) {
    Log.t('App started');
    return MaterialApp(
      title: 'SendTVApp',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? localIP;
  int? port;

  void switchServer() async {
    final ip = await getLocalIPv4();
    setState(() {
      localIP = ip;
      port = 53318;
    });
    final server = await HttpServer.bind(InternetAddress.anyIPv4, 53318);
    Log.i('Listening on http://${server.address.address}:${server.port}');
    await for (HttpRequest request in server) {
      Log.i('Received request: ${request.method} ${request.uri}');
      await request.response.close();
    }
  }

  Future<String?> getLocalIPv4() async {
    try {
      final interfaces = await NetworkInterface.list(
        includeLoopback: false,
        type: InternetAddressType.IPv4,
      );

      for (var interface in interfaces) {
        for (var addr in interface.addresses) {
          if (!addr.isLoopback) {
            return addr.address; // 例如 192.168.1.105
          }
        }
      }
      return null;
    } catch (e) {
      Log.e('获取本地IP地址失败: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('当前设备地址:$localIP:$port'),
            FilledButton(onPressed: switchServer, child: const Text('开启服务')),
          ],
        ),
      ),
    );
  }
}
