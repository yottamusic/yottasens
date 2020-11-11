import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yottasens/screens/languages.dart';
import 'package:yottasens/utils/global_translations.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _SettingsScreenState createState() => new _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
                onPressed: () => SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop'),
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

  //BuildContext _scaffoldContext;
  File _imageFilePath;
  bool _isSelected = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Widget body = Theme(
      data: Theme.of(context).copyWith(
        brightness: Brightness.light,
        primaryColor: Colors.purple,
      ),
      child: DefaultTextStyle(
        style: TextStyle(
          color: Colors.white,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 10.0),
              Row(
                children: <Widget>[
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: _imageFilePath == null
                            ? AssetImage('images/profile.png')
                            : FileImage(_imageFilePath),
                        fit: BoxFit.cover,
                      ),
                      border: Border.all(
                        color: Colors.black,
                        width: 2.0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          allTranslations.text("settings.profile"),
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                        Text(
                          allTranslations.text("settings.profileSubtitle"),
                          style: TextStyle(
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              ListTile(
                leading: Container(
                  padding: EdgeInsets.only(right: 12.0),
                  decoration: new BoxDecoration(
                      border: new Border(
                          right: new BorderSide(
                              width: 1.0, color: Colors.black26))),
                  child: Icon(Icons.language, color: Colors.black38),
                ),
                title: Text(
                    allTranslations.text("settings.languages.option"),
                  style: TextStyle(
                      color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
//                subtitle: Text("Change App Language", style: TextStyle(color: Colors.grey.shade400)),
                trailing: Icon(Icons.keyboard_arrow_right,
                    color: Colors.black, size: 30.0),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => LanguageScreen()));
                },
              ),
              SwitchListTile(
                title: Text(
                  allTranslations.text("settings.pushNotifications"),
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                subtitle: Text(
                  _isSelected == false ? allTranslations.text("settings.offState") : allTranslations.text("settings.onState"),
                  style: TextStyle(
                    color: Colors.grey.shade400,
                  ),
                ),
                value: _isSelected,
                onChanged: (bool newValue) {
                  setState(() {
                    _isSelected = newValue;
                  });
                },
              )
            ],
          ),
        ),
      ),
    );

    return new WillPopScope(
        onWillPop: _onBackPressed,
        child: new Scaffold(
          body: new Builder(builder: (BuildContext context) {
            //_scaffoldContext = context;
            return body;
          }),
        ));
  }
}
