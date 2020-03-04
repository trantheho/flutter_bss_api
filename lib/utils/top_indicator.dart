
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

  @override
  void initState() {
    super.initState();
    screenSize = widget.screenSize;
    section = screenSize.width / 8;
    spacePadding = section - 15;


  }


  @override
  void dispose() {
    super.dispose();
    if(animationController != null){
      animationController.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(



    );
  }

  void setupAnimation( int startIndex, int endIndex){
    animationController = new AnimationController(
    duration:new Duration(microseconds: 500), vsync: this,);
  }
}


