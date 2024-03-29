import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slahly/classes/firebase/nearbylocations.dart';
import 'package:slahly/classes/firebase/roadsideassistance/roadsideassistance.dart';
import 'package:slahly/classes/models/car.dart';
import 'package:slahly/classes/models/client.dart';
import 'package:slahly/classes/models/location.dart';
import 'package:slahly/classes/models/mechanic.dart';
import 'package:slahly/classes/models/towProvider.dart';
import 'package:slahly/main.dart';
import 'package:slahly/utils/constants.dart';
import 'package:slahly/utils/firebase/get_mechanic_data.dart';
import 'package:slahly/utils/firebase/get_provider_data.dart';

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

  // RequestType? state.requestType;

  bool atLeastOneProvider = false;
  bool atLeastOneMechanic = false;

  bool needTowProvider = false;

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
    if (nearbyMechanic.id == null) return;
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
      DatabaseReference localRef = state.requestType == RequestType.WSA
          ? wsaRef
          : (state.requestType == RequestType.RSA)
          ? rsaRef
          : ttaRef;

      if (state.requestType != RequestType.TTA) {
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
    if (newNearbyProvider.id == null) return;
    atLeastOneProvider = true;
    Map<String, TowProvider> tempMap = {...state.newNearbyProviders ?? {}};
    if (!tempMap.containsKey(newNearbyProvider.id)) {
      tempMap[newNearbyProvider.id!] = newNearbyProvider;
      DatabaseReference localRef = state.requestType == RequestType.WSA
          ? wsaRef
          : (state.requestType == RequestType.RSA)
          ? rsaRef
          : ttaRef;
      if (!needTowProvider) return;
      localRef
          .child(state.rsaID!)
          .child("providersResponses")
          .child(newNearbyProvider.id!)
          .set("pending");
    }
    state = state.copyWith(newNearbyProviders: tempMap);
  }

  void addAcceptedNearbyMechanic(String newMechanicID) async {
    // print("Will try to add ${newMechanic.name}");
    Mechanic newMechanic;

    if (!state.newNearbyMechanics!.containsKey(newMechanicID)) {
      newMechanic = await getMechanicData(newMechanicID) as Mechanic;
      state.newNearbyMechanics![newMechanicID] = newMechanic;
      state = state.copyWith(newNearbyMechanics: state.newNearbyMechanics);
    } else {
      newMechanic = state.newNearbyMechanics![newMechanicID]!;
    }

    bool flag = true;
    if (state.acceptedNearbyMechanics!.isNotEmpty) {
      for (var mechanic in state.acceptedNearbyMechanics!) {
        if (mechanic.id == newMechanic.id) {
          // print("${mechanic.name} already exists");
          flag = false;
        }
      }
    }
    if (flag) {
      // print("Will add ${newMechanic.name}");
      state = state.copyWith(acceptedNearbyMechanics: [
        ...?state.acceptedNearbyMechanics,
        newMechanic
      ]);

      // print("added ${newMechanic.name}");
    }
    // print("THE ACCEPTED LIST IS mechs${state.acceptedNearbyMechanics}");
  }

  getEstimatedTime(String towProviderId) async {
    print("hello estimated time");
    TowProvider towProvider;
    if (state.newNearbyProviders!.containsKey(towProviderId)) {
      towProvider = state.newNearbyProviders![towProviderId]!;

      DataSnapshot tp = await dbRef
          .child("providersRequests")
          .child(towProviderId)
          .child(state.rsaID!)
          .get();
      if (tp.value != null) {
        state.newNearbyProviders![towProvider.id]?.estimatedTime =
            tp.child("estimatedTime").value.toString();

        state = state.copyWith(acceptedNearbyProviders: [
          ...?state.acceptedNearbyProviders,
        ]);
        print(tp.value);
      }
    }
  }

  void addAcceptedNearbyProvider(String newTowProviderID) async {
    TowProvider newTowProvider;

    if (!state.newNearbyProviders!.containsKey(newTowProviderID)) {
      newTowProvider =
          await getProviderData(newTowProviderID, rsaID: state.rsaID)
              as TowProvider;
      state.newNearbyProviders![newTowProviderID] = newTowProvider;
      state = state.copyWith(newNearbyProviders: state.newNearbyProviders);
    } else {
      newTowProvider = state.newNearbyProviders![newTowProviderID]!;
    }
    print("hello estimated time2222");
    getEstimatedTime(newTowProviderID);

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

    final prefs = await SharedPreferences.getInstance();
    prefs.setString("mechanic", mechanic.id!);

    print(state.requestType.toString());
    if (state.requestType == RequestType.TTA ||
        state.requestType == RequestType.RSA) return;

    DatabaseReference localRef = wsaRef;
    print("Assigned Mechanic${mechanic.id!}");

    await localRef
        .child(state.rsaID!)
        .child("mechanicsResponses")
        .update({mechanic.id!: "chosen"});
    if (state.requestType == RequestType.WSA && needTowProvider) {
      await localRef.child(state.rsaID!).update(
          {"state": RSA.stateToString(RSAStates.waitingForProviderResponse)});
    } else {
      await localRef
          .child(state.rsaID!)
          .update({"state": RSA.stateToString(RSAStates.mechanicConfirmed)});
    }

    await localRef
        .child(state.rsaID!)
        .update({"updatedAt": DateTime.now().toString()});
    print("After await");

    if (state.requestType != RequestType.RSA) {
      DatabaseReference tempDB =
          FirebaseDatabase.instance.ref().child("mechanicsRequests");
      tempDB
          .child(mechanic.id!)
          .child(state.rsaID!)
          .update({'state': 'chosen'});
    }
  }

  void assignNearbyProviders(List<TowProvider> nearbyProviders) =>
      state = state.copyWith(nearbyProviders: nearbyProviders);

  void assignProvider(TowProvider provider, bool stopListener) async {
    if (stopListener) {
      NearbyLocations.stopListener();
    }
    print(">>> assign 5ara provider");
    // print(_requestType.toString());
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("towProvider", provider.id!);
    // print((_requestType == _RequestType.WSA)
    //     ? "wsaRef"
    //     : _requestType == _RequestType.RSA
    //         ? "rsaRef"
    //         : "ttaRef");

    //temp here;
    getEstimatedTime(provider.id!);
    state = state.copyWith(provider: provider);
    if (state.requestType == RequestType.RSA) return;
    DatabaseReference localRef =
        state.requestType == RequestType.WSA ? wsaRef : ttaRef;

    await localRef
        .child(state.rsaID!)
        .child("providersResponses")
        .update({provider.id!: "chosen"});

    await localRef.child(state.rsaID!).update({
      "updatedAt": DateTime.now().toString(),
      "state": RSA.stateToString(RSAStates.waitingForArrival)
    });

    if (state.requestType != RequestType.RSA) {
      DatabaseReference tempDB =
          FirebaseDatabase.instance.ref().child("providersRequests");
      tempDB
          .child(provider.id!)
          .child(state.rsaID!)
          .update({'state': 'chosen'});
    }
  }

  assignRequestType(RequestType requestType) =>
      state = state.copyWith(requestType: requestType);

  assignRequestID(String requestID) => state = state.copyWith(rsaID: requestID);

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

  assignCar(Car car) => state = state.copyWith(car: car);

  assignSemiReport(String semiReport) =>
      state = state.copyWith(semiReport: semiReport);

  Future _requestRSA() async {
    needTowProvider = true;
    String userID = FirebaseAuth.instance.currentUser!.uid;

    DatabaseReference newRSA = dbRef.child("rsa").push();
    Map<String, dynamic> rsaData = {
      "userID": userID,
      "carID": state.car!.noChassis,
      "latitude": state.location!.latitude,
      "longitude": state.location!.longitude,
      "mechanicsResponses": {},
      "providersResponses": {},
      "createdAt": DateTime.now().toString(),
      "updatedAt": DateTime.now().toString(),
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
      "carID": state.car!.noChassis,
      "latitude": state.location!.latitude,
      "longitude": state.location!.longitude,
      "createdAt": DateTime.now().toString(),
      "updatedAt": DateTime.now().toString(),
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
    double radius =
        state.user != null ? state.user!.getSubscriptionRange()! : 100;
    // double radius = 400;
    NearbyLocations.getNearbyMechanicsAndProviders(
        state.location!.latitude, state.location!.longitude, radius, ref);
  }
  searchNearbyMechanicsAndProvidersSergi(RSANotifier rsaNotifier) {
    double radius =
    state.user != null ? state.user!.getSubscriptionRange()! : 100;
    NearbyLocations.getNearbyMechanicsAndProvidersFoula(
        state.location!.latitude, state.location!.longitude, radius, rsaNotifier);
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
    needTowProvider = true;
    // print("ssssss");
    Map<String, dynamic> ttaData = {
      "userID": userID,
      "carID": state.car!.noChassis,
      "latitude": state.location!.latitude,
      "longitude": state.location!.longitude,
      "providersResponses": {},
      "createdAt": DateTime.now().toString(),
      "updatedAt": DateTime.now().toString(),
      "destination": {
        "latitude": state.dropOffLocation!.latitude,
        "longitude": state.dropOffLocation!.longitude,
      },
      "state": RSA.stateToString(RSAStates.waitingForProviderResponse)
    };
    // print("b4 for");
    // print(newRSA.key);
    await newRSA.set(ttaData);
    state = state.copyWith(rsaID: newRSA.key);
    // print(state.rsaID);
    return newRSA.key;
  }

  void cancelRequest() async {
    assignState(RSAStates.cancelled);
    DatabaseReference localRef = state.requestType == RequestType.WSA
        ? wsaRef
        : state.requestType == RequestType.RSA
            ? rsaRef
            : ttaRef;
    await localRef.child(state.rsaID!).update({
      "state": RSA.stateToString(RSAStates.cancelled),
      "updatedAt": DateTime.now().toString()
    });

    state = RSA();
  }

  void finishRequest() async {
    assignState(RSAStates.done);
    DatabaseReference localRef = state.requestType == RequestType.WSA
        ? wsaRef
        : state.requestType == RequestType.RSA
            ? rsaRef
            : ttaRef;
    await localRef.child(state.rsaID!).update({
      "state": RSA.stateToString(RSAStates.done),
      "updatedAt": DateTime.now().toString()
    });
    state = RSA();
  }

  void confirmTowArrival() async {
    assignState(RSAStates.confirmedArrival);
    DatabaseReference localRef = state.requestType == RequestType.WSA
        ? wsaRef
        : state.requestType == RequestType.RSA
            ? rsaRef
            : ttaRef;
    await localRef.child(state.rsaID!).update({
      "state": RSA.stateToString(RSAStates.confirmedArrival),
      "updatedAt": DateTime.now().toString()
    });
  }

  assignRequestTypeToRSA() => assignRequestType(RequestType.RSA);

  assignRequestTypeToWSA() => assignRequestType(RequestType.WSA);

  assignRequestTypeToTTA() => assignRequestType(RequestType.TTA);
}
