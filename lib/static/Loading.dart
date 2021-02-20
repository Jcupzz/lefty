import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lefty/Theme/ThemeController.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: ThemeController.to.themeMode == ThemeMode.light?Colors.teal[100]:Colors.black,
        child: Center(
          child: SpinKitRipple(
            color: ThemeController.to.themeMode == ThemeMode.light?Colors.teal[700]:Colors.white,
            size: 80.0,
          ),
        ));
  }
}
