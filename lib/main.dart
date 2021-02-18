import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lefty/Authentication/Authentication_Services.dart';
import 'package:lefty/Authentication/Login.dart';
import 'package:lefty/Authentication/Register.dart';
import 'package:lefty/Home.dart';
import 'package:lefty/MyBottomNavigationBar.dart';
import 'package:lefty/SplashScreen.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';

bool isVerified = false;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      loadThemeOnInit: true,
      saveThemesOnChange: true,
      defaultThemeId: 'light_theme',
      themes: [
        AppTheme(
          description: "dark_theme for app",
          id: "dark_theme", // Id(or name) of the theme(Has to be unique)
          data: ThemeData(
            // Real theme data
            primaryColor: Colors.black,
            primaryColorDark: Colors.black,
            cardColor: Colors.grey[800],
            backgroundColor: Colors.grey[900],
            accentColor: Colors.grey,
            textTheme: TextTheme(
            ),
            brightness: Brightness.dark,
            splashColor: Colors.blueGrey[900],
          ),
        ),
        AppTheme(
          description: "light_theme for app",
          id: "light_theme", // Id(or name) of the theme(Has to be unique)
          data: ThemeData(
            // Real theme data
            primaryColor: Colors.green[700],
            primaryColorDark: Colors.green[900],
            cardColor: Colors.green[400],
            backgroundColor: Colors.green[600],
            accentColor: Colors.greenAccent,
            brightness: Brightness.light,
            splashColor: Colors.green[300],
          ),
        ),
      ],
      child: ThemeConsumer(

        child: MultiProvider(
            providers: [
              Provider<AuthenticationService>(
                  create: (_) => AuthenticationService(FirebaseAuth.instance)),
              StreamProvider(
                create: (context) =>
                    context.read<AuthenticationService>().authStateChanges,
              )
            ],
            child: Builder(
              builder: (themeContext)=> MaterialApp(
                  builder: BotToastInit(),
                  theme: ThemeProvider.themeOf(themeContext).data,
                  navigatorObservers: [BotToastNavigatorObserver()],
                  home: AuthenticationWrapper(),
                  routes: {
                    '/SplashScreen': (context) => SplashScreen(),
                    '/Login': (context) => Login(),
                    '/Register': (context) => Register(),
                    '/Home': (context) => MyBottomNavigationBar(),
                  }),
            )),
      ),
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
