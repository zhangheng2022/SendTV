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
    // TODO: implement initState
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          TVFilledButton(
            autofocus: false,
            child: const Text('开启服务'),
            onPressed: () {
              print('按钮被点击了');
            },
          ),
          Text(ip),
          // TVTextButton(
          //   child: const Text('文本按钮1'),
          //   onPressed: () {
          //     print('文本按钮被点击了');
          //   },
          // ),
        ],
      ),
    );
  }
}
