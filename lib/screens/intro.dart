import 'package:flutter/material.dart';
import 'package:yottasens/utils/global_translations.dart';
import 'package:yottasens/utils/navigator.dart';
import 'package:yottasens/widgets/WalkThrough.dart';

class IntroScreen extends StatefulWidget {
  @override
  IntroScreenState createState() {
    return IntroScreenState();
  }
}

class IntroScreenState extends State<IntroScreen> {
  final PageController controller = new PageController();
  int currentPage = 0;
  bool lastPage = false;

  void _onPageChanged(int page) {
    setState(() {
      currentPage = page;
      if (currentPage == 3) {
        lastPage = true;
      } else {
        lastPage = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFEEEEEE),
      padding: EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(),
          ),
          Expanded(
            flex: 3,
            child: PageView(
              children: <Widget>[
                WalkThrough(
                  title: allTranslations.text("intro.page1.title"),
                  content: allTranslations.text("intro.page1.content"),
                  imageIcon: 'images/yottasens-logo.png',
                ),
                WalkThrough(
                  title: allTranslations.text("intro.page2.title"),
                  content: allTranslations.text("intro.page2.content"),
                  imageIcon: 'images/truequality-logo.png',
                ),
                WalkThrough(
                  title: allTranslations.text("intro.page3.title"),
                  content: allTranslations.text("intro.page3.content"),
                  imageIcon: 'images/eqshare-logo.png',
                ),
                WalkThrough(
                  title: allTranslations.text("intro.page4.title"),
                  content: allTranslations.text("intro.page4.content"),
                  imageIcon: 'images/blockchain-logo.png',
                ),
              ],
              controller: controller,
              onPageChanged: _onPageChanged,
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  child: Text(lastPage ? "" : allTranslations.text("intro.skip"),
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0)),
                  onPressed: () =>
                      lastPage ? null : YottaSensNavigator.goToHome(context),
                ),
                FlatButton(
                  child: Text(lastPage ? allTranslations.text("intro.gotIt") : allTranslations.text("intro.next"),
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0)),
                  onPressed: () => lastPage
                      ? YottaSensNavigator.goToHome(context)
                      : controller.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeIn),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
