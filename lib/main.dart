import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:lefty/Authentication/Authentication_Services.dart';
import 'package:lefty/Authentication/Login.dart';
import 'package:lefty/Authentication/Register.dart';
import 'package:lefty/MyBottomNavigationBar.dart';
import 'package:lefty/SplashScreen.dart';
import 'package:provider/provider.dart';
import 'Theme/ThemeController.dart';

bool isVerified = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.lazyPut<ThemeController>(() => ThemeController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeController.to.getThemeModeFromPreferences();
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(create: (_) => AuthenticationService(FirebaseAuth.instance)),
        StreamProvider(
          create: (context) => context.read<AuthenticationService>().authStateChanges,
        )
      ],
      child: GetMaterialApp(
          builder: BotToastInit(),
          theme: ThemeData.light().copyWith(
            snackBarTheme: SnackBarThemeData(
              backgroundColor: Colors.black,
              actionTextColor: Colors.black,
            ),
              accentColorBrightness: Brightness.light,
              primaryColor: Color(0xff00766c),
              primaryColorDark: Color(0xFF005b4f),
              cardColor: Color(0xFF64d8cb),
              backgroundColor: Color(0xFF26a69a),
              accentColor: Color(0xFF14ffec),
              brightness: Brightness.light,
              splashColor: Colors.green[300],
              buttonColor: Color(0xFF64d8cb),
              hintColor: Colors.white,
              unselectedWidgetColor: Colors.black,
              errorColor: Colors.red[300],
              dividerColor: Colors.black,
              textTheme: TextTheme(
                  bodyText1: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  headline2: TextStyle(color: Colors.black, fontSize: 35, fontWeight: FontWeight.bold),
                  subtitle1: TextStyle(color: Colors.black, fontSize: 18),
                  headline3: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),
                  headline4: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                  bodyText2: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
                  headline1: TextStyle(color: Colors.black, fontSize: 60, fontWeight: FontWeight.bold))),
         //
         //
         //DarkTheme
         //
          darkTheme: ThemeData.dark().copyWith(
              snackBarTheme: SnackBarThemeData(
                backgroundColor: Colors.grey[850],
                actionTextColor: Colors.white,
              ),
              textTheme: TextTheme(
                  bodyText1: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  headline3: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),
                  headline2: TextStyle(color: Colors.white, fontSize: 35, fontWeight: FontWeight.bold),
                  subtitle1: TextStyle(color: Colors.white, fontSize: 18),
                  headline4: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                  bodyText2: TextStyle(color: Colors.teal[100], fontSize: 14, fontWeight: FontWeight.bold),
                  headline1: TextStyle(color: Colors.white, fontSize: 60, fontWeight: FontWeight.bold)),
              dividerColor: Colors.grey[400],
              unselectedWidgetColor: Colors.grey[400],
              errorColor: Colors.red[300],
              primaryColor: Colors.grey[850],
              hintColor: Colors.grey,
              primaryColorDark: Colors.black,
              cardColor: Colors.grey[850],
              backgroundColor: Colors.grey[900],
              accentColor: Colors.teal[100],
              brightness: Brightness.dark,
              splashColor: Colors.greenAccent,
              buttonColor: Colors.grey[700],
              accentColorBrightness: Brightness.dark),
          themeMode: ThemeController.to.themeMode,
          navigatorObservers: [BotToastNavigatorObserver()],
          home: AuthenticationWrapper(),
          routes: {
            '/SplashScreen': (context) => SplashScreen(),
            '/Login': (context) => Login(),
            '/Register': (context) => Register(),
            '/Home': (context) => MyBottomNavigationBar(),
          }),
    );
  }
}

//
class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    print("Printing fbuser: " + firebaseUser.toString());
    if (firebaseUser == null) {
      isVerified = false;
      return MyBottomNavigationBar();
    } else {
      isVerified = true;
      return MyBottomNavigationBar();
    }
  }
}
