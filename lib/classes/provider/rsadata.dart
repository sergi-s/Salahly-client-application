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
  RequestType? _requestTypeLocal;

  bool atLeastOneProvider = false;
  bool atLeastOneMechanic = false;

  Future<bool> atLeastOne(
      {required bool needMechanic, required bool needProvider}) async {
    //true mechanic
    //false provider

    await Future.delayed(const Duration(seconds: 10));
    return ((needMechanic ? atLeastOneMechanic : true) &&
        (needProvider ? atLeastOneProvider : true));
  }

  // Setters
  void assignNearbyMechanics(List<Mechanic> nearbyMechanics) =>
      state = state.copyWith(nearbyMechanics: nearbyMechanics);

  void assignAcceptedNearbyMechanics(List<Mechanic> acceptedNearbyMechanics) =>
      state = state.copyWith(acceptedNearbyMechanics: acceptedNearbyMechanics);

  void assignAcceptedNearbyProviders(
          List<TowProvider> acceptedNearbyProviders) =>
      state = state.copyWith(acceptedNearbyProviders: acceptedNearbyProviders);

  void onFindNewMechanic(Mechanic nearbyMechanic) async {
    atLeastOneMechanic = true;
    // print("onFIndNew mechanic::");
    //copy to new map (make sure their is no conflict between call by ref and call by value) and not null
    Map<String, Mechanic> tempMap = {...state.newNearbyMechanics ?? {}};

    // print("MAP1:${state.newNearbyMechanics!.keys}");
    if (!tempMap.containsKey(nearbyMechanic.id)) {
      // print("Temp1:${tempMap}");
      tempMap[nearbyMechanic.id!] = nearbyMechanic;

      // print("Temp2:${tempMap}");
      // print(":::add ${nearbyMechanic.name} to request table");
      DatabaseReference localRef = _requestTypeLocal == RequestType.WSA
          ? wsaRef
          : (_requestTypeLocal == RequestType.RSA)
              ? rsaRef
              : ttaRef;

      if (_requestTypeLocal != RequestType.TTA) {
        localRef
            .child(state.rsaID!)
            .child("mechanicsResponses")
            .child(nearbyMechanic.id!)
            .set("pending");
      }
    }
    state = state.copyWith(newNearbyMechanics: tempMap);
    // print("MAP2:${state.newNearbyMechanics!}");
  }

  void onFindNewProvider(TowProvider newNearbyProvider) async {
    atLeastOneProvider = true;

    //copy to new map (make sure their is no conflict between call by ref and call by value) and not null
    Map<String, TowProvider> tempMap = {...state.newNearbyProviders ?? {}};

    // print("PROV::MAP1:${state.newNearbyProviders!.keys}");
    if (!tempMap.containsKey(newNearbyProvider.id)) {
      // print("PROV::Temp1:${tempMap}");
      tempMap[newNearbyProvider.id!] = newNearbyProvider;
      // print("PROV::Temp2:${tempMap}");
      // print("PROV:::::add ${newNearbyProvider.name} to request table");
      DatabaseReference localRef = _requestTypeLocal == RequestType.WSA
          ? wsaRef
          : (_requestTypeLocal == RequestType.RSA)
              ? rsaRef
              : ttaRef;

      // if (_requestType != _RequestType.TTA) {
      localRef
          .child(state.rsaID!)
          .child("providersResponses")
          .child(newNearbyProvider.id!)
          .set("pending");
      // }
    }
    // print("MAP2:${state.newNearbyMechanics!.keys}");
    state = state.copyWith(newNearbyProviders: tempMap);
    // print("PROV::MAP2:${state.newNearbyProviders}");
  }

  void addAcceptedNearbyMechanic(Mechanic newMechanic) {
    // print("Will try to add ${newMechanic.name}");
    bool flage = true;
    if (state.acceptedNearbyMechanics!.isNotEmpty) {
      for (var mechanic in state.acceptedNearbyMechanics!) {
        if (mechanic.id == newMechanic.id) {
          // print("${mechanic.name} already exists");
          flage = false;
        }
      }
    }
    if (flage) {
      // print("Will add ${newMechanic.name}");
      state = state.copyWith(acceptedNearbyMechanics: [
        ...?state.acceptedNearbyMechanics,
        newMechanic
      ]);

      // print("added ${newMechanic.name}");
    }
    // print("THE ACCEPTED LIST IS mechs${state.acceptedNearbyMechanics}");
  }

  void addAcceptedNearbyProvider(TowProvider newTowProvider) {
    // print("Will try to add ${newTowProvider.name}");
    bool flag = true;
    if (state.acceptedNearbyProviders!.isNotEmpty) {
      for (var towProvider in state.acceptedNearbyProviders!) {
        if (towProvider.id == newTowProvider.id) {
          // print("${towProvider.name} already exists");
          flag = false;
        }
      }
    }
    if (flag) {
      // print("Will add ${newTowProvider.name}");
      state = state.copyWith(acceptedNearbyProviders: [
        ...?state.acceptedNearbyProviders,
        newTowProvider
      ]);

      // print("added ${newTowProvider.name}");
    }
    // print("THE ACCEPTED LIST IS tow provs ${state.acceptedNearbyProviders}");
  }

  void assignMechanic(Mechanic mechanic, bool stopListener) async {
    state = state.copyWith(mechanic: mechanic);
    if (stopListener) {
      NearbyLocations.stopListener();
    }
    print(">>> assign 5ara mechanic");
    print(_requestTypeLocal.toString());
    if (_requestTypeLocal == RequestType.TTA ||
        _requestTypeLocal == RequestType.RSA) return;

    DatabaseReference localRef = wsaRef;
    print("Assigned Mechanic${mechanic.id!}");

    await localRef
        .child(state.rsaID!)
        .child("mechanicsResponses")
        .update({mechanic.id!: "chosen"});

    print("After await");
  }

  void cancelRequest() async {
    assignState(RSAStates.canceled);
    DatabaseReference localRef = _requestTypeLocal == RequestType.WSA
        ? wsaRef
        : _requestTypeLocal == RequestType.RSA
            ? rsaRef
            : ttaRef;
    await localRef
        .child(state.rsaID!)
        .update({"state": RSA.stateToString(RSAStates.canceled)});
    state = RSA();
  }

  void assignNearbyProviders(List<TowProvider> nearbyProviders) =>
      state = state.copyWith(nearbyProviders: nearbyProviders);

  void assignProvider(TowProvider provider, bool stopListener) async {
    state = state.copyWith(provider: provider);
    if (stopListener) {
      NearbyLocations.stopListener();
    }
    // print(">>> assign 5ara provider");
    // print(_requestType.toString());
    if (_requestTypeLocal == RequestType.RSA) return;
    DatabaseReference localRef = _requestTypeLocal == RequestType.WSA
        ? wsaRef
        : _requestTypeLocal == RequestType.RSA
            ? rsaRef
            : ttaRef;
    // print((_requestType == _RequestType.WSA)
    //     ? "wsaRef"
    //     : _requestType == _RequestType.RSA
    //         ? "rsaRef"
    //         : "ttaRef");

    await localRef
        .child(state.rsaID!)
        .child("providersResponses")
        .update({provider.id!: "chosen"});
  }

  assignUserLocation(CustomLocation location) =>
      state = state.copyWith(location: location);

  assignDropOffLocation(CustomLocation location) =>
      state = state.copyWith(dropOffLocation: location);

  assignProblemDescription(String description) =>
      state = state.copyWith(problemDescription: description);

  assignUser(Client user) => state = state.copyWith(user: user);

  assignEstimatedTime(DateTime estimatedTime) =>
      state = state.copyWith(estimatedTime: estimatedTime);

  assignState(RSAStates newState) => state = state.copyWith(state: newState);

  Future _requestRSA() async {
    String userID = FirebaseAuth.instance.currentUser!.uid;

    DatabaseReference newRSA = dbRef.child("rsa").push();
    Map<String, dynamic> rsaData = {
      "userID": userID,
      "latitude": state.location!.latitude,
      "longitude": state.location!.longitude,
      "mechanicsResponses": {},
      "providersResponses": {},
      "state": RSA.stateToString(RSAStates.waitingForMechanicResponse)
    };
    await newRSA.set(rsaData);
    return newRSA.key;
  }

//Functionalities
  Future requestWSA() async {
    assignState(RSAStates.requestingRSA);
    String? rsaID = await _requestWSA();
    if (rsaID != null) {
      state = state.copyWith(
          state: RSAStates.created, rsaID: rsaID, requestType: RequestType.WSA);
      // print("WSA::${rsaID} ==== ${state.rsaID}");
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
      // print("aywaaaaaaaaaaa");
      state = state.copyWith(
          state: RSAStates.created, rsaID: rsaID, requestType: RequestType.RSA);
      // print("AyoohID::${rsaID} ==== ${state.rsaID}");
      return true;
    } else {
      // print("l2222");
      assignState(RSAStates.failedToRequestRSA);
      return false;
    }
  }

  searchNearbyMechanicsAndProviders() {
    // _assignState(RSAStates.searchingForNearbyMechanic);
    // double radius =
    //     state.user != null ? state.user!.getSubscriptionRange()! : 100;
    double radius = 400;
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
    // print("ssssss");
    Map<String, dynamic> ttaData = {
      "userID": userID,
      "latitude": state.location!.latitude,
      "longitude": state.location!.longitude,
      "providersResponses": {},
      "state": RSA.stateToString(RSAStates.waitingForProviderResponse)
    };
    // print("b4 for");
    // print(newRSA.key);
    await newRSA.set(ttaData);
    state = state.copyWith(rsaID: newRSA.key);
    // print(state.rsaID);
    return newRSA.key;
  }

  assignRequestTypeToRSA() {
    _requestTypeLocal = RequestType.RSA;
  }

  assignRequestTypeToWSA() {
    _requestTypeLocal = RequestType.WSA;
  }

  assignRequestTypeToTTA() {
    _requestTypeLocal = RequestType.TTA;
  }

  getRequestType() => _requestTypeLocal;
}
