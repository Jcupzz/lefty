import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Details extends StatefulWidget {
  DocumentSnapshot document;

  Details(DocumentSnapshot document) {
    this.document = document;
  }

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  List<Marker> myMarker = [];
  @override
  void initState() {
    super.initState();

    myMarker.add(
        Marker(markerId: MarkerId(LatLng(widget.document['lat'], widget.document['long']).toString()), position: LatLng(widget.document['lat'], widget.document['long'])));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
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
                  padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
                  child: Text(
                    widget.document.data()['iName'],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
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
                  imageBuilder: (context, imageProvider) =>
                      Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        height: MediaQuery
                            .of(context)
                            .size
                            .width * 0.75,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(14),
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                  placeholder: ((context, s) =>
                      Center(
                        child: CircularProgressIndicator(),
                      )),
                  fit: BoxFit.cover,
                ),
                SizedBox(
                  height: 5,
                ),
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
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  child: ListTile(
                    title: Text('Description',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 14)),
                    subtitle: Text(widget.document.data()['iDesc'],
                        style:
                        TextStyle(color: Colors.black, fontSize: 18)),
                  ),
                ),
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  child: ListTile(
                    title: Text('Address',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 14)),
                    subtitle: Text(widget.document.data()['iAddress'],
                        style:
                        TextStyle(color: Colors.black, fontSize: 18)),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: GoogleMap(initialCameraPosition: CameraPosition(
                      target: LatLng(widget.document['lat'], widget.document['long']),
                      zoom: 11,
                    ),
                      markers:Set.from(myMarker),
                    ),
                  ),
                ),
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  child: ListTile(
                    trailing:
                    IconButton(icon: Icon(Icons.phone), onPressed: () {}),
                    title: Text('Primary Contact',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 14)),
                    subtitle: Text(widget.document.data()['iPhone1'],
                        style:
                        TextStyle(color: Colors.black, fontSize: 18)),
                  ),
                ),
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  child: ListTile(
                    trailing:
                    IconButton(icon: Icon(Icons.phone), onPressed: () {}),
                    title: Text('Secondary Contact',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 14)),
                    subtitle: Text(widget.document.data()['iPhone2'],
                        style:
                        TextStyle(color: Colors.black, fontSize: 18)),
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
