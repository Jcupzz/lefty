import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lefty/static/Circular_Loading.dart';
import 'package:webview_flutter/webview_flutter.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  bool isLoaded = false;

  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }
  int _indexStack = 1;
  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: _indexStack,
      children: [
        SafeArea(
          child: WebView(
            onPageFinished: (String url) {
              setState(() {
                _indexStack = 0;
              });
            },
            javascriptMode: JavascriptMode.unrestricted,
            initialUrl: 'https://www.notion.so/Lefty-fc3ef66584314d1a8f4a50bd16574a5d',
          ),
        ),
        Circular_Loading(),
      ],
    );
  }
}
