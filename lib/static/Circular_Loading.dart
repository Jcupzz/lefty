import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:lefty/Theme/ThemeController.dart';

class Circular_Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var brightness = Theme.of(context).brightness;
    ThemeData themeData;
    return Container(
        color: Theme.of(context).backgroundColor,
        child: Center(
          child: SpinKitChasingDots(
            color: brightness == Brightness.light?Colors.teal[700]:Colors.white,
            size: 100.0,
          ),
        ));
  }
}
