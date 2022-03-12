import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:place_picker/place_picker.dart';
import 'package:slahly/utils/constants.dart';

class LocationScreen extends StatefulWidget {
  static final String routeName = "/locationComponent";

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            locatePosition();
          },
        ),
      body: GoogleMap(
        // padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
        mapType: MapType.normal,
        myLocationButtonEnabled: true,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controllerGoogleMap.complete(controller);
          newGoogleMapController = controller;

          setState(() {
            // bottomPaddingOfMap = 300;
          });

          locatePosition();
        },
      )
          // Positioned(
          //   left: 0,
          //   right: 0,
          //   bottom: 0,
          //   child: Container(
          //     height: 245,
          //     decoration: BoxDecoration(
          //       color: Colors.white,
          //       borderRadius: BorderRadius.only(
          //           topLeft: Radius.circular(15),
          //           topRight: Radius.circular(18)),
          //       boxShadow: [
          //         BoxShadow(
          //             color: Colors.black,
          //             blurRadius: 16,
          //             spreadRadius: 0.5,
          //             offset: Offset(0.7, 0.7))
          //       ],
          //     ),
          //     child: Padding(
          //       padding:
          //           const EdgeInsets.symmetric(horizontal: 24.0, vertical: 18),
          //       child: Text(""),
          //     ),
          //   ),
          // ),


      // GoogleMap(
      //   onMapCreated: _onMapCreated,
      //   // mapToolbarEnabled: true,
      //   // myLocationEnabled: true,
      //   // myLocationButtonEnabled: true,
      //   scrollGesturesEnabled: true,
      //   zoomGesturesEnabled: true,
      //   zoomControlsEnabled: true,
      //   mapToolbarEnabled: true,
      //   onTap: (loc) {
      //     // print("OKAY OKAY OKAY OKAY OKAY OKAY OKAY OKAY OKAY OKAY ");
      //     // showPlacePicker(loc);
      //     // print("OKAY OKAY OKAY OKAY OKAY OKAY OKAY OKAY OKAY OKAY ");
      //   },
      //   markers: myMarkers,
      //   initialCameraPosition: CameraPosition(
      //     target: _center,
      //     zoom: 11.0,
      //   ),
      // ),
      // floatingActionButton: FloatingActionButton(onPressed: (){setState(() {
      //   _center =  LatLng(_startPos.latitude, _startPos.longitude);
      // });},),

    );
  }

  Future checkPermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      print("Location services are disabled.");
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        print('Location permissions are denied');
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      print('Location permissions are permanently denied, we cannot request permissions.');
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return true;
  }

  //Google maps
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  late GoogleMapController newGoogleMapController;
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  // Current Location
  late Position current_pos;
  Geolocator geoLocator = Geolocator();
  double bottomPaddingOfMap = 0;

  void locatePosition() async {
    checkPermission().onError((error, stackTrace)  {
      print("ADADDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD");
      print(error);
      print("ADADDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD");
      return;
    });
    // if (!) {
    //   return;
    // }

    Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    current_pos = pos;

    LatLng latlatPosition = LatLng(pos.latitude, pos.longitude);

    CameraPosition camPos =
        new CameraPosition(target: latlatPosition, zoom: 17);
    newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(camPos));
  }

  //PlacePicker old
  void showPlacePicker(customLocation) async {
    LocationResult result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PlacePicker(
              googleMapsAPI,
              displayLocation: customLocation,
            )));

    // Handle the result in your way
    print(result);
  }

  Future<Position> getMyLocationOLDOLDOLD() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  //useless

  @override
  void initState() {
    super.initState();
    startFun();
  }

  void startFun() async {}

  Set<Marker> myMarkers = {Marker(markerId: MarkerId("myloc"))};
}
