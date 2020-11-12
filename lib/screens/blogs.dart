import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yottasens/utils/global_translations.dart';

class BlogPostsScreen extends StatefulWidget {
  BlogPostsScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _BlogPostsScreenState createState() => new _BlogPostsScreenState();
}

class _BlogPostsScreenState extends State<BlogPostsScreen> {
  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        title: new Text(allTranslations.text("dialog.title")),
        content: new Text(allTranslations.text("dialog.content")),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(allTranslations.text("dialog.no"), style: TextStyle(fontSize: 16.0, color: Colors.red)),
          ),
          FlatButton(
            onPressed: () => SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop'),
            child: Text(allTranslations.text("dialog.yes"), style: TextStyle(fontSize: 16.0, color: Colors.blue)),
          ),
        ],
      ),
    ) ??
        false;
  }

  BuildContext _scaffoldContext;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget body = Center(
      child: new Text(allTranslations.text("blog.content")),
    );

    return new WillPopScope(
        onWillPop: _onBackPressed,
        child: new Scaffold(
          body: new Builder(builder: (BuildContext context) {
            _scaffoldContext = context;
            return body;
          }),
        ));
  }
}
