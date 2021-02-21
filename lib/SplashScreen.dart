import 'package:flutter/material.dart';
import 'package:lefty/MyBottomNavigationBar.dart';
import 'package:shimmer/shimmer.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(milliseconds: 4000), () {
      Navigator.pushReplacementNamed(context, '/Home');
    });

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Shimmer.fromColors(
        baseColor: Theme.of(context).hintColor,
        highlightColor: Colors.white,
        period: Duration(milliseconds: 1000),
        child: Container(
          padding: EdgeInsets.all(16),
          child: Center(
            child: Text(
              "Lefty.",
              style: Theme.of(context).textTheme.bodyText2.apply(fontSizeFactor: 10,fontFamily: 'Lobster'),
            ),
          ),
        ),
      ),
    );
  }
}
