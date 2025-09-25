import 'package:flutter/services.dart';

class NativeMDNS {
  static const _channel = MethodChannel('mdns_service');

  static Future<void> advertiseService({
    required String name,
    required String type,
    required int port,
  }) async {
    await _channel.invokeMethod('advertiseService', {
      'name': name,
      'type': type,
      'port': port,
    });
  }

  static Future<void> stopAdvertise() async {
    await _channel.invokeMethod('stopAdvertise');
  }
}
