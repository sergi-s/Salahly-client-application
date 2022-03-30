import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:slahly/classes/models/location.dart';
import 'package:slahly/screens/roadsideassistance/waitforarrival.dart';
import 'package:slahly/utils/location/getuserlocation.dart';
import 'package:slahly/utils/location/search_coordinate_address.dart';

class MyLocationScreen extends StatefulWidget {
  static const String routeName = "/locationComponent";

  @override
  _MyLocationScreenState createState() => _MyLocationScreenState();
}

class _MyLocationScreenState extends State<MyLocationScreen> {
  //Google maps
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();
  late GoogleMapController newGoogleMapController;

  static const double cameraZoom = 20;

  // Current Location
  // late Position currentPos;
  late LatLng currentPos;
  late CustomLocation currentCustomLoc;

  Geolocator geoLocator = Geolocator();

  //initial Camera position
  final CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: cameraZoom,
  );

  //Markers
  List<Marker> myMarkers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: locatePosition, child: Text('my_location'.tr())),
            const SizedBox(width: 4),
            ElevatedButton(
                onPressed: () {
                  showSimpleNotification(
                      Text("CurrentCustom lat: " +
                          currentCustomLoc.latitude.toString()+"  long:  "+currentCustomLoc.longitude.toString()),
                      background: Colors.green);
                  // context.go(SearchingMechanicProvider.routeName,
                  //     extra: currentCustomLoc);
                },
                child: Text("confirm_location".tr())),

          ],
        ),
        // FloatingActionButton.extended(
        //   onPressed: () {
        //     locatePosition();
        //   },
        //   label: Text('my_location'.tr()),
        //   icon: const Icon(Icons.location_on),
        // ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: true,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controllerGoogleMap.complete(controller);
                newGoogleMapController = controller;
              },
              markers: Set.from(myMarkers),
              onTap: _handleTap,
            ),
          ],
        ));
  }

  void locatePosition() async {
    currentCustomLoc = await getUserLocation();
    // currentPos = pos;

    LatLng latLatPosition =
        LatLng(currentCustomLoc.latitude, currentCustomLoc.longitude);

    moveCamera(currentCustomLoc);
  }

  moveCamera(CustomLocation cus) async {
    currentCustomLoc = cus;

    //update address
    currentCustomLoc.address = await searchCoordinateAddress(
        currentCustomLoc.latitude, currentCustomLoc.longitude);

    print(currentCustomLoc.address);

    LatLng latLatPosition =
        LatLng(currentCustomLoc.latitude, currentCustomLoc.longitude);

    CameraPosition camPos =
        CameraPosition(target: latLatPosition, zoom: cameraZoom);
    newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(camPos));
  }

  _handleTap(LatLng tappedPoint) {
    setState(() {
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
}
