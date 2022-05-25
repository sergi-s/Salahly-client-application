import 'dart:async';

import "package:flutter/material.dart";
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:slahly/classes/models/location.dart';
import 'package:slahly/utils/location/geocoding.dart';
import 'package:slahly/utils/location/getuserlocation.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({Key? key}) : super(key: key);

  @override
  State<MapWidget> createState() => MapWidgetState();
}

class MapWidgetState extends State<MapWidget> {
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();
  late GoogleMapController newGoogleMapController;

  static const double initialCameraZoom = 15;
  double cameraZoom = 14;

  // Current Location
  // late Position currentPos;
  late LatLng currentPos;
  late CustomLocation currentCustomLoc;
  static CustomLocation? location;
  Geolocator geoLocator = Geolocator();

  //initial Camera position
  final CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(30.0444, 31.2357),
    zoom: initialCameraZoom,
  );

  //Markers
  List<Marker> myMarkers = [];

  @override
  void initState() {
    initialLocation();
    locatePosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        GoogleMap(
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            // myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: false,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;
            },
            markers: Set.from(myMarkers),
            onTap: _handleTap),
      ],
    ));
  }

  //get user position
  locatePosition() async {
    currentCustomLoc = await getUserLocation();
    cameraZoom = 19;
    moveCamera(currentCustomLoc);
  }

  //move camera to current position
  moveCamera(CustomLocation cus) async {
    currentCustomLoc = cus;
    currentCustomLoc.address = await searchCoordinateAddress_google(
        currentCustomLoc.latitude, currentCustomLoc.longitude);

    LatLng latLatPosition =
        LatLng(currentCustomLoc.latitude, currentCustomLoc.longitude);

    setState(() {
      myMarkers = [];
      myMarkers.add(
        Marker(
            markerId: MarkerId(latLatPosition.toString()),
            position: latLatPosition),
      );
    });

    CameraPosition camPos =
        CameraPosition(target: latLatPosition, zoom: cameraZoom);
    newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(camPos));
  }

  //put a marker on pressed on map
  _handleTap(LatLng tappedPoint) {
    setState(() {
      cameraZoom = 19;
      moveCamera(CustomLocation(
          latitude: tappedPoint.latitude, longitude: tappedPoint.longitude));
      myMarkers = [];
      myMarkers.add(
        Marker(
            draggable: true,
            markerId: MarkerId(tappedPoint.toString()),
            position: tappedPoint,
            onDragEnd: (dragEndPosition) {
              moveCamera(CustomLocation(
                  latitude: dragEndPosition.latitude,
                  longitude: dragEndPosition.longitude));
            }),
      );
    });
  }

  //get approximate location of user
  initialLocation() async {
    List temp = await getApproximateLocation();
    CustomLocation initialPos =
        CustomLocation(latitude: temp[0], longitude: temp[1]);

    moveCamera(initialPos);
  }
}
