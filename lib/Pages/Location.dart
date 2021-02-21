import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lefty/Pages/Details.dart';
import 'package:lefty/static/Circular_Loading.dart';

class Location extends StatefulWidget {
  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<Location> {
  bool showDetailsButton = false;
  GoogleMapController mapController;
  List<Marker> myMarker = [];
  DocumentSnapshot documentSnapshot;

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

//
  LatLng currentPostion;

  void _getUserLocation() async {
    var position = await GeolocatorPlatform.instance.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    if (position != null) {
      setState(() {
        currentPostion = LatLng(position.latitude, position.longitude);
      });
    } else {
      setState(() {
        currentPostion = LatLng(56.53455, 65.4533434);
      });
    }
  }

  void _getAllLatLongFromFb() async {
    await FirebaseFirestore.instance
        .collection("iDetails")
        .where('isRequested', isEqualTo: true)
        .get()
        .then((QuerySnapshot querySnapshot) => querySnapshot.docs.forEach((doc) {
              myMarker.add(Marker(
                  markerId: MarkerId(LatLng(doc['lat'], doc['long']).toString()),
                  onTap: () {
                    setState(() {
                      showDetailsButton = true;
                      documentSnapshot = doc;
                    });
                  },
                  position: LatLng(doc['lat'], doc['long']),
                  infoWindow: InfoWindow(title: doc['iName'], snippet: doc['iAddress'])));
            }));
  }

  @override
  void initState() {
    super.initState();
    _getUserLocationPermission();
    _getUserLocation();
    _getAllLatLongFromFb();
  }

//
  Set<Marker> marker;
  LatLng latLngs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: currentPostion != null
          ? SafeArea(
              child: Stack(
                children: [
                  GoogleMap(
                    mapToolbarEnabled: true,
                    buildingsEnabled: true,
                    mapType: MapType.hybrid,
                    myLocationButtonEnabled: true,
                    myLocationEnabled: true,
                    markers: Set.from(myMarker),
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: currentPostion,
                      zoom: 10,
                    ),
                  ),
                  (showDetailsButton)
                      ? Positioned(
                          bottom: 18,
                          left: 0,
                          child: Container(
                            height: 38,
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (documentSnapshot != null) {
                                    Navigator.push(context, MaterialPageRoute(builder: (_) => Details(documentSnapshot)));
                                  }
                                },
                                child: Text(
                                  "Show Details",
                                  style: TextStyle(color: Colors.black),
                                ),
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.white70,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                              ),
                            ),
                          ))
                      : Container(),
                ],
              ),
            )
          : Circular_Loading(),
    );
  }

  //functions
  //functions
  //functions

  Future<Position> _getUserLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      BotToast.showText(text: 'Location services are disabled');
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      BotToast.showText(text: 'Location permissions are permantly denied, we cannot request permissions');
      return Future.error('Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        BotToast.showText(text: 'Location permissions are denied (actual value: $permission)');
        return Future.error('Location permissions are denied (actual value: $permission).');
      }
    }
  }
}
