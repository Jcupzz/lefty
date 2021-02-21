import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

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

    myMarker.add(Marker(
        markerId: MarkerId(LatLng(widget.document['lat'], widget.document['long']).toString()),
        position: LatLng(widget.document['lat'], widget.document['long'])));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
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
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                  child: Text(
                    widget.document.data()['iType'],
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                CachedNetworkImage(
                  imageUrl: widget.document.data()['iPhoto'],
                  imageBuilder: (context, imageProvider) => Container(
                    margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  child: ListTile(
                    title: Text('Description', style: Theme.of(context).textTheme.bodyText2),
                    subtitle: Text(widget.document.data()['iDesc'], style: Theme.of(context).textTheme.bodyText1),
                  ),
                ),
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  child: ListTile(
                    title: Text(
                      '\nAddress',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    subtitle: Text(widget.document.data()['iAddress'] + '\n', style: Theme.of(context).textTheme.bodyText1),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(widget.document['lat'], widget.document['long']),
                        zoom: 11,
                      ),
                      markers: Set.from(myMarker),
                    ),
                  ),
                ),
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  child: ListTile(
                    trailing: IconButton(
                        splashColor: Theme.of(context).splashColor,
                        icon: Icon(Icons.phone),
                        onPressed: () {
                          _launchURL('tel:${widget.document.data()['iPhone1']}');
                        }),
                    title: Text('Primary Contact', style: Theme.of(context).textTheme.bodyText2),
                    subtitle: Text(widget.document.data()['iPhone1'], style: Theme.of(context).textTheme.bodyText1),
                  ),
                ),
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  child: ListTile(
                    trailing: IconButton(
                        splashColor: Theme.of(context).splashColor,
                        icon: Icon(Icons.phone),
                        onPressed: () {
                          _launchURL('tel:${widget.document.data()['iPhone2']}');
                        }),
                    title: Text('Secondary Contact', style: Theme.of(context).textTheme.bodyText2),
                    subtitle: Text(widget.document.data()['iPhone2'], style: Theme.of(context).textTheme.bodyText1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
