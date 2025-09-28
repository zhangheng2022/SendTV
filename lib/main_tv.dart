import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:send_tv/providers/network_provider.dart';
import 'package:send_tv/utils/logger.dart';
import 'package:send_tv/screen.dart';
import 'package:send_tv/pages_tv/home.dart';
import 'package:send_tv/config/theme_config.dart';

Future<void> main() async {
  await Screen.initialize();
  runApp(SendTVApp());
}

class SendTVApp extends StatelessWidget {
  const SendTVApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => NetworkProvider())],
      child: MaterialApp(
        title: 'SendTVApp',
        theme: AppTheme.dark,
        builder: (context, child) {
          // 这里包一层全局 FocusTraversalGroup
          return FocusTraversalGroup(
            policy: ReadingOrderTraversalPolicy(
              requestFocusCallback:
                  (
                    FocusNode node, {
                    ScrollPositionAlignmentPolicy? alignmentPolicy,
                    double? alignment,
                    Duration? duration,
                    Curve? curve,
                  }) {
                    node.requestFocus();
                    Scrollable.ensureVisible(
                      node.context!,
                      alignment: alignment ?? 1,
                      alignmentPolicy:
                          alignmentPolicy ??
                          ScrollPositionAlignmentPolicy.explicit,
                      duration: duration ?? const Duration(milliseconds: 400),
                      curve: curve ?? Curves.easeOut,
                    );
                  },
            ),
            child: child ?? const SizedBox(),
          );
        },
        home: const TVHomePage(),
      ),
    );
  }
}
