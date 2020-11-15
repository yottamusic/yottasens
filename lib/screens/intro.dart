import 'package:fancy_on_boarding/fancy_on_boarding.dart';
import 'package:flutter/material.dart';
import 'package:yottasens/utils/global_translations.dart';
import 'package:yottasens/utils/navigator.dart';

class IntroScreen extends StatefulWidget {
  @override
  IntroScreenState createState() {
    return IntroScreenState();
  }
}

class IntroScreenState extends State<IntroScreen> {

  final pageList = [
    PageModel(
        color: const Color(0xFF678FB4),
        heroImagePath: 'images/yottasens-logo.png',
        title: Text(allTranslations.text("intro.page1.title"),
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: Colors.white,
              fontSize: 34.0,
            )),
        body: Text(allTranslations.text("intro.page1.content"),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            )),
        iconImagePath: 'images/yottasens-logo.png'),
    PageModel(
        color: const Color(0xFF65B0B4),
        heroImagePath: 'images/truequality-logo.png',
        title: Text(allTranslations.text("intro.page2.title"),
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: Colors.white,
              fontSize: 34.0,
            )),
        body: Text(allTranslations.text("intro.page2.content"),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            )),
        iconImagePath: 'images/truequality-logo.png'),
    PageModel(
      color: const Color(0xFF9B90BC),
      heroImagePath: 'images/eqshare-logo.png',
      title: Text(allTranslations.text("intro.page3.title"),
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: Colors.white,
            fontSize: 34.0,
          )),
      body: Text(allTranslations.text("intro.page3.content"),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          )),
      iconImagePath: 'images/eqshare-logo.png',
    ),
    // SVG Pages Example
    PageModel(
        color: const Color(0xFF678FB4),
        heroImagePath: 'images/blockchain-logo.png',
        title: Text(allTranslations.text("intro.page4.title"),
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: Colors.white,
              fontSize: 34.0,
            )),
        body: Text(allTranslations.text("intro.page4.content"),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            )),
        iconImagePath: 'images/blockchain-logo.png',
        heroImageColor: Colors.white),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FancyOnBoarding(
        doneButtonText: allTranslations.text("intro.gotIt"),
        skipButtonText: allTranslations.text("intro.skip"),
        pageList: pageList,
        onDoneButtonPressed: () => YottaSensNavigator.goToHome(context),
        onSkipButtonPressed: () => YottaSensNavigator.goToHome(context),
      ),
    );
  }
}
