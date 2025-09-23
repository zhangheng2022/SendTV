// 2. mDNS服务发现类
// mdns_service.dart
import 'dart:async';
import 'dart:io';
import 'package:multicast_dns/multicast_dns.dart';
import 'package:send_tv/utils/logger.dart';

class MDNSService {
  MDnsClient? _client;
  static const String _serviceType = '_sendtv._tcp';
  static const String _serviceName = 'SendTV File Transfer';

  Future<void> start() async {
    _client = MDnsClient();
    await _client!.start();
    Log.d("🔍 mDNS 客户端启动");
  }

  Future<void> stop() async {
    _client?.stop();
    _client = null;
    Log.d("🛑 mDNS 客户端停止");
  }

  /// 发布服务
  Future<void> advertiseService({
    required String ip,
    required int port,
    String? deviceName,
  }) async {
    if (_client == null) return;

    final serviceName = deviceName ?? Platform.localHostname;

    // 发布A记录
    await _client!.start(listenAddress: InternetAddress.anyIPv4);

    Log.d("📢 发布服务: $serviceName on $ip:$port");
  }

  /// 发现服务
  Stream<DiscoveredDevice> discoverServices() async* {
    if (_client == null) {
      Log.w("mDNS客户端未启动");
      return;
    }

    Log.d("🔍 开始发现服务...");

    await for (PtrResourceRecord ptr in _client!.lookup<PtrResourceRecord>(
      ResourceRecordQuery.serverPointer(_serviceType),
    )) {
      final serviceName = ptr.domainName;
      Log.d("发现服务: $serviceName");

      // 查询SRV记录获取端口和主机
      await for (SrvResourceRecord srv in _client!.lookup<SrvResourceRecord>(
        ResourceRecordQuery.service(serviceName),
      )) {
        final host = srv.target;
        final port = srv.port;

        // 查询A记录获取IP
        await for (IPAddressResourceRecord ip
            in _client!.lookup<IPAddressResourceRecord>(
              ResourceRecordQuery.addressIPv4(host),
            )) {
          yield DiscoveredDevice(
            name: serviceName,
            host: host,
            ip: ip.address.address,
            port: port,
          );
        }
      }
    }
  }

  /// 简化的UDP广播发现
  static Future<List<DiscoveredDevice>> udpBroadcastDiscover({
    int port = 53332,
    Duration timeout = const Duration(seconds: 3),
  }) async {
    final devices = <DiscoveredDevice>[];

    try {
      // 创建UDP socket
      final socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
      socket.broadcastEnabled = true;

      // 发送广播消息
      final message = 'SENDTV_DISCOVERY';
      socket.send(message.codeUnits, InternetAddress('255.255.255.255'), port);

      Log.d("📡 发送UDP广播发现消息");

      // 监听响应
      final completer = Completer<void>();

      socket.listen((RawSocketEvent event) {
        if (event == RawSocketEvent.read) {
          final datagram = socket.receive();
          if (datagram != null) {
            final response = String.fromCharCodes(datagram.data);
            final parts = response.split(':');

            if (parts.length >= 3 && parts[0] == 'SENDTV_RESPONSE') {
              devices.add(
                DiscoveredDevice(
                  name: parts[1],
                  host: datagram.address.address,
                  ip: datagram.address.address,
                  port: int.tryParse(parts[2]) ?? 53331,
                ),
              );
              Log.d(
                "发现设备: ${parts[1]} at ${datagram.address.address}:${parts[2]}",
              );
            }
          }
        }
      });

      // 设置超时
      Timer(timeout, () {
        if (!completer.isCompleted) {
          completer.complete();
        }
      });

      await completer.future;
      socket.close();
    } catch (e) {
      Log.e("UDP广播发现错误: $e");
    }

    return devices;
  }

  /// UDP广播响应服务
  static Future<RawDatagramSocket?> startBroadcastResponder({
    required String deviceName,
    required int httpPort,
    int udpPort = 53332,
  }) async {
    try {
      final socket = await RawDatagramSocket.bind(
        InternetAddress.anyIPv4,
        udpPort,
      );

      socket.listen((RawSocketEvent event) {
        if (event == RawSocketEvent.read) {
          final datagram = socket.receive();
          if (datagram != null) {
            final message = String.fromCharCodes(datagram.data);

            if (message == 'SENDTV_DISCOVERY') {
              Log.d("收到发现请求，回复设备信息");

              // 回复设备信息
              final response = 'SENDTV_RESPONSE:$deviceName:$httpPort';
              socket.send(response.codeUnits, datagram.address, datagram.port);
            }
          }
        }
      });

      Log.d("📻 UDP广播响应服务启动在端口 $udpPort");
      return socket;
    } catch (e) {
      Log.e("启动UDP响应服务错误: $e");
      return null;
    }
  }
}

class DiscoveredDevice {
  final String name;
  final String host;
  final String ip;
  final int port;

  DiscoveredDevice({
    required this.name,
    required this.host,
    required this.ip,
    required this.port,
  });

  String get serviceUrl => "http://$ip:$port";

  @override
  String toString() => 'DiscoveredDevice($name, $ip:$port)';
}
