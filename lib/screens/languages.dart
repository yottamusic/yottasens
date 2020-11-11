import 'package:flutter/material.dart';
import 'package:yottasens/blocs/bloc_provider.dart';
import 'package:yottasens/blocs/translations_bloc.dart';
import 'package:yottasens/utils/global_translations.dart';

class LanguageScreen extends StatefulWidget {
  LanguageScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _LanguageScreenState createState() => new _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {

  BuildContext _scaffoldContext;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    // Retrieves the BLoC that handles the changes to the current language
    final TranslationsBloc translationsBloc = BlocProvider.of<TranslationsBloc>(context);

    Widget body = new Container(
      padding: EdgeInsets.only(top: 5.0),
      child: new ListView(
        children: <Widget>[
          Card(
            child: ListTile(
              title: Text(allTranslations.text("settings.languages.chinese")),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                debugPrint("Chinese");
                translationsBloc.setNewLanguage("zh");
                showLanguageChangeSnackBar(_scaffoldContext);
                },
            ),
            elevation: 5.0,
            margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          ),
          Card(
            child: ListTile(
              title: Text(allTranslations.text("settings.languages.hindi")),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                debugPrint("Hindi");
                translationsBloc.setNewLanguage("hi");
                showLanguageChangeSnackBar(_scaffoldContext);
              },
            ),
            elevation: 5.0,
            margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          ),
          Card(
            child: ListTile(
              title: Text(allTranslations.text("settings.languages.spanish")),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                debugPrint("Spanish");
                translationsBloc.setNewLanguage("es");
                showLanguageChangeSnackBar(_scaffoldContext);
              },
            ),
            elevation: 5.0,
            margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          ),
          Card(
            child: ListTile(
              title: Text(allTranslations.text("settings.languages.english")),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                debugPrint("English");
                translationsBloc.setNewLanguage("en");
                showLanguageChangeSnackBar(_scaffoldContext);
              },
            ),
            elevation: 5.0,
            margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          ),
        ],
      )
    );
    return new Scaffold(
          appBar: AppBar(
            elevation: 0.1,
            backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
            title: Text(allTranslations.text("settings.languages.title")),
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          //drawer: Drawer(child: yottaSensDrawer(context)),
          body: new Builder(builder: (BuildContext context) {
            _scaffoldContext = context;
            return body;
          }));
  }

  void showLanguageChangeSnackBar(BuildContext context) {
    final retrySnackBar = SnackBar(
        content: Text(allTranslations.text("settings.languages.snackBar")),
        duration: new Duration(seconds: 5),
        action: SnackBarAction(
          label: "DONE",
          onPressed: () => debugPrint("Connection Error"),
        ));

    Scaffold.of(context).showSnackBar(retrySnackBar);
  }
}
