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

// import 'package:slahly/classes/models/road_side_assistance.dart';

DatabaseReference wsaRef = FirebaseDatabase.instance.ref().child("wsa");

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

  // Setters
  void assignNearbyMechanics(List<Mechanic> nearbyMechanics) {
    state = state.copyWith(nearbyMechanics: nearbyMechanics);
    print("loooooooola");
  }

  void newAssignNearbyMechanics(Mechanic nearbyMechanic) async {
    //I dont want to mess up the old code.

    //copy to new map (make sure their is no conflict between call by ref and call by value) and not null
    Map<String, Mechanic> tempMap = {...state.newNearbyMechanics ?? {}};

    if (!tempMap.containsKey(nearbyMechanic.id)) {
      tempMap[nearbyMechanic.id!] = nearbyMechanic;

      DataSnapshot dataSnapshot =
          await wsaRef.child(state.rsaID!).child("mechanicsResponses").get();

      for (var mechanicID in state.newNearbyMechanics!.keys) {
        bool flag = false;

        dataSnapshot.children.forEach((mechanicResponse) {
          if (mechanicID == mechanicResponse.key) {
            flag = true;
          }
        });

        if (!flag) {
          wsaRef
              .child(state.rsaID!)
              .child("mechanicsResponses")
              .update({mechanicID: "pending"});
        }
      }
    }
    state = state.copyWith(newNearbyMechanics: state.newNearbyMechanics);
  }

  void assignAcceptedNearbyMechanics(List<Mechanic> acceptedNearbyMechanics) {
    state = state.copyWith(acceptedNearbyMechanics: acceptedNearbyMechanics);
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
    await newRSA.set(rsadata);
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
      state = state.copyWith(state: RSAStates.created, rsaID: rsaID);
      print("AyoohID::${rsaID} ==== ${state.rsaID}");
      return true;
    } else {
      assignState(RSAStates.failedToRequestRSA);
      return false;
    }
  }

// customRefresh() => state = state.copyWith(); Testing

  searchNearbyMechanicsAndProviders() {
    // _assignState(RSAStates.searchingForNearbyMechanic);
    double radius =
        state.user != null ? state.user!.getSubscriptionRange()! : 100;
    NearbyLocations.getNearbyMechanicsAndProviders(
        state.location!.latitude, state.location!.longitude, radius, ref);
  }

  searchNearbyProviders() {
    // state = state.copyWith(state: RSAStates.searchingForNearbyProvider);
    double radius =
        state.user != null ? state.user!.getSubscriptionRange()! : 100;
    // NearbyLocations.getNearbyProviders(state.location!.latitude, state.location!.longitude, radius, ref);
  }
}
