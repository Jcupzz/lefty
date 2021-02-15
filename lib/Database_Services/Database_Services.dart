import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';

class Database_Services {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  // firebase_storage.FirebaseStorage _storage =
  //     firebase_storage.FirebaseStorage.instance;

  Future<void> addCreateToFb(
      String iName, String iAddress, String iType, File iPhoto, String iPhone1, String iPhone2, String iDesc) async {


    String downloadURL;
    int iHour = 0;
    final User firebaseUser = _auth.currentUser;
    if (iPhoto == null) {
      downloadURL =
          "https://firebasestorage.googleapis.com/v0/b/lefty-3ea7c.appspot.com/o/iPhoto%2Fdownload%20(1).jfif?alt=media&token=814aba01-5df8-4f95-b395-cbf595d266d4";
    } else {
      downloadURL = await uploadFile(iPhoto.path);
    }

    CollectionReference collectionReference1 =
        FirebaseFirestore.instance.collection("iDetails").doc("data").collection(firebaseUser.uid);
    CollectionReference collectionReference2 = FirebaseFirestore.instance.collection("iPublic");
    // firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
    //     .ref()
    //     .child("iPhoto");

    if (!(downloadURL == 'Error')) {
      collectionReference1.add({
        'iName': iName,
        'iAddress': iAddress,
        'iType': iType,
        'iHour': iHour,
        'iPhoto': downloadURL,
        'iPhone1': iPhone1,
        'iPhone2': iPhone2,
        'iDesc': iDesc,
        'time': DateTime.now(),
        'uid': firebaseUser.uid,
      }).then((value) {
        return 'Done';
      }).catchError((onError) {
        return 'Error';
      });

      collectionReference2.add({
        'iName': iName,
        'iAddress': iAddress,
        'iType': iType,
        'iHour': iHour,
        'iPhoto': downloadURL,
        'iPhone1': iPhone1,
        'iPhone2': iPhone2,
        'iDesc': iDesc,
        'time': DateTime.now(),
        'uid': firebaseUser.uid,
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
}
