import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:slahly/classes/models/location.dart';
import 'package:slahly/abstract_classes/user.dart';
import 'package:slahly/classes/models/towProvider.dart';
import 'package:slahly/classes/provider/rsadata.dart';
import 'package:slahly/utils/location/getuserlocation.dart';
import 'package:slahly/utils/location/geocoding.dart';
import "package:slahly/widgets/dropOff/TextFieldOnMap.dart";

import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:slahly/classes/firebase/roadsideassistance/roadsideassistance.dart';
import 'package:slahly/classes/models/mechanic.dart';
import 'package:slahly/widgets/WSA/choose_mech_slider.dart';
import 'package:slahly/widgets/roadsideassistance/services_provider_card.dart';

import '../../utils/constants.dart';

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

  final PanelController _pcMechanic = PanelController();

  final PanelController _pcTowProvider = PanelController();

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
          bottom: MediaQuery.of(context).size.height * 0.45,
          child: ElevatedButton(
            onPressed: locatePosition,
            child: const Icon(
              Icons.location_on,
            ),
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(10),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.42,
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
                  Text(("hi_there".tr()), style: const TextStyle(fontSize: 12)),
                  Text(("where_to".tr()), style: const TextStyle(fontSize: 20)),
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
                          if (ref.watch(rsaProvider).mechanic == null) {
                            _pcMechanic.open();
                          }
                          await requestWSA(ref);
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 15),
                  Consumer(
                    builder:
                        (BuildContext context, WidgetRef ref, Widget? child) {
                      return GestureDetector(
                          child: getProviderWidget(ref),
                          onTap: () {
                            if (needProvider) return;
                            if (ref.watch(rsaProvider).mechanic == null) {
                              _pcTowProvider.open();
                            }
                          });
                    },
                  )
                ],
              ),
            ),
          ),
        ),
        Consumer(builder: (context, ref, child) {
          RSA rsa = ref.watch(rsaProvider);
          print("HEEEEEE${rsa.acceptedNearbyMechanics}");
          return ChooseMechanicSlider(
              pc: _pcMechanic, mechanics: rsa.acceptedNearbyMechanics ?? []
              // pc: _pc, mechanics: mechanics,
              );
        }),
        Consumer(builder: (context, ref, child) {
          RSA rsa = ref.watch(rsaProvider);
          print("PROVIDER:HEEEEEE${rsa}");
          return ChooseTowProviderSlider(
              pc: _pcTowProvider,
              towProviders: rsa.acceptedNearbyProviders ?? []
              // pc: _pc, mechanics: mechanics,
              );
        }),
      ],
    ));
  }

  //request work shop assistance
  requestWSA(ref) async {
    print("Requesting WSA::");
    RSANotifier rsaNotifier = ref.watch(rsaProvider.notifier);
    rsaNotifier.assignRequestTypeToWSA();
    rsaNotifier.assignUserLocation(currentCustomLoc);

    await rsaNotifier.requestWSA();
    if (!gotMechanics) {
      gotMechanics = true;
      await rsaNotifier.searchNearbyMechanicsAndProviders();
    }
    getAcceptedMechanic(ref);
  }

  getAcceptedMechanic(ref) {
    print("IN STREAM FUNCTION ::");
    RSA rsa = ref.watch(rsaProvider);
    if (rsa.rsaID == null) return [];

    wsaRef.child(rsa.rsaID!).onValue.listen((event) {
      print("WSA LISTENER");
      print("${event.snapshot.value}");
      if (event.snapshot.value != null) {
        DataSnapshot dataSnapshot = event.snapshot;
        print("1111111");
        // if (dataSnapshot.child("state").value.toString() ==
        //     RSA.stateToString(RSAStates.waitingForMechanicResponse)) {
        print("2222222");
        dataSnapshot
            .child("mechanicsResponses")
            .children
            .forEach((dataSnapShotMechanic) {
          print("333333333333");
          print("Stream::${dataSnapShotMechanic.value}");
          if (dataSnapShotMechanic.value == "accepted") {
            print(
                "inside if accepted and ${dataSnapShotMechanic.key} accepted");

            print(
                "AAAAAAAAAAAAAAAAAAAAA${ref.watch(rsaProvider).newNearbyMechanics}");
            for (var mech in ref.watch(rsaProvider).newNearbyMechanics.keys) {
              print(
                  "${mech} ====== ${dataSnapShotMechanic.key}-> ${dataSnapShotMechanic.key == mech}");
              print("do I already have him?");
              if (dataSnapShotMechanic.key == mech) {
                print(
                    "YESSSSSSSSSSSSS->${ref.watch(rsaProvider).newNearbyMechanics[mech].name}");
                ref.watch(rsaProvider.notifier).addAcceptedNearbyMechanic(
                    ref.watch(rsaProvider).newNearbyMechanics[mech]);
                // print(ref.watch(rsaProvider).);
              }
            }
          }
        });
        // }

        dataSnapshot
            .child("providersResponses")
            .children
            .forEach((dataSnapShotProvider) {
          print("PROV::333333333333");
          print("PROV::Stream::${dataSnapShotProvider.value}");
          if (dataSnapShotProvider.value == "accepted") {
            print(
                "PROV::inside if accepted and ${dataSnapShotProvider.key} accepted");

            print(
                "PROV::AAAAAAAAAAAAAAAAAAAAA${ref.watch(rsaProvider).newNearbyProviders}");
            for (var towProvider
                in ref.watch(rsaProvider).newNearbyProviders.keys) {
              print(
                  "${towProvider} ====== ${dataSnapShotProvider.key}-> ${dataSnapShotProvider.key == towProvider}");
              print("PROV::do I already have him?");
              if (dataSnapShotProvider.key == towProvider) {
                print(
                    "PROV::YESSSSSSSSSSSSS->${ref.watch(rsaProvider).newNearbyProviders[towProvider].name}");
                ref.watch(rsaProvider.notifier).addAcceptedNearbyProvider(
                    ref.watch(rsaProvider).newNearbyProviders[towProvider]);
                // print(ref.watch(rsaProvider).);
              }
            }
          }
        });
      }
    });
  }

  // Get assigned Provider
  Widget getProviderWidget(ref) {
    RSA rsa = ref.watch(rsaProvider);
    return (rsa.towProvider != null
        ? mapTowProviderToWidget(rsa.towProvider!)
        // ? Container(child: Text("Mech exits"))
        : TextFieldOnMap(
            textToDisplay: "Do you need a Tow truck",
            imageIconTodisplay:
                const ImageIcon(AssetImage('assets/images/tow-truck 2.png')),
            isSelected: !needProvider,
            child: Switch(
              value: !needProvider,
              onChanged: (value) {
                setState(() => needProvider = !needProvider);
              },
              activeTrackColor: Colors.lightGreenAccent,
              activeColor: Colors.green,
            ),
          ));
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

  Widget mapTowProviderToWidget(TowProvider towProvider) {
    print("MECHH::${towProvider.toString()}");
    return ServicesProviderCard(
      serviceProviderEmail: towProvider.email!,
      serviceProviderName: towProvider.name!,
      serviceProviderIsCenter: towProvider.isCenter ?? false,
      serviceProviderType: towProvider.getUserType()!,
      serviceProviderPhoneNumber: towProvider.phoneNumber!,
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

  List<Mechanic> mechanics = [
    Mechanic(
        name: 'Ahmed tarek',
        phoneNumber: '01115612314',
        isCenter: true,
        type: Type.mechanic,
        loc: CustomLocation(
            address:
                "Factorya, shar3 45 odam mtafy 12311321312312hasdhdashjss221",
            latitude: 11,
            longitude: 12),
        avatar:
            'https://thumbs.dreamstime.com/b/default-avatar-photo-placeholder-profile-image-default-avatar-photo-placeholder-profile-image-eps-file-easy-to-edit-124557892.jpg',
        email: 'email@yahoo.com'),
    Mechanic(
        name: 'Sergi Samir',
        email: 'mechanic@yahoo.com',
        type: Type.mechanic,
        phoneNumber: '0122321099',
        loc: CustomLocation(
            address: "sedigabr,180 3omrt y3okbyan",
            latitude: 11,
            longitude: 12),
        isCenter: false,
        avatar:
            'https://thumbs.dreamstime.com/b/default-avatar-photo-placeholder-profile-image-default-avatar-photo-placeholder-profile-image-eps-file-easy-to-edit-124557892.jpg'),
    Mechanic(
        name: 'Mahmoud Magdy',
        type: Type.mechanic,
        email: 'Workshop@gmail.com',
        phoneNumber: '01550164495',
        loc: CustomLocation(
            address: "Miami, mostshafa 3m ahmed", latitude: 11, longitude: 12),
        isCenter: true,
        avatar:
            'https://thumbs.dreamstime.com/b/default-avatar-photo-placeholder-profile-image-default-avatar-photo-placeholder-profile-image-eps-file-easy-to-edit-124557892.jpg')
  ];
}
