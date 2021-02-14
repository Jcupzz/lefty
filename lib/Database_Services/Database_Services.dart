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




  Future<void> addCreateToFb(String iName, String iAddress, String iType,
      int iHour, File iPhoto, String iPhone1, String iPhone2) async{

    final User firebaseUser = _auth.currentUser;

    // firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
    //     .ref()
    //     .child("iPhoto");


    String isUploaded = await uploadFile(iPhoto.path);
    if(!(isUploaded == 'Error'))
      {

       firestore.collection(firebaseUser.uid).add({
         'iName':iName,
         'iAddress':iAddress,
         'iType':iType,
         'iHour':iHour,
         'iPhoto':isUploaded,
         'iPhone1':iPhone1,
         'iPhone2':iPhone2,
       }).then((value) {
          return 'Done';
       }).catchError((onError){
         return 'Error';
       });
      }
    
  }
  Future<String> uploadFile(String filePath) async {
    File file = File(filePath);
    String d;
    try {
      await firebase_storage.FirebaseStorage.instance
          .ref('iPhoto')
          .child("${DateTime.now().millisecondsSinceEpoch}")
          .putFile(file).then((val) async {
            d = await val.ref.getDownloadURL();
      });
      return d;
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      return "Error";
    }
  }
}
