import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.purple[900],
        child: Center(
          child: SpinKitRipple(
            color: Colors.deepOrange[200],
            size: 70.0,
          ),
        ));
  }
}
