import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Request extends StatefulWidget {
  DocumentSnapshot document;
  Request(DocumentSnapshot document) {
    this.document = document;
  }
  @override
  _RequestState createState() => _RequestState();
}

class _RequestState extends State<Request> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
