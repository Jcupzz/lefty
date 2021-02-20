import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lefty/Theme/ThemeController.dart';

class Horizontal_Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: ThemeController.to.themeMode == ThemeMode.light?Colors.white:Colors.grey[900],
        child: Center(
          child: SpinKitThreeBounce(
            color: ThemeController.to.themeMode == ThemeMode.light?Colors.black:Colors.white,
            size: 80.0,
          ),
        ));
  }
}
