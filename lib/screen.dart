import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:send_tv/model/device_info_result.dart';
import 'package:send_tv/utils/device_info_helper.dart';

class Screen {
  static Future<DeviceType> initialize() async {
    try {
      final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
      FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
      final info = await getDeviceInfo();
      FlutterNativeSplash.remove();
      return info.deviceType;
    } catch (e) {
      rethrow;
    }
  }
}
