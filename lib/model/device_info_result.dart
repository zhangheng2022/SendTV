enum DeviceType { mobile, desktop, web, tv }

class DeviceInfoResult {
  final DeviceType deviceType;
  final String? deviceModel;

  // Used to properly set Edge-to-Edge mode on Android
  // See https://github.com/flutter/flutter/issues/90098
  final int? androidSdkInt;

  DeviceInfoResult({
    required this.deviceType,
    required this.deviceModel,
    required this.androidSdkInt,
  });
}
