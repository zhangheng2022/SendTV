import 'dart:convert';

class BroadcastInfo {
  final String alias;
  final String version; // 协议版本（major.minor）
  final String? deviceModel;
  final String? deviceType; // mobile | desktop | web | headless | server
  final String fingerprint; // 随机字符串
  final int port;
  final String protocol; // http | https
  final bool download; // 下载 API 是否激活
  final bool announce;

  BroadcastInfo({
    required this.alias,
    this.version = "2.0",
    this.deviceModel,
    this.deviceType,
    required this.fingerprint,
    this.port = 53317,
    this.protocol = "https",
    this.download = false,
    this.announce = true,
  });

  /// 转 JSON Map
  Map<String, dynamic> toJson() {
    return {
      "alias": alias,
      "version": version,
      "deviceModel": deviceModel,
      "deviceType": deviceType,
      "fingerprint": fingerprint,
      "port": port,
      "protocol": protocol,
      "download": download,
      "announce": announce,
    };
  }

  /// 转 JSON 字符串
  String toJsonString() => jsonEncode(toJson());

  /// 从 JSON Map 创建对象
  factory BroadcastInfo.fromJson(Map<String, dynamic> json) {
    return BroadcastInfo(
      alias: json["alias"],
      version: json["version"] ?? "2.0",
      deviceModel: json["deviceModel"],
      deviceType: json["deviceType"],
      fingerprint: json["fingerprint"],
      port: json["port"] ?? 53317,
      protocol: json["protocol"] ?? "https",
      download: json["download"] ?? false,
      announce: json["announce"] ?? true,
    );
  }

  /// 从 JSON 字符串解析
  factory BroadcastInfo.fromJsonString(String source) =>
      BroadcastInfo.fromJson(jsonDecode(source));
}
