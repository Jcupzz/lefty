import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lefty/Authentication/Register.dart';
import 'package:lefty/Database_Services/Database_Services.dart';
import 'package:lefty/Pages/Request.dart';
import 'package:lefty/main.dart';
import 'package:lefty/static/Loading.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

import 'Register_Institute.dart';

class Create extends StatefulWidget {
  @override
  _CreateState createState() => _CreateState();
}

class _CreateState extends State<Create> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String timer;

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    return !(isVerified)
        ? AlertDialog(
                backgroundColor: Colors.grey[100],
                title: Text("Sign in"),
                content: Text("Please Sign in to register an institute"),
                actions: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)
                        )
                      ),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => Register()));
                        },
                        child: Text("Ok")),
                  )
                ],
              )
        : Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      "Create",
                      style: TextStyle(fontSize: 50, color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                      child: Text("Register an institute here"),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => Register_Institute()));
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 20,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              primary: Colors.black,
                            ),
                            // style: ButtonStyle(
                            //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            //   elevation: MaterialStateProperty.all(20),
                            //   backgroundColor: MaterialStateProperty.all(Colors.black)
                            // ),
                            child: Text(
                              "Register Institute",
                              style: TextStyle(color: Colors.white),
                            )),
                      ),
                    ),
                    StreamBuilder<QuerySnapshot>(

                        stream: firestore.collection("iDetails").where('uid', isEqualTo: firebaseUser.uid).snapshots(),
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return Loading();
                          } else {
                            return Expanded(
                              child: ListView(
                                shrinkWrap: true,
                                children: snapshot.data.docs.map((DocumentSnapshot document) {
                                  return Card(
                                      color: Colors.white,
                                      elevation: 20,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
                                      child: ListTile(
                                        onTap: () {},
                                        onLongPress: () {
                                          //showDeleteDialog(document);
                                        },
                                        title: Padding(
                                          padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                document.data()['iName'],
                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, letterSpacing: 1),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Flexible(
                                                      flex: 1,
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisSize: MainAxisSize.max,
                                                        children: [
                                                          Text(
                                                            document.data()['iDesc'],
                                                            style: TextStyle(color: Colors.black),
                                                          ),
                                                          Text(
                                                            document.data()['iAddress'],
                                                            style: TextStyle(color: Colors.black),
                                                          ),
                                                          Text(
                                                            document.data()['iPhone1'],
                                                            style: TextStyle(color: Colors.black),
                                                          ),
                                                          Text(
                                                            document.data()['iPhone2'],
                                                            style: TextStyle(color: Colors.black),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Flexible(
                                                      flex: 1,
                                                      child: CachedNetworkImage(
                                                        imageUrl: document.data()['iPhoto'],
                                                        imageBuilder: (context, imageProvider) => Container(
                                                          width: 180.0,
                                                          height: 120.0,
                                                          decoration: BoxDecoration(
                                                            shape: BoxShape.rectangle,
                                                            borderRadius: BorderRadius.circular(20),
                                                            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
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
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                                child: Container(
                                                  width: MediaQuery.of(context).size.width,
                                                  child: document.data()['isRequested']
                                                      ? ElevatedButton(
                                                          onPressed: () async {
                                                            await firestore
                                                                .collection("iDetails")
                                                                .doc(document.id)
                                                                .update({'isRequested': false});
                                                            //showRequestDialog(document, firebaseUser);
                                                          },
                                                          child: Text(
                                                            "Cancel Request",
                                                            style: TextStyle(color: Colors.white),
                                                          ),
                                                          style: ElevatedButton.styleFrom(
                                                            primary: Colors.red,
                                                            elevation: 10,
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(20),
                                                            ),
                                                          ),
                                                        )
                                                      : ElevatedButton(
                                                          onPressed: () async {
                                                            await firestore
                                                                .collection("iDetails")
                                                                .doc(document.id)
                                                                .update({'isRequested': true});
                                                            //showRequestDialog(document, firebaseUser);
                                                          },
                                                          child: Text(
                                                            "Create Request",
                                                            style: TextStyle(color: Colors.white),
                                                          ),
                                                          style: ElevatedButton.styleFrom(
                                                            primary: Colors.black,
                                                            elevation: 10,
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(20),
                                                            ),
                                                          ),
                                                        ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ));
                                }).toList(),
                              ),
                            );
                          }
                        }),
                  ],
                ),
              ),
            ),
          );
  }

// void showRequestDialog(DocumentSnapshot document, User firebaseUser) {
//   showDialog(
//       context: context,
//       builder: (_) => new AlertDialog(
//             title: new Text("Choose Hours"),
//             actions: <Widget>[
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//                   Container(
//                     width: MediaQuery.of(context).size.width,
//                     child: new NumberPicker.horizontal(
//                         listViewHeight: 60,
//                         step: 1,
//                         selectedTextStyle: TextStyle(color: Colors.blue),
//                         initialValue: iHour,
//                         minValue: 1,
//                         maxValue: 48,
//                         onChanged: (value) {
//                           setState(() {
//                             iHour = value;
//                             print(iHour);
//                           });
//                         }),
//                   ),
//                   Container(
//                     width: MediaQuery.of(context).size.width,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         firestore.collection("iDetails").doc(document.id).update({'iHour': iHour});
//                         setState(() {
//                           isRequested = true;
//                         });
//                         Count_Down_Timer count = new Count_Down_Timer(iHour);
//                         count.countDown();
//                         Navigator.pop(context);
//                       },
//                       child: Text(
//                         "Done",
//                         style: TextStyle(color: Colors.white),
//                       ),
//                       style: ElevatedButton.styleFrom(
//                         primary: Colors.black,
//                         elevation: 10,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ));
//   // showDialog<int>(
//   //     useSafeArea: true,
//   //     barrierColor: Colors.white,
//   //     context: context,
//   //     builder: (_) => AlertDialog(
//   //
//   //           content: Column(
//   //             mainAxisAlignment: MainAxisAlignment.center,
//   //             crossAxisAlignment: CrossAxisAlignment.center,
//   //             mainAxisSize: MainAxisSize.min,
//   //             children: [
//   //
//   //               NumberPicker.horizontal(
//   //                   listViewHeight: 50,
//   //                   step: 1,
//   //                   initialValue: iHour,
//   //                   minValue: 1,
//   //                   maxValue: 48,
//   //                   onChanged: (value) {
//   //                     setState(() {
//   //                       iHour = value;
//   //                       print(iHour);
//   //                     });
//   //                   }),
//   //               ElevatedButton(
//   //                 onPressed: () {
//   //                   showRequestDialog(document);
//   //                 },
//   //                 child: Text(
//   //                   "Done",
//   //                   style: TextStyle(color: Colors.white),
//   //                 ),
//   //                 style: ElevatedButton.styleFrom(
//   //                   primary: Colors.black,
//   //                   elevation: 10,
//   //                   shape: RoundedRectangleBorder(
//   //                     borderRadius: BorderRadius.circular(20),
//   //                   ),
//   //                 ),
//   //               ),
//   //
//   //             ],
//   //           ),
//   //         ),);
// }
// Future<void> getImage() async {
//   var image = await ImagePicker.pickImage(source: ImageSource.gallery);
//   setState(() {
//     _image = image;
//     print("_image: $_image");
//   });
// }
}
