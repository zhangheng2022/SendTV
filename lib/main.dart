import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:send_tv/model/device_info_result.dart';
import 'package:send_tv/providers/network_provider.dart';
import 'package:send_tv/utils/logger.dart';
import 'package:send_tv/screen.dart';
import 'package:send_tv/pages/home.dart';
import 'package:send_tv/config/theme_config.dart';

Future<void> main() async {
  final initInfo = await Screen.initialize();
  Log.t(initInfo);
  runApp(SendTVApp(initInfo: initInfo));
}

class SendTVApp extends StatelessWidget {
  const SendTVApp({super.key, required this.initInfo});

  final DeviceType initInfo;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => NetworkProvider())],
      child: MaterialApp(
        title: 'SendTVApp',
        theme: AppTheme.dark,
        home: const MobileHomePage(),
      ),
    );
  }
}
