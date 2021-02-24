
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lefty/Pages/About.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lefty/Pages/Details.dart';
import 'package:lefty/Theme/ThemeController.dart';
import 'package:lefty/main.dart';
import 'package:lefty/static/Loading.dart';
import 'package:provider/provider.dart';
import 'package:lefty/Authentication/Authentication_Services.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ThemeMode _themeMode;
  int selectedValue;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {

    final firebaseUser = context.watch<User>();
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorDark,
        elevation: 0,
        title: Text(
          "Lefty.",
          style: TextStyle(color: Colors.teal[100],fontFamily: 'Lobster',fontSize: 30),
        ),
        centerTitle: true,
        actions: [
          // IconButton(
          //     icon: Icon(Icons.more_vert_rounded),
          //     onPressed: () async {
          //
          //       // dynamic isLoggedOut =
          //       //     await context.read<AuthenticationService>().signOut();
          //       // if (isLoggedOut.toString() == "Signed out") {
          //       //   setState(() {
          //       //     isVerified = false;
          //       //   });
          //       //   SystemNavigator.pop();
          //       // }
          //     }),
          PopupMenuButton(itemBuilder: (context){
            return [
            PopupMenuItem(
              value: 1,
              child: Text('Theme'),
            ),
            PopupMenuItem(
              value: 2,
              child: Text('SignOut'),
            ),
            PopupMenuItem(
              value: 3,
              child: Text('About'),
            ),
            ];
          },
            icon: Icon(Icons.more_vert_rounded),
            onSelected: (index) async {
            switch(index){
              case 1:
                changeThemeShowDialog(context);
                break;
              case 2:
                showSignOutDialog(context);
                break;
              case 3:
                Navigator.push(context, MaterialPageRoute(builder: (_)=>About()));
                break;
            }
          }
          ),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
        height: MediaQuery.of(context).size.height,
        child: StreamBuilder<QuerySnapshot>(
            stream: firestore
                .collection("iDetails")
                .where('isRequested', isEqualTo: true)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Loading();
              } else {
                return ListView(
                  shrinkWrap: true,
                  children: snapshot.data.docs.map((DocumentSnapshot document) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
                      child: Card(
                          color: Theme.of(context).cardColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.0)),
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => Details(document)));
                            },
                            onLongPress: () {
                              //showDeleteDialog(document);
                            },
                            //subtitle: Text(document['iType']),
                            title: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    document.data()['iName'],
                                    style:Theme.of(context).textTheme.headline3),
                                  Text(
                                      document.data()['iType'],
                                      style:Theme.of(context).textTheme.headline5),
                                  Divider(height: 20,thickness: 0,color: Theme.of(context).dividerColor,),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        flex: 1,
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 10, 5),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Text(
                                                document.data()['iDesc'],
                                                softWrap: true,
                                                style: Theme.of(context).textTheme.bodyText1
                                              ),
                                              Text(
                                                document.data()['iAddress'],
                                                softWrap: true,
                                                style:Theme.of(context).textTheme.bodyText1
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        flex: 1,
                                        child: CachedNetworkImage(
                                          imageUrl: document.data()['iPhoto'],
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.35,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                          placeholder: ((context, s) =>
                                              Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              )),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )),
                    );
                  }).toList(),
                );
              }
            }),
      ),
    );
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
                onPressed: () async{
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
            title: Text("Theme",style: Theme.of(context).textTheme.headline3,),
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
