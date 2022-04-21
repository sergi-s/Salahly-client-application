import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slahly/classes/firebase/nearbylocations.dart';
import 'package:slahly/classes/firebase/roadsideassistance/roadsideassistance.dart';
import 'package:slahly/classes/models/client.dart';
import 'package:slahly/classes/models/location.dart';
import 'package:slahly/classes/models/mechanic.dart';
import 'package:slahly/classes/models/towProvider.dart';
import 'package:slahly/main.dart';
import 'package:slahly/utils/constants.dart';

// import 'package:slahly/classes/models/road_side_assistance.dart';

// Global for anyone to use it
final rsaProvider = StateNotifierProvider<RSANotifier, RSA>((ref) {
  return RSANotifier(ref);
});

class RSANotifier extends StateNotifier<RSA> {
  RSANotifier(this.ref)
      : super(RSA(
            location:
                CustomLocation(latitude: 31.206972, longitude: 29.919028)));
  final Ref ref;
  _RequestType? _requestType;

  // Setters
  void assignNearbyMechanics(List<Mechanic> nearbyMechanics) {
    state = state.copyWith(nearbyMechanics: nearbyMechanics);
    print("loooooooola");
  }

  void assignAcceptedNearbyMechanics(List<Mechanic> acceptedNearbyMechanics) =>
      state = state.copyWith(acceptedNearbyMechanics: acceptedNearbyMechanics);

  void assignAcceptedNearbyProviders(
          List<TowProvider> acceptedNearbyProviders) =>
      state = state.copyWith(acceptedNearbyProviders: acceptedNearbyProviders);

//Sergi Samir Boules Rizkallah
  void onFindNewMechanic(Mechanic nearbyMechanic) async {
    print("onFIndNew mechanic::");
    //I dont want to mess up the old code.

    //copy to new map (make sure their is no conflict between call by ref and call by value) and not null
    Map<String, Mechanic> tempMap = {...state.newNearbyMechanics ?? {}};

    print("MAP1:${state.newNearbyMechanics!.keys}");
    if (!tempMap.containsKey(nearbyMechanic.id)) {
      print("Temp1:${tempMap}");
      tempMap[nearbyMechanic.id!] = nearbyMechanic;

      print("Temp2:${tempMap}");

      print(":::add ${nearbyMechanic.name} to request table");
      DatabaseReference localRef =
          _requestType == _RequestType.WSA ? wsaRef : rsaRef;

      print(_requestType == _RequestType.WSA ? "WSA" : "RSA");
      if (_requestType != _RequestType.TTA) {
        localRef
            .child(state.rsaID!)
            .child("mechanicsResponses")
            .child(nearbyMechanic.id!)
            .set("pending");
      }
    }
    state = state.copyWith(newNearbyMechanics: tempMap);
    print("MAP2:${state.newNearbyMechanics!}");
  }

//Sergi Samir Boules Rizkallah
  void onFindNewProvider(TowProvider newNearbyProvider) async {
    //I dont want to mess up the old code.

    //copy to new map (make sure their is no conflict between call by ref and call by value) and not null
    Map<String, TowProvider> tempMap = {...state.newNearbyProviders ?? {}};

    print("PROV::MAP1:${state.newNearbyProviders!.keys}");
    if (!tempMap.containsKey(newNearbyProvider.id)) {
      print("PROV::Temp1:${tempMap}");
      tempMap[newNearbyProvider.id!] = newNearbyProvider;

      print("PROV::Temp2:${tempMap}");

      print("PROV:::::add ${newNearbyProvider.name} to request table");
      DatabaseReference localRef =
          _requestType == _RequestType.WSA ? wsaRef : rsaRef;

      print(_requestType == _RequestType.WSA ? "WSA" : "RSA");

      if (_requestType != _RequestType.TTA) {
        localRef
            .child(state.rsaID!)
            .child("providersResponses")
            .child(newNearbyProvider.id!)
            .set("pending");
      }
    }
    // print("MAP2:${state.newNearbyMechanics!.keys}");
    state = state.copyWith(newNearbyProviders: tempMap);
    print("PROV::MAP2:${state.newNearbyProviders}");
  }

  void addAcceptedNearbyMechanic(Mechanic newMechanic) {
    print("Will try to add ${newMechanic.name}");
    bool flage = true;
    if (state.acceptedNearbyMechanics!.isNotEmpty) {
      for (var mechanic in state.acceptedNearbyMechanics!) {
        if (mechanic.id == newMechanic.id) {
          print("${mechanic.name} already exists");
          flage = false;
        }
      }
    }
    if (flage) {
      print("Will add ${newMechanic.name}");
      state = state.copyWith(acceptedNearbyMechanics: [
        ...?state.acceptedNearbyMechanics,
        newMechanic
      ]);

      print("added ${newMechanic.name}");
    }
    print("THE ACCEPTED LIST IS mechs${state.acceptedNearbyMechanics}");
  }

  void addAcceptedNearbyProvider(TowProvider newTowProvider) {
    print("Will try to add ${newTowProvider.name}");
    bool flage = true;
    if (state.acceptedNearbyProviders!.isNotEmpty) {
      for (var towProvider in state.acceptedNearbyProviders!) {
        if (towProvider.id == newTowProvider.id) {
          print("${towProvider.name} already exists");
          flage = false;
        }
      }
    }
    if (flage) {
      print("Will add ${newTowProvider.name}");
      state = state.copyWith(acceptedNearbyProviders: [
        ...?state.acceptedNearbyProviders,
        newTowProvider
      ]);

      print("added ${newTowProvider.name}");
    }
    print("THE ACCEPTED LIST IS tow provs ${state.acceptedNearbyProviders}");
  }

  void assignMechanic(Mechanic mechanic, bool stopListener) {
    state = state.copyWith(mechanic: mechanic);
    if (stopListener) {
      NearbyLocations.stopListener();
    }
  }

  void assignNearbyProviders(List<TowProvider> nearbyProviders) =>
      state = state.copyWith(nearbyProviders: nearbyProviders);

  void assignProvider(TowProvider provider, bool stopListener) {
    state = state.copyWith(provider: provider);
    if (stopListener) {
      NearbyLocations.stopListener();
    }
  }

  assignUserLocation(CustomLocation location) =>
      state = state.copyWith(location: location);

  assignDropOffLocation(CustomLocation location) {
    state = state.copyWith(dropOffLocation: location);
    print("the new dropoff place is:: ${location.toString()}");
  }

  assignProblemDescription(String description) =>
      state = state.copyWith(problemDescription: description);

  assignUser(Client user) => state = state.copyWith(user: user);

  assignEstimatedTime(DateTime estimatedTime) =>
      state = state.copyWith(estimatedTime: estimatedTime);

  assignState(RSAStates newState) => state = state.copyWith(state: newState);

  Future _requestRSA() async {
    //testing purpose
    String userID = FirebaseAuth.instance.currentUser!.uid;
    // String userID = "met7at";
    ///TODO MAKE THIS FROM USER DATA

    DatabaseReference newRSA = dbRef.child("rsa").push();
    Map<String, dynamic> rsadata = {
      "userID": userID,
      "latitude": state.location!.latitude,
      "longitude": state.location!.longitude,
      "mechanicsResponses": {},
      "providersResponses": {},
      // "state": RSA.stateToString(RSAStates.waitingForMechanicResponse)

      "state": RSA.stateToString(RSAStates.waitingForMechanicResponse)
    };
    print("Ayoohew");
    // print(state.nearbyMechanics!.toString());
    print("Ayooh");
    for (var mech in state.nearbyMechanics!) {
      // rsadata.update("mechanicsResponses", (value) => value[]);
      if (mech.id == "1" || mech.id == "2" || mech.id == "3") continue;
      rsadata["mechanicsResponses"][mech.id.toString()] = "pending";
      // rsadata.update("mechanicsResponses", (value) => value.addAll({mech.id.toString():"pending"}));
    }
    print(rsadata["mechanicsResponses"].toString());
    for (var prov in state.nearbyProviders!) {
      rsadata["providersResponses"][prov.id.toString()] = "pending";
      // rsadata.update("providersResponses", (value) => value.addAll({prov.id.toString():"pending"}));
    }
    print("Ayooh");
    print(rsadata["providersResponses"].toString());
    print("kimoooo");
    await newRSA.set(rsadata);
    print("lolaaddddd");
    print("Ayooh");
    return newRSA.key;
  }

//Functionalities
  Future requestWSA() async {
    assignState(RSAStates.requestingRSA);
    String? rsaID = await _requestWSA();
    if (rsaID != null) {
      state = state.copyWith(state: RSAStates.created, rsaID: rsaID);
      print("WSA::${rsaID} ==== ${state.rsaID}");
      return true;
    } else {
      assignState(RSAStates.failedToRequestRSA);
      return false;
    }
  }

  Future _requestWSA() async {
    String userID = FirebaseAuth.instance.currentUser!.uid;
    DatabaseReference newWSA = dbRef.child("wsa").push();
    Map<String, dynamic> rsaData = {
      "userID": userID,
      "latitude": state.location!.latitude,
      "longitude": state.location!.longitude,
      "mechanicsResponses": {},
      "providersResponses": {},
      "state": RSA.stateToString(RSAStates.waitingForMechanicResponse)
    };
    await newWSA.set(rsaData);
    return newWSA.key;
  }

//Functionalities
  Future requestRSA() async {
    assignState(RSAStates.requestingRSA);
    String? rsaID = await _requestRSA();
    if (rsaID != null) {
      print("aywaaaaaaaaaaa");
      state = state.copyWith(state: RSAStates.created, rsaID: rsaID);
      print("AyoohID::${rsaID} ==== ${state.rsaID}");
      return true;
    } else {
      print("l2222");
      assignState(RSAStates.failedToRequestRSA);
      return false;
    }
  }

// customRefresh() => state = state.copyWith(); Testing

  searchNearbyMechanicsAndProviders() {
    // _assignState(RSAStates.searchingForNearbyMechanic);
    // double radius =
    //     state.user != null ? state.user!.getSubscriptionRange()! : 100;

    double radius = 400;

    // double radius =
    NearbyLocations.getNearbyMechanicsAndProviders(
        state.location!.latitude, state.location!.longitude, radius, ref);
  }

  searchNearbyProviders() {
    // state = state.copyWith(state: RSAStates.searchingForNearbyProvider);
    double radius =
        state.user != null ? state.user!.getSubscriptionRange()! : 100;
    // NearbyLocations.getNearbyProviders(state.location!.latitude, state.location!.longitude, radius, ref);
  }

  Future requestTta() async {
    String userID = FirebaseAuth.instance.currentUser!.uid;
    DatabaseReference newRSA = dbRef.child("tta").push();
    print("ssssss");
    Map<String, dynamic> ttadata = {
      "userID": userID,
      "latitude": state.location!.latitude,
      "longitude": state.location!.longitude,
      "providersResponses": {},
      "state": RSA.stateToString(RSAStates.waitingForProviderResponse)
    };
    print("b4 for");

    print(ttadata["providersResponses"].toString());
    print("kimoooo");
    await newRSA.set(ttadata);
    print("lolaaddddd");
    state = state.copyWith(rsaID: newRSA.key);
    return newRSA.key;
  }

  assignRequestTypeToRSA() {
    _requestType = _RequestType.RSA;
  }

  assignRequestTypeToWSA() {
    _requestType = _RequestType.WSA;
  }

  assignRequestTypeToTTA() {
    _requestType = _RequestType.TTA;
  }

  getRequestType() => _requestType;
}

enum _RequestType { RSA, WSA, TTA }
