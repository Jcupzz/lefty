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
      int iHour, File iPhoto, String iPhone1, String iPhone2,String iDesc) async{

    final User firebaseUser = _auth.currentUser;

    // firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
    //     .ref()
    //     .child("iPhoto");


    String downloadURL = await uploadFile(iPhoto.path);
    if(!(downloadURL == 'Error'))
      {

       firestore.collection("iDetails").add({
         'iName':iName,
         'iAddress':iAddress,
         'iType':iType,
         'iHour':iHour,
         'iPhoto':downloadURL,
         'iPhone1':iPhone1,
         'iPhone2':iPhone2,
         'iDesc':iDesc,
         'time':DateTime.now(),
         'uid':firebaseUser.uid,
       }).then((value) {
          return 'Done';
       }).catchError((onError){
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
          .putFile(file).then((val) async {
            downloadURL = await val.ref.getDownloadURL();
      });
      return downloadURL;
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      return "Error";
    }
  }
}
