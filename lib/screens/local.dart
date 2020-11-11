import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yottasens/utils/global_translations.dart';
import 'package:yottasens/screens/webview.dart';
import 'package:flutter_mdns_plugin/flutter_mdns_plugin.dart';

const String discovery_service = "_yottamusic._tcp";

class DeviceIdentity {
  String name;
  String type;
  String hostName;
  String address;
  String port;

  DeviceIdentity(String _name, String _type, String _hostname, String _address,
      String _port) {
    name = _name;
    type = _type;
    hostName = _hostname;
    address = _address;
    port = _port;
  }

  factory DeviceIdentity.fromCSV(String strCSV) {
    List<String> deviceID = strCSV.split(new RegExp(',\\s+'));
    return new DeviceIdentity(deviceID[0], deviceID[1], deviceID[2], deviceID[3], deviceID[4]);
  }

  factory DeviceIdentity.fromDeviceIdentity(DeviceIdentity deviceID) {
    return new DeviceIdentity(deviceID.name, deviceID.type, deviceID.hostName, deviceID.address, deviceID.port);
  }

  @override
  String toString() {
    return '${this.name}, ${this.type}, ${this.hostName}, ${this.address}, ${this.port}';
  }
}

class LocalScreen extends StatefulWidget {
  @override
  _LocalScreenState createState() => new _LocalScreenState();
}

class _LocalScreenState extends State<LocalScreen> {
  FlutterMdnsPlugin _mdnsPlugin;
  List<String> messageLog = <String>[];
  Map uniqueDevices = Map<String, DeviceIdentity>();
  List<DeviceIdentity> uniqueConnectedDevices = <DeviceIdentity>[];
  DiscoveryCallbacks discoveryCallbacks;
  List<ServiceInfo> _discoveredServices = <ServiceInfo>[];

  BuildContext _scaffoldContext;

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

  @override
  initState() {
    super.initState();

    discoveryCallbacks = new DiscoveryCallbacks(
      onDiscovered: (ServiceInfo info) {
        print("Discovered ${info.toString()}");
        setState(() {
          messageLog.insert(0, "DISCOVERY: Discovered ${info.toString()}");
          debugPrint("Name: ${info.name}");
        });
      },
      onDiscoveryStarted: () {
        messageLog.clear();
        uniqueConnectedDevices.clear();
        print("Discovery started");
        setState(() {
          messageLog.add("DISCOVERY: Discovery Running");
          debugPrint("Name: Discovery Started");
        });
      },
      onDiscoveryStopped: () {
        print("Discovery stopped");
        setState(() {
          messageLog.add("DISCOVERY: Discovery Not Running");
          debugPrint("Name: No Discovery");
        });
      },
      onResolved: (ServiceInfo info) {
        print("Resolved Service ${info.toString()}");
        setState(() {
          messageLog.add("DISCOVERY: Resolved ${info.toString()}");
          uniqueDevices[info.name] = new DeviceIdentity("${info.name}", "${info.type}", "${info.hostName}", "${info.address}", "${info.port}");
          uniqueDevices.forEach((key, value) => debugPrint(value.toString()));
          uniqueConnectedDevices.clear();
          uniqueDevices.forEach((key, value) => uniqueConnectedDevices.add(DeviceIdentity.fromDeviceIdentity(value)));
          debugPrint("Unique: " + uniqueDevices.length.toString() + " UniqueList: " + uniqueConnectedDevices.toString());
        });
      },
    );

    messageLog.add("Starting mDNS for service [$discovery_service]");
    startMdnsDiscovery(discovery_service);
  }

  startMdnsDiscovery(String serviceType) {
    _mdnsPlugin = new FlutterMdnsPlugin(discoveryCallbacks: discoveryCallbacks);
    //Timer(Duration(seconds: 3), () => _mdnsPlugin.startDiscovery(serviceType));
    _mdnsPlugin.startDiscovery(serviceType);
  }

  void reassemble() {
    super.reassemble();

    if (null != _mdnsPlugin) {
      _discoveredServices = <ServiceInfo>[];
      _mdnsPlugin.restartDiscovery();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget body = new Center(
      child: Container(
          padding: EdgeInsets.only(left: 0.0, top: 0.0),
          alignment: Alignment.center,
          color: Colors.white10,
          child: new ListView.builder(
            //reverse: true,
            itemCount: uniqueConnectedDevices.length,
            itemBuilder: (BuildContext context, int index) {
              //String devicesKey = uniqueDevices.keys.elementAt(index);
              //return new Text(deviceIdentity[index].name);
              return new ListTile(
                leading: Icon(Icons.donut_large),
                title: Text(uniqueConnectedDevices[index].name + " (Hostname: ${uniqueConnectedDevices[index].hostName} )"),
                subtitle: Text(
                    "IP: ${uniqueConnectedDevices[index].address} Port: ${uniqueConnectedDevices[index].port}"),
                trailing: Icon(Icons.chevron_right),
                //onTap: () => debugPrint("${deviceIdentity[index].name} Clicked"),
                onTap: () => _handleURLButtonPress(context, uniqueConnectedDevices[index].name,
                    ("http://${uniqueConnectedDevices[index].hostName}:${uniqueConnectedDevices[index].port}")),
              );
            },
          )),
    );
    return new WillPopScope(
        onWillPop: _onBackPressed,
        child: new Scaffold(
          body: new Builder(builder: (BuildContext context) {
            _scaffoldContext = context;
            return body;
          }),
          floatingActionButton: FloatingActionButton(
            onPressed: () => refreshDeviceList(_scaffoldContext),
            child: Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ));
  }

  void _handleURLButtonPress(BuildContext context, String deviceName, String url) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => WebViewContainer(title: deviceName, url: url,)));
  }

  void refreshDeviceList(BuildContext context) {
    debugPrint("Refresh Device List");
    startMdnsDiscovery(discovery_service);
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
