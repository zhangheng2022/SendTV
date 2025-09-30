// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'broadcast_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BroadcastInfo _$BroadcastInfoFromJson(Map<String, dynamic> json) =>
    BroadcastInfo(
      alias: json['alias'] as String,
      version: json['version'] as String? ?? "2.0",
      deviceModel: json['deviceModel'] as String?,
      deviceType: json['deviceType'] as String?,
      fingerprint: json['fingerprint'] as String,
      port: (json['port'] as num?)?.toInt() ?? 53331,
      protocol: json['protocol'] as String? ?? "https",
      announce: json['announce'] as bool? ?? true,
    );

Map<String, dynamic> _$BroadcastInfoToJson(BroadcastInfo instance) =>
    <String, dynamic>{
      'alias': instance.alias,
      'version': instance.version,
      'deviceModel': instance.deviceModel,
      'deviceType': instance.deviceType,
      'fingerprint': instance.fingerprint,
      'port': instance.port,
      'protocol': instance.protocol,
      'announce': instance.announce,
    };
