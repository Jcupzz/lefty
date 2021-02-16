import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lefty/main.dart';

class Select_Location extends StatefulWidget {
  @override
  _Select_LocationState createState() => _Select_LocationState();
}

class _Select_LocationState extends State<Select_Location> {
  GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });

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
  List<Marker> myMarker = [];
  Set<Marker> marker;
  LatLng latLngs;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Maps Sample App'),
          backgroundColor: Colors.green[700],
        ),
        body: currentPostion != null ? Stack(
          children: [

            GoogleMap(
              mapToolbarEnabled: false,
              buildingsEnabled: true,
              mapType: MapType.hybrid,
              tiltGesturesEnabled: true,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              onTap: _handleTap,
              markers: Set.from(myMarker),
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: currentPostion,
                zoom: 10,
              ),
            ),
            Positioned(
              bottom: 10,
                child:
                Container(
                  
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20,0,20,0),
                    child: ElevatedButton(
                      onPressed: () async{
                        if(latLngs!=null)
                          {
                            lat = latLngs.latitude.toString();
                            long = latLngs.longitude.toString();
                            Navigator.pop(context);
                          }
                        else{
                          BotToast.showText(text: "Tap on screen to select institute location");
                        }
                      },
                      child: Text("Done",style: TextStyle(color: Colors.white),),
                      style: ElevatedButton.styleFrom(primary: Colors.blue,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                    ),
                  ),
                )
            )

          ],
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
 _handleTap(LatLng tappedPoint){
    print(tappedPoint);
    setState(() {
      myMarker = [];
      myMarker.add(Marker(markerId: MarkerId(tappedPoint.toString()),position: tappedPoint));
      latLngs = tappedPoint;
    });
 }

}
//error: The name 'LocationAccuracy' is defined in the libraries 'package:geolocator_platform_interface/src/enums/location_accuracy.dart' and 'package:location_platform_interface/location_platform_interface.dart (via package:location/location.dart)'. (
