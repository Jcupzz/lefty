import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lefty/Authentication/Authentication_Services.dart';
import 'package:lefty/Authentication/Register.dart';
import 'package:lefty/Database_Services/Database_Services.dart';
import 'package:lefty/Home.dart';
import 'package:lefty/Pages/Details.dart';
import 'package:lefty/Theme/ThemeController.dart';
import 'package:lefty/main.dart';
import 'package:lefty/static/Horizontal_Loading.dart';
import 'package:provider/provider.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  ThemeMode _themeMode;
  FirebaseAuth _auth = FirebaseAuth.instance;
  Stream stream;

  @override
  void initState() {
    super.initState();
    if (isVerified) {
      final User firebaseUser = _auth.currentUser;
      stream = firestore.collection("iDetails").where('uid', isEqualTo: firebaseUser.uid).snapshots();
    } else {
      //do nothing
    }
  }

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    var brightness = Theme.of(context).brightness;
    return (isVerified)
        ? Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                              "https://firebasestorage.googleapis.com/v0/b/lefty-3ea7c.appspot.com/o/iPhoto%2Fdownload%20(1).png?alt=media&token=c00efbe3-8f0c-4bd9-86b7-61421d1f855f"),
                          radius: 80.0,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 60,
                        child: Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Center(
                                child:
                                    Text("${firebaseUser.email}" ?? 'Anonymous', style: Theme.of(context).textTheme.subtitle1))),
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          height: 60,
                          child: Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              child: Center(
                                  child: Text(
                                'Your Institutions',
                                style: Theme.of(context).textTheme.subtitle1.apply(fontFamily: 'FredokaOne'),
                              )))),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: StreamBuilder<QuerySnapshot>(
                            stream: stream,
                            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (!snapshot.hasData) {
                                return Horizontal_Loading();
                              } else {
                                return (!(snapshot.data.docs.length == 0 || snapshot.data == null))
                                    ? ConstrainedBox(
                                        constraints: BoxConstraints(
                                            maxHeight: double.infinity,
                                            minHeight: MediaQuery.of(context).size.width * 0.5,
                                            minWidth: MediaQuery.of(context).size.width,
                                            maxWidth: MediaQuery.of(context).size.width),
                                        child: ListView(
                                          shrinkWrap: true,
                                          children: snapshot.data.docs.map((DocumentSnapshot document) {
                                            return Card(
                                                color: Theme.of(context).cardColor,
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
                                                child: ListTile(
                                                  onTap: () {
                                                    Navigator.push(context, MaterialPageRoute(builder: (_) => Details(document)));
                                                  },
                                                  onLongPress: () {
                                                    BotToast.showText(
                                                        text: 'Please goto Create menu and long press to delete institute');
                                                  },
                                                  title: Padding(
                                                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(document.data()['iName'],
                                                            style: Theme.of(context).textTheme.headline3),
                                                        Text(document.data()['iType'],
                                                            style: Theme.of(context).textTheme.headline5),
                                                        Divider(
                                                          height: 20,
                                                          thickness: 0,
                                                          color: Theme.of(context).dividerColor,
                                                        ),
                                                        Row(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Flexible(
                                                              flex: 1,
                                                              child: Padding(
                                                                padding: const EdgeInsets.fromLTRB(0, 0, 15, 3),
                                                                child: Column(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  mainAxisSize: MainAxisSize.max,
                                                                  children: [
                                                                    Text(
                                                                      document.data()['iDesc'],
                                                                      style: Theme.of(context).textTheme.bodyText1,
                                                                    ),
                                                                    Text(
                                                                      document.data()['iAddress'],
                                                                      style: Theme.of(context).textTheme.bodyText1,
                                                                    ),
                                                                    Text(
                                                                      document.data()['iPhone1'],
                                                                      style: Theme.of(context).textTheme.bodyText1,
                                                                    ),
                                                                    Text(
                                                                      document.data()['iPhone2'],
                                                                      style: Theme.of(context).textTheme.bodyText1,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            Flexible(
                                                              flex: 1,
                                                              child: CachedNetworkImage(
                                                                imageUrl: document.data()['iPhoto'],
                                                                imageBuilder: (context, imageProvider) => Container(
                                                                  width: MediaQuery.of(context).size.width,
                                                                  height: MediaQuery.of(context).size.width * 0.35,
                                                                  decoration: BoxDecoration(
                                                                    shape: BoxShape.rectangle,
                                                                    borderRadius: BorderRadius.circular(10),
                                                                    image:
                                                                        DecorationImage(image: imageProvider, fit: BoxFit.cover),
                                                                  ),
                                                                ),
                                                                placeholder: ((context, s) => Center(
                                                                      child: CircularProgressIndicator(),
                                                                    )),
                                                                fit: BoxFit.cover,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ));
                                          }).toList(),
                                        ),
                                      )
                                    : Container(
                                        width: MediaQuery.of(context).size.width,
                                        height: MediaQuery.of(context).size.width * 0.5,
                                        child: Card(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                          elevation: 0,
                                          color: Theme.of(context).cardColor,
                                          child: Center(
                                            child: Text(
                                              'You have 0 institute\nCreate an Institute \nby clicking Register \nInstitute in Create menu',
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context).textTheme.bodyText1,
                                            ),
                                          ),
                                        ),
                                      );
                              }
                            }),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(3, 5, 3, 0),
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          onPressed: () {
                            changeThemeShowDialog(context);
                          },
                          child: Text(
                            "Current Theme: ${brightness == Brightness.dark ? 'DarkMode' : 'LightMode'}",
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).cardColor,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              )),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(3, 10, 3, 10),
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          onPressed: () {
                            showSignOutDialog(context);
                          },
                          child: Text(
                            'SignOut',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).cardColor,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : Register();
  }

  showSignOutDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 24,
            backgroundColor: Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            title: Text("SignOut", style: Theme.of(context).textTheme.headline3),
            content: Text("Are you sure?", style: Theme.of(context).textTheme.subtitle1),
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Theme.of(context).cardColor, elevation: 0),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "No",
                  style: TextStyle(color: Colors.greenAccent, fontSize: 18),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Theme.of(context).cardColor, elevation: 0),
                onPressed: () async {
                  dynamic isLoggedOut = await context.read<AuthenticationService>().signOut();
                  if (isLoggedOut.toString() == "Signed out") {
                    setState(() {
                      isVerified = false;
                    });
                    print("Signed Outt");
                    SystemNavigator.pop();
                  }
                },
                child: Text(
                  "Yes",
                  style: TextStyle(fontSize: 18, color: Colors.redAccent),
                ),
              ),
            ],
          );
        });
  }

  changeThemeShowDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(
              "Theme",
              style: Theme.of(context).textTheme.headline3,
            ),
            content: themeDialog(),
          );
        });
  }

  Widget themeDialog() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RadioListTile(
          title: Text('system'),
          value: ThemeMode.system,
          groupValue: _themeMode,
          onChanged: (value) {
            setState(() {
              _themeMode = value;
              ThemeController.to.setThemeMode(_themeMode);
            });
          },
        ),
        RadioListTile(
          title: Text('dark'),
          value: ThemeMode.dark,
          groupValue: _themeMode,
          onChanged: (value) {
            setState(() {
              _themeMode = value;
              ThemeController.to.setThemeMode(_themeMode);
            });
          },
        ),
        RadioListTile(
          title: Text('light'),
          value: ThemeMode.light,
          groupValue: _themeMode,
          onChanged: (value) {
            setState(() {
              _themeMode = value;
              ThemeController.to.setThemeMode(_themeMode);
            });
          },
        )
      ],
    );
  }
}
