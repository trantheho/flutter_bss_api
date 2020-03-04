
import 'dart:math';

import 'package:flutter/material.dart';

class TopIndicator extends StatefulWidget {
  final Size screenSize;
  final int startIndex;
  final int endIndex;

  TopIndicator({this.screenSize, this.startIndex, this.endIndex});

  @override
  _TopIndicatorState createState() => _TopIndicatorState();
}

class _TopIndicatorState extends State<TopIndicator> with TickerProviderStateMixin {

  AnimationController animationController;
  Animation<double> dxTransition;

  Size screenSize;
  double section;
  double spacePadding;
  double height;
  double iconSize ;

  @override
  void initState() {
    super.initState();
    iconSize = 30;
    height = 10;
    screenSize = MediaQuery.of(context).size;
    section = screenSize.width / 8;
    spacePadding = section - iconSize /2;

    setupAnimation(widget.startIndex, widget.endIndex);

  }


  @override
  void dispose() {
    super.dispose();
    if(animationController != null){
      animationController.dispose();
    }
  }

  @override
  void didUpdateWidget(TopIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.startIndex != widget.startIndex ||
        oldWidget.endIndex != widget.endIndex) {
      setupAnimation(widget.startIndex, widget.endIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    return indicatorIcon();
   /* return Center(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(bottom: 2),
                  child: Image(image: AssetImage('assets/icons/ic_up_arrow.png'), width: 10, height: 10,)),
              Container(
                width: 30,
                height: 2,
                color: Colors.green[700],
              ),
            ],
          ),
        ],
      ),
    );*/
  }

  void setupAnimation( int startIndex, int endIndex){
    animationController = new AnimationController(
    duration:new Duration(microseconds: 500), vsync: this,);

    dxTransition = new Tween<double>(
        begin: section * (startIndex * 2 + 1),
        end: section * (endIndex * 2 + 1))
        .animate(intervalCurved(0.0, 1.0));

    animationController
      ..addListener(() {
        setState(() {});
      });

    if (startIndex != endIndex) {
      animationController.forward();
    }

  }

  CurvedAnimation intervalCurved(begin, end, [curve = Curves.easeInOut]) {
    return new CurvedAnimation(
      parent: animationController,
      curve: new Interval(begin, end, curve: curve),
    );
  }

  Widget indicatorIcon() {
    return new Container(
      width: screenSize.width,
      height: height,
      /*padding: new EdgeInsets.symmetric(
        vertical: height / 2 - iconSize / 2,
      ),*/
      child: new Stack(
        children: <Widget>[
          getIcon(0),
          getIcon(1),
          getIcon(2),
          getIcon(3),
          getIcon(4),
        ],
      ),
    );
  }

  Widget getIcon(index) {
    return new Positioned(
      left: section * (index * 1.5 + 1) - iconSize / 2,
      child: new Container(
        width: 20,
        height: 20,
        alignment: Alignment.center,
        child: new Text('x'),
      ),
    );
  }

}

class _TabIndicationPainter extends CustomPainter {
  Paint painter;
  final double dxTarget;
  final double dxEntry;
  final double radius;
  final double dy;

  _TabIndicationPainter(
      {this.dxTarget = 200.0,
        this.dxEntry = 50.0,
        this.radius = 25.0,
        this.dy = 25.0}) {
    painter = new Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    bool left2right = dxEntry < dxTarget;
    Offset entry = new Offset(left2right ? dxEntry : dxTarget, dy);
    Offset target = new Offset(left2right ? dxTarget : dxEntry, dy);

    Path path = new Path();
    path.addArc(
        new Rect.fromCircle(center: entry, radius: radius), 0.5 * pi, 1 * pi);
    path.addRect(
        new Rect.fromLTRB(entry.dx, dy - radius, target.dx, dy + radius));
    path.addArc(
        new Rect.fromCircle(center: target, radius: radius), 1.5 * pi, 1 * pi);
    canvas.drawPath(path, painter);
  }

  @override
  bool shouldRepaint(_TabIndicationPainter oldDelegate) => true;
}


