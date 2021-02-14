import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(milliseconds: 4000), () {
      Navigator.pushReplacementNamed(context, '/Register');
    });

    return Scaffold(
      backgroundColor: Colors.purple[900],
      body: Shimmer.fromColors(
        baseColor: Colors.deepOrange[400],
        highlightColor: Colors.deepOrange[200],
        period: Duration(milliseconds: 1000),
        child: Container(
          padding: EdgeInsets.all(16),
          child: Center(
            child: Text(
              "Listy.",
              style: TextStyle(
                fontSize: 120,
                fontFamily: 'Lobster',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
