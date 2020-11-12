import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multicast_dns/multicast_dns.dart';
import 'package:yottasens/model/device.dart';
import 'package:yottasens/utils/global_translations.dart';
import 'package:yottasens/screens/webview.dart';

const String discovery_service = "_yottamusic._tcp.local";

class LocalScreen extends StatefulWidget {
  @override
  _LocalScreenState createState() => new _LocalScreenState();
}

class _LocalScreenState extends State<LocalScreen> {
  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0)),
        title: new Text(allTranslations.text("dialog.title")),
        content: new Text(allTranslations.text("dialog.content")),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              allTranslations.text("dialog.no"),
              style: TextStyle(fontSize: 16.0, color: Colors.red),
            ),
          ),
          FlatButton(
            onPressed: () => SystemChannels.platform
                .invokeMethod<void>('SystemNavigator.pop'),
            child: Text(
              allTranslations.text("dialog.yes"),
              style: TextStyle(fontSize: 16.0, color: Colors.blue),
            ),
          ),
        ],
      ),
    ) ??
        false;
  }

  BuildContext _scaffoldContext;
  Map uniqueDevices = Map<String, DeviceIdentity>();

  void mDNSDiscover(String domainName) async {
    if (domainName == null) {
      print('''Please provide a valid address as argument.
      For example: dart mdns-resolve.dart dartino.local''');
      return;
    }

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
    debugPrint("Unique: " + uniqueDevices.length.toString() + " UniqueMap: " + uniqueDevices.toString());
  }

  @override
  initState() {
    mDNSDiscover(discovery_service);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget localDevicesBody = new Center(
      child: Container(
          padding: EdgeInsets.only(left: 0.0, top: 0.0),
          alignment: Alignment.center,
          color: Colors.white10,
          child: new ListView.builder(
            //reverse: true,
            itemCount: uniqueDevices.length,
            itemBuilder: (BuildContext context, int index) {
              String devicesKey = uniqueDevices.keys.elementAt(index);
              // print(uniqueDevices[devicesKey].name);
              return new ListTile(
                leading: Icon(Icons.donut_large),
                title: Text(uniqueDevices[devicesKey].name + " (Hostname: ${uniqueDevices[devicesKey].hostName} )"),
                subtitle: Text("IP: ${uniqueDevices[devicesKey].address} Port: ${uniqueDevices[devicesKey].port}"),
                trailing: Icon(Icons.chevron_right),
                // onTap: () => debugPrint("${uniqueDevices[devicesKey].name} Clicked"),
                onTap: () => _handleURLButtonPress(context, uniqueDevices[devicesKey].name, ("http://${uniqueDevices[devicesKey].address}:${uniqueDevices[devicesKey].port}")),
              );
            },
          )),
    );
    return new WillPopScope(
        onWillPop: _onBackPressed,
        child: new Scaffold(
          body: new Builder(builder: (BuildContext context) {
            _scaffoldContext = context;
            return localDevicesBody;
          }),
          floatingActionButton: FloatingActionButton(
            onPressed: () => refreshDeviceList(_scaffoldContext),
            child: Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ));
  }

  void _handleURLButtonPress(BuildContext context, String deviceName, String url) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewContainer(title: deviceName, url: url)));
  }

  void refreshDeviceList(BuildContext context) {
    // Navigator.push(context, new MaterialPageRoute(builder: (context) => this.build(context)));
    mDNSDiscover(discovery_service);
    showRetrySnackBar(context);
  }

  void showRetrySnackBar(BuildContext context) {
    final retrySnackBar = SnackBar(
        content: Text(allTranslations.text("devices.snackBar")),
        duration: new Duration(seconds: 5),
        action: SnackBarAction(
          label: "OKAY",
          onPressed: () => debugPrint("Scanning..."),
        ));

    Scaffold.of(context).showSnackBar(retrySnackBar);
  }
}
