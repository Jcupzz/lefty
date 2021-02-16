import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Select_Location extends StatefulWidget {
  @override
  _Select_LocationState createState() => _Select_LocationState();
}

class _Select_LocationState extends State<Select_Location> {
  GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

//

  LatLng currentPostion;

  void _getUserLocation() async {
    var position = await GeolocatorPlatform.instance.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      currentPostion = LatLng(position.latitude, position.longitude);
    });
  }

  @override
  void initState() {
    _getUserLocationPermission();
    _getUserLocation();

    super.initState();
  }

//

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Maps Sample App'),
          backgroundColor: Colors.green[700],
        ),
        body: currentPostion != null ? GoogleMap(
          mapToolbarEnabled: true,
          buildingsEnabled: true,
          tiltGesturesEnabled: true,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: currentPostion,
            zoom: 10,
          ),
        ):Container(),
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
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        return Future.error('Location permissions are denied (actual value: $permission).');
      }
    }
  }
}
//error: The name 'LocationAccuracy' is defined in the libraries 'package:geolocator_platform_interface/src/enums/location_accuracy.dart' and 'package:location_platform_interface/location_platform_interface.dart (via package:location/location.dart)'. (
