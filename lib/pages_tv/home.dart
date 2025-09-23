import 'package:flutter/material.dart';
import 'package:send_tv/core/network/network_service.dart';
import 'package:send_tv/pages_tv/components/filled_button.dart';
import 'package:send_tv/pages_tv/components/text_button.dart';

class TVHomePage extends StatefulWidget {
  const TVHomePage({super.key});

  @override
  State<TVHomePage> createState() => _TVHomePageState();
}

class _TVHomePageState extends State<TVHomePage> {
  final server = NetworkService();

  String ip = "未知";

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    String? ip = await server.getLocalIP();

    setState(() {
      ip = ip;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/logos/logo.png', height: 32),
            const SizedBox(width: 8),
            const Text('Send TV'),
          ],
        ),
        actions: [TVFilledButton(child: Text('设置'), onPressed: () async {})],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("当前IP地址：$ip"),
            const SizedBox(height: 20),
            TVFilledButton(
              child: Text('ceshi'),
              onPressed: () async {
                String? ip = await server.getLocalIP();
                setState(() {
                  ip = ip;
                });
              },
            ),
            const SizedBox(height: 20),
            TVTextButton(
              child: Text('ceshi'),
              onPressed: () {
                // 退出应用
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
