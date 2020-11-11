import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yottasens/screens/blogs.dart';
import 'package:yottasens/screens/cloud.dart';
import 'package:yottasens/screens/local.dart';
import 'package:yottasens/screens/settings.dart';
import 'package:yottasens/utils/global_translations.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  //BuildContext _scaffoldContext;
  int _currentIndex = 0;
  final List<Widget> _children = [
    LocalScreen(),
    CloudScreen(),
    BlogPostsScreen(),
    SettingsScreen()
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: _onBackPressed,
        child: new Scaffold(
          //backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Color.fromRGBO(30, 31, 36, 0.08),
                  blurRadius: 20.0,
                  spreadRadius: 10.0),
            ]),
            child: ClipRRect(
              borderRadius: BorderRadius.only(topRight: Radius.circular(16), topLeft: Radius.circular(16)),
              child: BottomNavigationBar(
                  backgroundColor: Colors.white,
                  selectedIconTheme: IconThemeData(color: Colors.white10),
                  type: BottomNavigationBarType.fixed,
                  currentIndex: _currentIndex, // this will be set when a new tab is tapped
                  items: [
                    BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.wifi, color: _currentIndex == 0 ? Colors.black : Colors.grey), label: 'Local'),
                    BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.cloud, color: _currentIndex == 1 ? Colors.black : Colors.grey), label: 'Cloud'),
                    BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.blog, color: _currentIndex == 2 ? Colors.black : Colors.grey), label: 'Blog'),
                    BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.cog, color: _currentIndex == 3 ? Colors.black : Colors.grey), label: 'Settings'),
                  ],
                  onTap: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  }),
            ),
          ),
          appBar: AppBar(
            elevation: 0.1,
            backgroundColor: Colors.blueAccent,
            title: Text(allTranslations.text("splashScreen.name")),
            automaticallyImplyLeading: false
          ),
          body: new Builder(builder: (BuildContext context) {
            //_scaffoldContext = context;
            return SafeArea(child: _children[_currentIndex]);
          }),
        ));
  }

}
