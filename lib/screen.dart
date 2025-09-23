import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:send_tv/core/network/network_service.dart';
import 'package:send_tv/model/device_info_result.dart';
import 'package:send_tv/utils/device_info_helper.dart';

class Screen {
  static Future<DeviceType> initialize() async {
    try {
      final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
      FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
      final info = await getDeviceInfo();

      NetworkService().start(port: 12348);
      NetworkService().get("/hello", (req) {
        req.response
          ..statusCode = 200
          ..write("你好，来自 /hello 的响应！")
          ..close();
      });

      FlutterNativeSplash.remove();
      return info.deviceType;
    } catch (e) {
      rethrow;
    }
  }
}
