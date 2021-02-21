import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lefty/Authentication/Authentication_Services.dart';
import 'package:lefty/Theme/ThemeController.dart';
import 'package:lefty/main.dart';
import 'package:lefty/static/Loading.dart';
import 'package:provider/provider.dart';
import 'package:bot_toast/bot_toast.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formkey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String error = '';
  bool loading = false;

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
                              "Welcome to",
                              style: TextStyle(
                                color: brightness == Brightness.light ? Colors.teal[600] : Colors.teal[50],
                                fontSize: 45,
                                fontFamily: 'Lobster'
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Lefty.",
                              style: TextStyle(
                                  color: brightness == Brightness.light ? Colors.teal[700] : Colors.teal[100],
                                  fontSize: 100,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Lobster'),
                            ),
                          ),
                          SizedBox(
                            height: 60,
                          ),

                          //Email Field

                          TextFormField(
                            validator: (val) => val.isEmpty || !(val.contains('@')) ? 'Enter a valid email address' : null,
                            style: Theme.of(context).textTheme.headline5,
                            onChanged: (value) {
                              setState(() => email = value);
                            },
                            decoration: InputDecoration(
                              labelStyle: Theme.of(context).textTheme.headline5,
                              labelText: "Email",
                              fillColor: Colors.white,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(width: 1, color: Theme.of(context).unselectedWidgetColor),
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
                                borderSide: BorderSide(width: 1, color: Theme.of(context).unselectedWidgetColor),
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
                                shadowColor: brightness == Brightness.light?Colors.teal[500]:Colors.black,
                                elevation: 10,
                                primary: Theme.of(context).buttonColor,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              ),
                              onPressed: () async {
                                if (_formkey.currentState.validate()) {
                                  setState(() {
                                    loading = true;
                                  });
                                  dynamic isSuccess =
                                      await context.read<AuthenticationService>().signUp(email: email, password: password);
                                  if (isSuccess.toString() == "Signed up") {
                                    setState(() {
                                      isVerified = true;
                                    });
                                    Navigator.pushReplacementNamed(context, '/Home');
                                    BotToast.showSimpleNotification(
                                      title: " Welcome! ",
                                      backgroundColor: Colors.teal[200],
                                    );
                                  } else {
                                    Navigator.pushReplacementNamed(context, '/Register');
                                    BotToast.showSimpleNotification(
                                      title: "Failed to register. Please check internet connection and try again!",
                                      backgroundColor: Colors.red[300],
                                    );
                                  }
                                }
                                // if (_formkey.currentState.validate()) {
                                //   setState(() {
                                //     loading = true;
                                //   });
                                //   dynamic result =
                                //   await _auth.registerWithEmailAndPassword(
                                //       email, password);
                                //   if (result == null) {
                                //     setState(() {
                                //       print("Error user not registered");
                                //       loading = false;
                                //     });
                                //   } else {
                                //     print('User Signed In Successfully');
                                //     Navigator.pushReplacementNamed(
                                //         context, '/List_home');
                                //  }
                                // }
                              },
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                                child: Text(
                                  "Sign up",
                                ),
                              ),
                            ),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/Login');
                              },
                              child: Text(
                                "Already registered ? Login Here",
                                style: Theme.of(context).textTheme.headline5.apply(
                                      fontFamily: '',color: brightness == Brightness.light?Colors.teal[700]:Colors.grey
                                    ),
                              )),
                        ],
                      ),
                    )),
              ),
            ),
          );
  }
}
