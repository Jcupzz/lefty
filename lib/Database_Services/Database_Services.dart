import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';

class Database_Services {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference collectionReference1 = FirebaseFirestore.instance.collection("iDetails");

  // firebase_storage.FirebaseStorage _storage =
  //     firebase_storage.FirebaseStorage.instance;

  Future<void> addCreateToFb(String iName, String iAddress, String iType, File iPhoto, String iPhone1, String iPhone2,
      String iDesc, bool isRequested, double lat, double long) async {
    String downloadURL;
    int iHour = 0;
    final User firebaseUser = _auth.currentUser;
    if (iPhoto == null) {
      downloadURL =
          "https://firebasestorage.googleapis.com/v0/b/lefty-3ea7c.appspot.com/o/iPhoto%2Fdownload%20(1).jfif?alt=media&token=1db1a00a-3c7f-4810-9c3e-37f2b6bf724a";
    } else {
      downloadURL = await uploadFile(iPhoto.path);
    }

    //CollectionReference collectionReference2 = FirebaseFirestore.instance.collection("iPublic");
    // firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
    //     .ref()
    //     .child("iPhoto");

    if (!(downloadURL == 'Error')) {
      await collectionReference1.add({
        'iName': iName,
        'iAddress': iAddress,
        'iType': iType,
        'iPhoto': downloadURL,
        'iPhone1': iPhone1,
        'iPhone2': iPhone2,
        'iDesc': iDesc,
        'isRequested': isRequested,
        'time': DateTime.now(),
        'uid': firebaseUser.uid,
        'lat': lat,
        'long': long,
      }).then((value) {
        return 'Done';
      }).catchError((onError) {
        return 'Error';
      });
    }
  }

  Future<String> uploadFile(String filePath) async {
    File file = File(filePath);
    String downloadURL;
    try {
      await firebase_storage.FirebaseStorage.instance
          .ref('iPhoto')
          .child("${DateTime.now().millisecondsSinceEpoch}")
          .putFile(file)
          .then((val) async {
        downloadURL = await val.ref.getDownloadURL();
      });
      return downloadURL;
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      return "Error";
    }
  }
  Future<void> deleteDataFromFb(
      DocumentSnapshot documentSnapshot,BuildContext context) async {
    final User firebaseUser = _auth.currentUser;

   await collectionReference1.doc(documentSnapshot.id).delete().then((value) {
     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data Deleted!',style: Theme.of(context).textTheme.headline4,)));
   }).catchError((onError){
     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error Deleting Data!',style: Theme.of(context).textTheme.headline4,)));
   });
  }



}
