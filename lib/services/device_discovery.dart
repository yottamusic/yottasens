import 'dart:io';
import 'package:multicast_dns/multicast_dns.dart';
import 'package:network/network.dart';
import 'package:yottasens/blocs/discover_bloc.dart';
import 'package:yottasens/model/device.dart';

abstract class DiscoveryService {
  /// Throws [NetworkException].
  Future<Map<String, DeviceIdentity>> discoverDevices(String domainName);
}

class DeviceDiscoveryService implements DiscoveryService {
  @override
  Future<Map<String, DeviceIdentity>> discoverDevices(String domainName) async {
    if (domainName == null) {
      print('''Please provide a valid address as argument.
      For example: dart mdns-resolve.dart dartino.local''');
      throw DiscoverError("Invalid service type or domain name");
    }

    Map uniqueDevices = Map<String, DeviceIdentity>();
    //const String domainName = '_yottamusic._tcp.local';
    var factory = (dynamic host, int port, {bool reuseAddress, bool reusePort, int ttl}) {
      return RawDatagramSocket.bind(host, port, reuseAddress: true, reusePort: false, ttl: ttl);
    };

    final MDnsClient mDNSClient = MDnsClient(rawDatagramSocketFactory: factory);
    await mDNSClient.start();
    await for (PtrResourceRecord ptr in mDNSClient.lookup<PtrResourceRecord>(ResourceRecordQuery.serverPointer(domainName))) {
      await for (SrvResourceRecord srv in mDNSClient.lookup<SrvResourceRecord>(ResourceRecordQuery.service(ptr.domainName))) {
        await for (IPAddressResourceRecord ip in mDNSClient.lookup<IPAddressResourceRecord>(ResourceRecordQuery.addressIPv4(srv.target))) {
          // Domain name will be something like "io.flutter.example@some-iphone.local._yottamusic._tcp.local"
          // final String bundleId = ptr.domainName; //.substring(0, ptr.domainName.indexOf('@'));
          // print('${ptr.name}' ' mDNS Service found at ' '${srv.target}:${srv.port} for ${ptr.domainName} with ${ip.address.address} & Name: ${srv.name.substring(0,srv.name.indexOf('.'))}.');
          uniqueDevices[srv.name.substring(0,srv.name.indexOf('.'))] = new DeviceIdentity(srv.name.substring(0,srv.name.indexOf('.')), ptr.name, srv.target, ip.address.address, srv.port.toString());
        }
      }
    }
    mDNSClient.stop();
    return uniqueDevices;
  }
}