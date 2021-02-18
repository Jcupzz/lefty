import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lefty/Database_Services/Database_Services.dart';
import 'package:lefty/static/Circular_Loading.dart';

class Location extends StatefulWidget {
  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<Location> {
  GoogleMapController mapController;
  List<Marker> myMarker = [];

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

//

  LatLng currentPostion;

  void _getUserLocation() async {
    var position = await GeolocatorPlatform.instance.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    if(position!=null) {
      setState(() {
        currentPostion = LatLng(position.latitude, position.longitude);
      });
    }
    else{
      setState(() {
        currentPostion = LatLng(56.53455, 65.4533434);
      });
    }
  }

  void _getAllLatLongFromFb() async {
    CollectionReference collectionReference1 =  FirebaseFirestore.instance.collection("iDetails");
    await collectionReference1.get().then((QuerySnapshot querySnapshot) =>
        querySnapshot.docs.forEach((doc) {
          myMarker.add(Marker(markerId: MarkerId(LatLng(doc['lat'], doc['long']).toString()), position:LatLng(doc['lat'],doc['long']),infoWindow: InfoWindow(title: doc['iName'])));
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
    return MaterialApp(
      home: Scaffold(

        body: currentPostion != null ? Stack(
          children: [
            GoogleMap(
              mapToolbarEnabled: false,
              buildingsEnabled: true,
              mapType: MapType.hybrid,
              tiltGesturesEnabled: true,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              markers: Set.from(myMarker),
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: currentPostion,
                zoom: 10,
              ),
            ),
          ],
        ) : Circular_Loading(),
      ),
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
