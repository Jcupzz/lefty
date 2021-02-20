import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:lefty/Theme/ThemeController.dart';

class Circular_Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData themeData;
    return Container(
        color: ThemeController.to.themeMode == ThemeMode.light?Colors.white:Colors.grey[900],
        child: Center(
          child: SpinKitChasingDots(
            color: ThemeController.to.themeMode == ThemeMode.light?Colors.black:Colors.white,
            size: 100.0,
          ),
        ));
  }
}
