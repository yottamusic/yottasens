import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:yottasens/screens/home.dart';
import 'package:yottasens/screens/intro.dart';
import 'package:yottasens/screens/splash.dart';
import 'package:yottasens/utils/global_translations.dart';
import 'package:yottasens/blocs/bloc_provider.dart';
import 'package:yottasens/blocs/translations_bloc.dart';

var routes = <String, WidgetBuilder>{
  "/home": (BuildContext context) => HomeScreen(),
  "/intro": (BuildContext context) => IntroScreen(),
};

void main() async {
  // Ensure the Initialization
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the translations module
  await allTranslations.init();

  // Start the application
  runApp(new YottaSensApp());
}

class YottaSensApp extends StatefulWidget {
  @override
  _YottaSensAppState createState() => _YottaSensAppState();
}

class _YottaSensAppState extends State<YottaSensApp> {
  TranslationsBloc translationsBloc;

  @override
  void initState() {
    super.initState();
    translationsBloc = TranslationsBloc();
  }

  @override
  void dispose() {
    translationsBloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TranslationsBloc>(
      bloc: translationsBloc,
      child: StreamBuilder<Locale>(
          stream: translationsBloc.currentLocale,
          initialData: allTranslations.locale,
          builder: (BuildContext context, AsyncSnapshot<Locale> snapshot) {

            return MaterialApp(
                theme: ThemeData(primaryColor: Colors.blueGrey, accentColor: Colors.blueAccent),
                debugShowCheckedModeBanner: false,
                locale: snapshot.data ?? allTranslations.locale,
                localizationsDelegates: [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                ],
                supportedLocales: allTranslations.supportedLocales(),
                home: SplashScreen(),
                routes: routes
            );
          }
      ),
    );
  }
}