import 'package:flutter/material.dart';

class WalkThrough extends StatefulWidget {
  final title;
  final content;
  final imageIcon;
  final imageColor;

  WalkThrough(
      {this.title,
      this.content,
      this.imageIcon,
      this.imageColor = Colors.blueGrey});

  @override
  WalkThroughState createState() {
    return WalkThroughState();
  }
}

class WalkThroughState extends State<WalkThrough>
    with SingleTickerProviderStateMixin {
  Animation animation;
  AnimationController animationController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    animation = Tween(begin: -250.0, end: 0.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeInOut));

    animation.addListener(() => setState(() {}));

    animationController.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: EdgeInsets.all(20.0),
      child: Material(
        animationDuration: Duration(milliseconds: 500),
        elevation: 2.0,
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Transform(
              transform:
                  new Matrix4.translationValues(animation.value, 0.0, 0.0),
              child: new Text(
                widget.title,
                style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            new Transform(
              transform:
                  new Matrix4.translationValues(animation.value, 0.0, 0.0),
              child: new Text(widget.content,
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 18.0,
                      color: Colors.black)),
            ),
            showIcon()
          ],
        ),
      ),
    );
  }

  Image showIcon() {
    AssetImage assetImage = AssetImage(widget.imageIcon);
    Image image = Image(
      image: assetImage,
      width: 250.0,
      height: 250.0,
    );
    return image;
  }
}
