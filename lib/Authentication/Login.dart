import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lefty/Authentication/Authentication_Services.dart';
import 'package:lefty/Theme/ThemeController.dart';
import 'package:lefty/main.dart';
import 'package:lefty/static/Loading.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formkey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String error = '';
  bool loading = false;
  dynamic isSuccess;

  @override
  Widget build(BuildContext context) {
    var brightness = Theme.of(context).brightness;
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            body: Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                child: Form(
                    key: _formkey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Hi there",
                              style: TextStyle(
                                  color: brightness == Brightness.light ? Colors.teal[600] : Colors.teal[50],
                                  fontSize: 65,
                                  fontFamily: 'Lobster',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Welcome back",
                              style: TextStyle(
                                  color:brightness == Brightness.light? Colors.teal[700] : Colors.teal[100],
                                  fontSize: 35,
                                  fontFamily: 'Lobster',
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: 65,
                          ),

                          //Email Field

                          TextFormField(
                            validator: (val) => val.isEmpty || !(val.contains('@')) ? 'Enter a valid email address' : null,
                            onChanged: (value) {
                              setState(() => email = value);
                            },
                            style: Theme.of(context).textTheme.headline5,
                            decoration: InputDecoration(
                              labelStyle: Theme.of(context).textTheme.headline5,
                              labelText: "Email",
                              fillColor: Colors.white,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(width: 1, color: Colors.teal[200]),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(width: 1, color: Theme.of(context).unselectedWidgetColor),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(),
                              ),
                            ),
                          ),

                          SizedBox(
                            height: 25,
                          ),

                          //Password Field

                          TextFormField(
                            validator: (val) =>
                                val.isEmpty || val.length < 6 ? 'Enter a password greater than 6 characters' : null,
                            onChanged: (value) {
                              setState(() => password = value);
                            },
                            obscureText: true,
                            style: Theme.of(context).textTheme.headline5,
                            decoration: InputDecoration(
                              labelStyle: Theme.of(context).textTheme.headline5,
                              labelText: "Password",
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(width: 1, color: Colors.teal[200]),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(width: 1, color: Theme.of(context).unselectedWidgetColor),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).buttonColor,
                                elevation: 10,
                                shadowColor: brightness == Brightness.light?Colors.teal[500]:Colors.black,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              ),
                              onPressed: () async {
                                print("Button presed");
                                //
                                if (_formkey.currentState.validate()) {
                                  setState(() {
                                    loading = true;
                                  });
                                  isSuccess =
                                      await context.read<AuthenticationService>().signIn(email: email, password: password);
                                  print(isSuccess);
                                  if (isSuccess.toString() == "Signed in") {
                                    setState(() {
                                      isVerified = true;
                                    });
                                    Navigator.pushReplacementNamed(context, '/Home');
                                    BotToast.showSimpleNotification(
                                      title: "Welcome back!",
                                      backgroundColor: Colors.teal[100],
                                    );
                                  } else {
                                    Navigator.pushReplacementNamed(context, '/Register');
                                    BotToast.showSimpleNotification(
                                      title: "Failed to sign in. Please check internet connection and try again!",
                                      backgroundColor: Colors.red[300],
                                    );
                                  }
                                }
                                //}
                                //   dynamic result =
                                //   await _auth.loginWithEmailAndPassword(
                                //       email, password);
                                //   if (result == null) {
                                //     setState(() {
                                //       loading = false;
                                //       error = 'Invalid Credentials';
                                //       print(
                                //           "Oops...!\nSign in failed!\nInvalid Credentials");
                                //     });
                                //   } else {
                                //     print('User Signed In Successfully');
                                //     Navigator.pushNamed(context, '/List_home');
                                //   }
                                // }
                              },
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                                child: Text(
                                  "Sign in",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(
                            height: 20,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              error,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.deepOrange[200], fontSize: 18),
                            ),
                          )
                        ],
                      ),
                    )),
              ),
            ),
          );
  }
}
