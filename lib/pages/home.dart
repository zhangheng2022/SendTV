import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:send_tv/providers/network_provider.dart';

class MobileHomePage extends StatefulWidget {
  const MobileHomePage({super.key});

  @override
  State<MobileHomePage> createState() => _MobileHomePageState();
}

class _MobileHomePageState extends State<MobileHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final network = context.watch<NetworkProvider>();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            FilledButton(
              child: const Text('修改端口'),
              onPressed: () {
                print('按钮被点击了');
                network.changePort(53338);
              },
            ),
            Text("服务地址: ${network.serviceUrl}"),
          ],
        ),
      ),
    );
  }
}
