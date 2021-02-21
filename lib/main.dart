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
                backgroundColor: Colors.white,
                actionTextColor: Colors.black,
              ),
              accentColorBrightness: Brightness.light,
              primaryColor: Colors.teal[500],
              primaryColorDark: Colors.teal[800],
              cardColor: Colors.teal[50],
              highlightColor: Colors.black,
              backgroundColor: Colors.teal[100],
              accentColor: Colors.tealAccent,
              brightness: Brightness.light,
              textSelectionTheme: TextSelectionThemeData(
                  cursorColor: Colors.teal[900], selectionColor: Colors.white70, selectionHandleColor: Colors.teal[500]),
              splashColor: Colors.teal[200],
              buttonColor: Colors.teal[500],
              hintColor: Colors.teal[900],
              unselectedWidgetColor: Colors.teal[500],
              errorColor: Colors.red[300],
              dividerColor: Colors.teal[900],
              textTheme: TextTheme(
                  bodyText1: TextStyle(color: Colors.teal[700], fontSize: 16, fontFamily: 'Sans'),
                  headline3: TextStyle(color: Colors.teal[400], fontSize: 20, fontFamily: 'FredokaOne'),
                  headline2: TextStyle(color: Colors.teal[400], fontSize: 35, fontFamily: 'FredokaOne'),
                  subtitle1: TextStyle(color: Colors.teal[800], fontSize: 18, fontFamily: 'Sans'),
                  headline5: TextStyle(color: Colors.teal[400], fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Sans'),
                  headline4: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Sans'),
                  bodyText2: TextStyle(color: Colors.teal[600], fontSize: 14, fontWeight: FontWeight.bold),
                  headline1: TextStyle(color: Colors.teal[800], fontSize: 60, fontWeight: FontWeight.normal,fontFamily: 'FredokaOne'))),
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
                  bodyText1: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Sans'),
                  headline3: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'FredokaOne'),
                  headline2: TextStyle(color: Colors.white, fontSize: 35, fontFamily: 'FredokaOne'),
                  headline5: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Sans'),
                  subtitle1: TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'Sans'),
                  headline4: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Sans'),
                  bodyText2: TextStyle(color: Colors.teal[100], fontSize: 14, fontWeight: FontWeight.bold),
                  headline1: TextStyle(color: Colors.white, fontSize: 60, fontWeight: FontWeight.normal,fontFamily: 'FredokaOne')),
              dividerColor: Colors.grey[400],
              unselectedWidgetColor: Colors.grey[600],
              errorColor: Colors.red[300],
              primaryColor: Colors.grey[850],
              hintColor: Colors.grey,
              primaryColorDark: Colors.black,
              cardColor: Colors.grey[850],
              backgroundColor: Colors.grey[900],
              highlightColor: Colors.black,
              textSelectionTheme: TextSelectionThemeData(
                  cursorColor: Colors.teal[200], selectionColor: Colors.teal[100], selectionHandleColor: Colors.teal[200]),
              accentColor: Colors.teal[200],
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
            '/Home': (context) => MyBottomNavigationBar()
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
      return SplashScreen();
    } else {
      isVerified = true;
      return SplashScreen();
    }
  }
}
