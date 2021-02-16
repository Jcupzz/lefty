import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lefty/Pages/Details.dart';
import 'package:lefty/static/Loading.dart';
import 'package:provider/provider.dart';
import 'package:lefty/Authentication/Authentication_Services.dart';
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        title: Text("Lefty.",style: TextStyle(color: Colors.white),),
        centerTitle: true,
        actions: [
          IconButton(icon: Icon(Icons.follow_the_signs_outlined), onPressed: ()async{
            dynamic isLoggedOut = await context
                .read<AuthenticationService>()
                .signOut();
            if (isLoggedOut.toString() == "Signed out") {
              Navigator.pushReplacementNamed(
                  context, "/Register");
            }
          }),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: StreamBuilder<QuerySnapshot>(
            stream: firestore.collection("iDetails").where('isRequested',isEqualTo: true).snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Loading();
              } else {
                return ListView(
                  shrinkWrap: true,
                  children: snapshot.data.docs
                      .map((DocumentSnapshot document) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
                      child: Card(
                          color: Colors.white,
                          elevation: 20,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(14.0)),
                          child: ListTile(
                            onTap: (){

                              Navigator.push(context, MaterialPageRoute(builder: (_)=>Details(document)));
                            },
                            onLongPress: () {
                              //showDeleteDialog(document);
                            },
                            //subtitle: Text(document['iType']),
                            title: Padding(
                              padding:
                              const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(document.data()['iName'],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,letterSpacing: 1),),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0,10,0,0),
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
                                                document.data()['iHour'].toString(),
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
                                                image: DecorationImage(
                                                    image: imageProvider, fit: BoxFit.cover),
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
}
