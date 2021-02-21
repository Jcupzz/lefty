import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lefty/Theme/ThemeController.dart';

class Horizontal_Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var brightness = Theme.of(context).brightness;
    return Container(
        color: Theme.of(context).backgroundColor,
        child: Center(
          child: SpinKitThreeBounce(
            color: brightness == Brightness.light?Colors.teal[700]:Colors.white,
            size: 80.0,
          ),
        ));
  }
}
