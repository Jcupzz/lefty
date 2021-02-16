import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lefty/Authentication/Login.dart';
import 'package:lefty/Authentication/Register.dart';
import 'package:lefty/Home.dart';
import 'package:lefty/Pages/Create.dart';
import 'package:lefty/Pages/Location.dart';

class MyBottomNavigationBar extends StatefulWidget {
  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  int _page = 0;
  final _pageOption = [
    Home(),
    Create(),
    Location(),
    Register(),
  ];

  @override
  Widget build(BuildContext context) {
    HapticFeedback.heavyImpact();
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        animationCurve: Curves.bounceInOut,
        animationDuration: Duration(milliseconds: 200),
        backgroundColor: Colors.white,
        color: Colors.black,
        buttonBackgroundColor: Colors.black,
        height: 60,
        items: <Widget>[
          Icon(
            Icons.home,
            size: 20,
            color: Colors.white,
          ),
          Icon(
            Icons.add_circle_rounded,
            size: 20,
            color: Colors.white,
          ),
          Icon(
            Icons.location_on_outlined,
            color: Colors.white,
            size: 20,
          ),
          Icon(
            Icons.person,
            size: 20,
            color: Colors.white,
          ),
        ],
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
      ),
      body: _pageOption[_page],
    );
  }
}
