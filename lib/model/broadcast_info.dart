import 'package:json_annotation/json_annotation.dart';

part 'broadcast_info.g.dart';

@JsonSerializable()
class BroadcastInfo {
  final String alias;
  final String version; // 协议版本（major.minor）
  final String? deviceModel;
  final String? deviceType; // mobile | desktop | web | headless | server
  final String fingerprint; // 随机字符串
  final int port;
  final String protocol; // http | https
  final bool announce;

  BroadcastInfo({
    required this.alias,
    this.version = "2.0",
    this.deviceModel,
    this.deviceType,
    required this.fingerprint,
    this.port = 53331,
    this.protocol = "https",
    this.announce = true,
  });

  factory BroadcastInfo.fromJson(Map<String, dynamic> json) =>
      _$BroadcastInfoFromJson(json);

  Map<String, dynamic> toJson() => _$BroadcastInfoToJson(this);
}
