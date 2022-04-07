import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:slahly/classes/models/location.dart';
import 'package:slahly/classes/provider/rsadata.dart';
import 'package:slahly/utils/location/getuserlocation.dart';
import 'package:slahly/utils/location/geocoding.dart';
import "package:slahly/widgets/dropOff/TextFieldOnMap.dart";

import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:slahly/classes/firebase/roadsideassistance/roadsideassistance.dart';
import 'package:slahly/classes/models/mechanic.dart';
import 'package:slahly/widgets/WSA/choose_mech_slider.dart';
import 'package:slahly/widgets/roadsideassistance/services_provider_card.dart';

class WSAScreen extends StatefulWidget {
  static const String routeName = "/WSAScreen";

  const WSAScreen({Key? key}) : super(key: key);

  @override
  State<WSAScreen> createState() => _WSAScreenState();
}

class _WSAScreenState extends State<WSAScreen> {
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();
  late GoogleMapController newGoogleMapController;

  static const double initialCameraZoom = 15;
  double cameraZoom = 14;

  // Current Location
  // late Position currentPos;
  late LatLng currentPos;
  late CustomLocation currentCustomLoc;

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
    // initialLocation();
    locatePosition();

    // WidgetRef ref= WidgetRef();
    // getAcceptedMechanic();

    super.initState();
  }

  bool needProvider = false;
  bool gotMechanics = false;

  final PanelController _pc = PanelController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          left: MediaQuery.of(context).size.width * 0.8,
          right: 0,
          bottom: MediaQuery.of(context).size.height * 0.4,
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
            height: MediaQuery.of(context).size.height * 0.39,
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
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6),
                  Text(("hi_there".tr()), style: TextStyle(fontSize: 12)),
                  Text(("where_to".tr()), style: TextStyle(fontSize: 20)),
                  const SizedBox(height: 20),
                  TextFieldOnMap(
                    isSelected: false,
                    textToDisplay: ("your_current_location".tr()),
                    iconToDisplay: const Icon(
                      Icons.my_location,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Consumer(
                    builder: (context, ref, child) {
                      return GestureDetector(
                        child: getMechanicWidget(ref),
                        onTap: () async {
                          await requestWSA(ref);
                          _pc.open();
                        },
                      );
                    },
                  ),
                  Consumer(
                    builder: (context, ref, child) {
                      return GestureDetector(
                        child: getMechanicWidget(ref),
                        onTap: () async {
                          await ref.watch(rsaProvider.notifier).requestRSA();
                          print("after");
                          print("LOVE::${ref.watch(rsaProvider).rsaID}");
                          _pc.open();
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 15),
                  GestureDetector(
                    child: TextFieldOnMap(
                      textToDisplay: "Do you need a Tow truck",
                      iconToDisplay: const Icon(Icons.wheelchair_pickup_sharp),
                      isSelected: !needProvider,
                      child: Switch(
                        value: !needProvider,
                        onChanged: (value) {
                          setState(() => needProvider = !needProvider);
                        },
                        activeTrackColor: Colors.lightGreenAccent,
                        activeColor: Colors.green,
                      ),
                    ),
                    onTap: () {
                      if (needProvider) {
                        return;
                      }
                      //TODO: SAME LOGIC FOR PROVIDERS
                    },
                  )
                ],
              ),
            ),
          ),
        ),
        Consumer(builder: (context, ref, child) {
          print("HEEEEEE");
          RSA rsa = ref.watch(rsaProvider);
          getAcceptedMechanic(ref);
          return ChooseMechanicSlider(
              pc: _pc, mechanics: rsa.acceptedNearbyMechanics ?? []);
        })
      ],
    ));
  }

  //request work shop assistance
  requestWSA(ref) async {
    print("Requesting WSA::");
    RSA rsa = ref.watch(rsaProvider);
    RSANotifier rsaNotifier = ref.watch(rsaProvider.notifier);
    rsaNotifier.assignUserLocation(currentCustomLoc);

    if (!gotMechanics) {
      gotMechanics = true;
      await rsaNotifier.searchNearbyMechanicsAndProviders();
      print("again?");
    }
  }

  bool flagFoula = false;

  getAcceptedMechanic(ref) {
    if (flagFoula) {
      return;
    }
    flagFoula = true;

    print("IN STREAM FUNCTION ::");
    DatabaseReference rsaRef = FirebaseDatabase.instance.ref().child("rsa");
    RSANotifier rsaNotifier = ref.watch(rsaProvider.notifier);
    RSA rsa = ref.watch(rsaProvider);
    if (rsa.rsaID == null) return [];

    rsaRef.child(rsa.rsaID!).onValue.listen((event) {
      List<Mechanic> acceptedMechanic = [];
      print("LISTENER");
      print("${event.snapshot.value}");
      if (event.snapshot.value != null) {
        DataSnapshot dataSnapshot = event.snapshot;

        if (dataSnapshot.child("state").value.toString() ==
            RSA.stateToString(RSAStates.waitingForMechanicResponse)) {
          dataSnapshot.child("mechanicsResponses").children.forEach((mechanic) {
            print("Stream::${mechanic}");
            if (mechanic.value == "accepted") {
              print("ADDED ${mechanic.key}");
              for (var mech in rsa.nearbyMechanics!) {
                if (mech.id == mechanic.key) acceptedMechanic.add(mech);
              }
            }
          });

          //If a new mechanic entered in the range of the geoFire
          //check the mechanic in the sm same as the geoFire
          // if the arr is the same
          //don't do anything
          //
          // bool flag = true;
          // if (acceptedMechanic.length == rsa.acceptedNearbyMechanics?.length) {
          //   for (int index = 0; index < acceptedMechanic.length; index++) {
          //     if (acceptedMechanic[index].id !=
          //         rsa.acceptedNearbyMechanics?[index].id) {
          //       flag = false;
          //       break;
          //     }
          //   }
          // }
          // flag
          //     ?
      rsaNotifier.assignAcceptedNearbyMechanics(acceptedMechanic);
              // : "";
        }
      }
    });
  }

  //Get assigned mechanic
  Widget getMechanicWidget(ref) {
    RSA rsa = ref.watch(rsaProvider);
    return (rsa.mechanic != null
        ? mapMechanicToWidget(rsa.mechanic!)
        // ? Container(child: Text("Mech exits"))
        : const TextFieldOnMap(
            isSelected: true,
            textToDisplay: ("Choose nearby mechanics"),
            iconToDisplay: Icon(
              Icons.search,
              color: Colors.blue,
            ),
          ));
  }

  //Get UI of assigned mechanic
  Widget mapMechanicToWidget(Mechanic mec) {
    print("MECHH::${mec.toString()}");
    return ServicesProviderCard(
      serviceProviderEmail: mec.email!,
      serviceProviderName: mec.name!,
      serviceProviderIsCenter: mec.isCenter ?? false,
      serviceProviderType: mec.getUserType()!,
      serviceProviderPhoneNumber: mec.phoneNumber!,
    );
  }

  //get user position
  locatePosition() async {
    currentCustomLoc = await getUserLocation();
    cameraZoom = 19;
    print(
        "::lat:${currentCustomLoc.latitude} - long:${currentCustomLoc.longitude}");
    print("::address: ${currentCustomLoc.address}");

    moveCamera(currentCustomLoc);
  }

  //move camera to current position
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
