import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

Future<DeviceInfoResult> getDeviceInfo() async {
  final plugin = DeviceInfoPlugin();
  DeviceType deviceType;
  String deviceModel = 'Unknown';

  if (kIsWeb) {
    deviceType = DeviceType.web;
    deviceModel = 'Web';
  } else {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
        deviceType = DeviceType.mobile;
        break;
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.fuchsia:
        deviceType = DeviceType.desktop;
        break;
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        final deviceInfo = await plugin.androidInfo;
        deviceModel = deviceInfo.model;
        break;
      case TargetPlatform.iOS:
        final deviceInfo = await plugin.iosInfo;
        deviceModel = deviceInfo.localizedModel;
        break;
      case TargetPlatform.linux:
        deviceModel = 'Linux';
        break;
      case TargetPlatform.macOS:
        deviceModel = 'macOS';
        break;
      case TargetPlatform.windows:
        deviceModel = 'Windows';
        break;
      case TargetPlatform.fuchsia:
        deviceModel = 'Fuchsia';
        break;
    }
  }

  return DeviceInfoResult(deviceType: deviceType, deviceModel: deviceModel);
}

enum DeviceType { mobile, desktop, web, tv }

class DeviceInfoResult {
  final DeviceType deviceType;
  final String deviceModel;

  DeviceInfoResult({required this.deviceType, required this.deviceModel});
}
