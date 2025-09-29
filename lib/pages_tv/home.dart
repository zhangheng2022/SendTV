import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:send_tv/core/network/network_service.dart';
import 'package:send_tv/pages_tv/components/filled_button.dart';
import 'package:send_tv/pages_tv/components/text_button.dart';
import 'package:send_tv/pages_tv/drawer_right.dart';
import 'package:send_tv/providers/network_provider.dart';

class TVHomePage extends StatefulWidget {
  const TVHomePage({super.key});

  @override
  State<TVHomePage> createState() => _TVHomePageState();
}

class _TVHomePageState extends State<TVHomePage> {
  final GlobalKey<ScaffoldState> _ScaffoldKey = GlobalKey<ScaffoldState>();
  final PageController _controller = PageController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _ScaffoldKey,
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/logos/logo.png', height: 32),
            const SizedBox(width: 10),
            const Text('Send TV'),
          ],
        ),
        actions: [
          TVFilledButton(
            autofocus: false,
            icon: Icon(Icons.settings),
            onPressed: () {
              _ScaffoldKey.currentState?.openEndDrawer();
            },
            child: Text('设置'),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(
              spacing: 12,
              children: [
                TVFilledButton(
                  autofocus: true,
                  child: Text('主页'),
                  onPressed: () async {},
                  onFocusChange: (focus) {
                    _controller.jumpToPage(0);
                    setState(() => _currentIndex = 0);
                  },
                ),
                TVFilledButton(
                  child: Text('文件'),
                  onPressed: () async {},
                  onFocusChange: (focus) {
                    _controller.jumpToPage(1);
                    setState(() => _currentIndex = 1);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              controller: _controller,
              onPageChanged: (index) => setState(() => _currentIndex = index),
              children: [FirstView(), const Center(child: Text('文件 页面'))],
            ),
          ),
        ],
      ),
      endDrawer: DrawerRight(),
    );
  }
}

class FirstView extends StatefulWidget {
  const FirstView({super.key});

  @override
  State<FirstView> createState() => _FirstViewState();
}

class _FirstViewState extends State<FirstView> {
  @override
  Widget build(BuildContext context) {
    final network = context.watch<NetworkProvider>();
    return Center(child: Text('当前设备IP: ${network.ip}:${network.port}'));
  }
}
