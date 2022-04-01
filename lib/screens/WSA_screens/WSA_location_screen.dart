import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:slahly/classes/models/location.dart';
import 'package:slahly/screens/WSA_screens/wsa_search_screen.dart';
import 'package:slahly/utils/location/getuserlocation.dart';
import 'package:slahly/utils/location/geocoding.dart';
import "package:slahly/widgets/WSA/TextFieldOnMap.dart";

class WSALocationScreen extends StatefulWidget {
  static const String routeName = "/WSALocationScreen";

  @override
  _WSALocationScreenState createState() => _WSALocationScreenState();
}

class _WSALocationScreenState extends State<WSALocationScreen> {
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
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     ElevatedButton(
        //         onPressed: locatePosition, child: Icon(Icons.my_location)),
        // const SizedBox(width: 4),
        // ElevatedButton(
        //     onPressed: () {
        //       showSimpleNotification(
        //           Text("CurrentCustom lat: " +
        //               currentCustomLoc.latitude.toString() +
        //               "  long:  " +
        //               currentCustomLoc.longitude.toString()),
        //           background: Colors.green);
        //       // context.go(SearchingMechanicProvider.routeName,
        //       //     extra: currentCustomLoc);
        //     },
        //     child: Text("confirm_location".tr())),
        //   ],
        // ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
        Positioned(
          left: 300,
          right: 0,
          bottom: 275,
          child: ElevatedButton(
            onPressed: locatePosition,
            child: const Icon(
              Icons.location_on,
            ),
            style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              padding: EdgeInsets.all(10),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
              height: 270,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black,
                        blurRadius: 16,
                        spreadRadius: 0.5,
                        offset: Offset(0.7, 0.7))
                  ]),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6),
                    Text("Hi there", style: TextStyle(fontSize: 12)),
                    Text("Where to?", style: TextStyle(fontSize: 20)),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        print(
                            "before next scree${currentCustomLoc.toString()}");
                        context.push(WSASearchScreen.routeName,
                            extra: currentCustomLoc);
                      },
                      child: const TextFieldOnMap(
                        isSelected: false,
                        textToDisplay: "You Current Location",
                        iconToDisplay: Icon(
                          Icons.my_location,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const TextFieldOnMap(
                      isSelected: true,
                      textToDisplay: "Where to?",
                      iconToDisplay: Icon(
                        Icons.search,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ],
    ));
  }

  void locatePosition() async {
    currentCustomLoc = await getUserLocation();

    print(
        "lat:${currentCustomLoc.latitude} - long:${currentCustomLoc.longitude}");
    print("address: ${currentCustomLoc.address}");

    moveCamera(currentCustomLoc);
  }

  moveCamera(CustomLocation cus) async {
    currentCustomLoc = cus;

    currentCustomLoc.address = await searchCoordinateAddress_google(
        currentCustomLoc.latitude, currentCustomLoc.longitude);

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
