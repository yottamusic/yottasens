import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yottasens/blocs/discover_bloc.dart';
import 'package:yottasens/model/device.dart';
import 'package:yottasens/services/device_discovery.dart';
import 'package:yottasens/utils/global_translations.dart';
import 'package:yottasens/screens/webview.dart';


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

  @override
  initState() {
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
          child: BlocConsumer<DiscoverBloc, DiscoverState>(
            listener: (context, state) {
              if (state is DiscoverError) {
                Scaffold.of(context).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
            builder: (context, state) {
              if (state is DiscoverInitial) {
                return buildInitialInput();
              } else if (state is Discovering) {
                return buildLoading();
              } else if (state is DiscoveryLoaded) {
                return showDiscoveredDevices(state.uniqueDevices);
              } else {
                // (state is WeatherError)
                return buildInitialInput();
              }
            },
          ),
      ),
    );
    return new WillPopScope(
        onWillPop: _onBackPressed,
        child: new Scaffold(
          body: new BlocProvider<DiscoverBloc>(create: (context) => DiscoverBloc(DeviceDiscoveryService())..add(DiscoverDevices()), child: Builder(builder: (BuildContext context) {
            _scaffoldContext = context;
            return localDevicesBody;
          })),
          floatingActionButton: FloatingActionButton(
            onPressed: () => refreshDeviceList(_scaffoldContext),
            child: Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ));
  }

  Widget buildInitialInput() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget showDiscoveredDevices(Map<String, DeviceIdentity> uniqueDevices) {
    if(uniqueDevices.length > 0) {
      return new ListView.builder(
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
      );
    }
    else {
      return Center(child: Text("Couldn't discover devices over mDNS. Are there any devices powered on in the network?"));
    }
  }

  void _handleURLButtonPress(BuildContext context, String deviceName, String url) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewContainer(title: deviceName, url: url)));
  }

  void refreshDeviceList(BuildContext context) {
    final discoveryBloc = context.bloc<DiscoverBloc>();
    discoveryBloc.add(DiscoverDevices());
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
