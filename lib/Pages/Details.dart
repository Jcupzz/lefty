import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Details extends StatefulWidget {
  DocumentSnapshot document;

  Details(DocumentSnapshot document) {
    this.document = document;
  }

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 20, 8, 20),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(3,0,3,0),
                  child: Text(
                    widget.document.data()['iName'],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(4,0,4,0),
                  child: Text(
                    widget.document.data()['iType'],
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                CachedNetworkImage(
                  imageUrl: widget.document.data()['iPhoto'],
                  imageBuilder: (context, imageProvider) => Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width * 0.75,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(14),
                      image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                    ),
                  ),
                  placeholder: ((context, s) => Center(
                        child: CircularProgressIndicator(),
                      )),
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 5,),
                // Container(
                //   width: MediaQuery.of(context).size.width,
                //   child: Card(
                //       child: Padding(
                //         padding: const EdgeInsets.fromLTRB(15, 10, 10, 10),
                //         child: RichText(
                //           text: new TextSpan(
                //             // Note: Styles for TextSpans must be explicitly defined.
                //             // Child text spans will inherit styles from parent
                //             style: new TextStyle(
                //               fontSize: 14.0,
                //               color: Colors.black,
                //             ),
                //             children: <TextSpan>[
                //               new TextSpan(text: 'Description', style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 12)),
                //               new TextSpan(text: '\n'+widget.document.data()['iDesc'], style: new TextStyle(fontSize: 14)),
                //             ],
                //           ),
                //         )
                //       ),
                //       elevation: 8,
                //       color: Colors.white,
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(10),
                //       )),
                // ),
                Card(
                  elevation: 20,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)
                  ),
                  child: ListTile(
                    title: Text('Description',style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 14)),
                    subtitle: Text(widget.document.data()['iDesc'],style: new TextStyle(color: Colors.black,fontSize: 18)),
                  ),
                ),
                Card(
                  elevation: 20,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)
                  ),
                  child: ListTile(
                    title: Text('Address',style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 14)),
                    subtitle: Text(widget.document.data()['iAddress'],style: new TextStyle(color: Colors.black,fontSize: 18)),
                  ),
                ),
                Card(
                  elevation: 20,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)
                  ),
                  child: ListTile(
                    trailing: IconButton(icon: Icon(Icons.phone), onPressed: (){}),
                    title: Text('Primary Contact',style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 14)),
                    subtitle: Text(widget.document.data()['iPhone1'],style: new TextStyle(color: Colors.black,fontSize: 18)),
                  ),
                ),
                Card(
                  elevation: 20,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)
                  ),
                  child: ListTile(
                    trailing: IconButton(icon: Icon(Icons.phone), onPressed: (){}),
                    title: Text('Secondary Contact',style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 14)),
                    subtitle: Text(widget.document.data()['iPhone2'],style: new TextStyle(color: Colors.black,fontSize: 18)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
