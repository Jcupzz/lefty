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

bool isVerified = false;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [Provider<AuthenticationService>(create: (_)=>AuthenticationService(FirebaseAuth.instance)),
          StreamProvider(create: (context)=>context.read<AuthenticationService>().authStateChanges,)
        ],
        child: MaterialApp(
            builder: BotToastInit(),
            navigatorObservers: [BotToastNavigatorObserver()],
            home: AuthenticationWrapper(),
            routes: {
              '/SplashScreen': (context) => SplashScreen(),
              '/Login': (context) => Login(),
              '/Register': (context) => Register(),
              '/Home': (context) => MyBottomNavigationBar(),
            }));
  }
}
//
class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final firebaseUser = context.watch<User>();
    print(firebaseUser);
    if (firebaseUser == null) {
      isVerified = false;
      return MyBottomNavigationBar();

    }
    else{
      isVerified = true;
      return MyBottomNavigationBar();
    }



  }
}
