import 'package:flutter/material.dart';
import 'package:lefty/Authentication/Authentication_Services.dart';
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
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.white,
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
                                  color: Colors.blueGrey[700],
                                  fontSize: 35,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Lefty.",
                              style: TextStyle(
                                  color: Colors.blueGrey[900],
                                  fontSize: 80,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: 50,
                          ),

                          //Email Field

                          TextFormField(
                            validator: (val) =>
                                val.isEmpty || !(val.contains('@'))
                                    ? 'Enter a valid email address'
                                    : null,
                            onChanged: (value) {
                              setState(() => email = value);
                            },
                            style: TextStyle(color: Colors.blueGrey[900]),
                            cursorColor: Colors.blueGrey[900],
                            decoration: InputDecoration(
                              labelStyle: TextStyle(
                                color: Colors.blueGrey[900],
                              ),
                              labelText: "Email",
                              fillColor: Colors.white,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                    width: 1, color: Colors.blueGrey[500]),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                    width: 1, color: Colors.blueGrey[900]),
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
                            validator: (val) => val.isEmpty || val.length < 6
                                ? 'Enter a password greater than 6 characters'
                                : null,
                            onChanged: (value) {
                              setState(() => password = value);
                            },
                            obscureText: true,
                            style: TextStyle(color: Colors.blueGrey[900]),
                            cursorColor: Colors.blueGrey[900],
                            decoration: InputDecoration(
                              labelStyle: TextStyle(
                                color: Colors.blueGrey[500],
                              ),
                              labelText: "Password",
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                    width: 1, color: Colors.blueGrey[500]),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                    width: 1, color: Colors.blueGrey[900]),
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
                            child: PhysicalModel(
                              color: Colors.transparent,
                              shadowColor: Colors.blueGrey[500],
                              elevation: 10,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(20),
                              child: FlatButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                onPressed: () async {
                                  if (_formkey.currentState.validate()) {
                                    setState(() {
                                      loading = true;
                                    });
                                    dynamic isSuccess = await context
                                        .read<AuthenticationService>()
                                        .signUp(
                                            email: email, password: password);
                                    if (isSuccess.toString() == "Signed up") {
                                      isVerified = true;
                                      Navigator.pushReplacementNamed(
                                          context, '/Home');
                                      BotToast.showSimpleNotification(
                                        title: " Welcome! ",
                                        backgroundColor: Colors.blueGrey[900],
                                      );
                                    } else {
                                      Navigator.pushReplacementNamed(
                                          context, '/Register');
                                      BotToast.showSimpleNotification(
                                        title:
                                            "Failed to register. Please check internet connection and try again!",
                                        backgroundColor: Colors.red,
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
                                color: Colors.blueGrey[900],
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 20, 0, 20),
                                  child: Text("Sign up",style: TextStyle(color: Colors.white),),
                                ),
                              ),
                            ),
                          ),
                          FlatButton(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              onPressed: () {
                                Navigator.pushNamed(context, '/Login');
                              },
                              child: Text(
                                "Already registered ? Login Here",
                                style: TextStyle(color: Colors.blueGrey[900]),
                              )),
                        ],
                      ),
                    )),
              ),
            ),
          );
  }
}
