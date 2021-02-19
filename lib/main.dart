import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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
          Provider<AuthenticationService>(
              create: (_) => AuthenticationService(FirebaseAuth.instance)),
          StreamProvider(
            create: (context) =>
                context.read<AuthenticationService>().authStateChanges,
          )
        ],
        child:  GetMaterialApp(
              builder: BotToastInit(),
            theme: ThemeData.light().copyWith(
              accentColorBrightness: Brightness.light,
              primaryColor: Color(0xff00766c),
              primaryColorDark: Color(0xFF005b4f),
              cardColor: Color(0xFF64d8cb),
              backgroundColor: Color(0xFF26a69a),
              accentColor: Color(0xFF14ffec),
              brightness: Brightness.light,
              splashColor: Colors.green[300],
              buttonColor: Color(0xFF64d8cb),
            ),
            darkTheme: ThemeData.dark().copyWith(
                primaryColor: Colors.grey[850],
                primaryColorDark: Colors.black,
                cardColor: Colors.grey[800],
                backgroundColor: Colors.grey[900],
                accentColor: Colors.teal[100],
                brightness: Brightness.dark,
                splashColor: Colors.blueGrey[900],
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
    print("Printing fbuser: "+firebaseUser.toString());
    if (firebaseUser == null) {
      isVerified = false;
      return MyBottomNavigationBar();
    } else {
      isVerified = true;
      return MyBottomNavigationBar();
    }
  }
}
