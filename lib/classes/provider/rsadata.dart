import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slahly/classes/firebase/nearbylocations.dart';
import 'package:slahly/classes/firebase/roadsideassistance/roadsideassistance.dart';
import 'package:slahly/classes/models/client.dart';
import 'package:slahly/classes/models/location.dart';
import 'package:slahly/classes/models/mechanic.dart';
import 'package:slahly/classes/models/towProvider.dart';

// Global for anyone to use it
final rsaProvider = StateNotifierProvider<RSANotifier, RSA>((ref) {
  return RSANotifier(ref);
});

class RSANotifier extends StateNotifier<RSA> {

  RSANotifier(this.ref) : super(RSA(
      location: CustomLocation(latitude: 31.206972, longitude: 29.919028)));
  final Ref ref;

  // Setters
  void assignNearbyMechanics(List<Mechanic> nearbyMechanics) =>
    state = state.copyWith(nearbyMechanics: nearbyMechanics,state: RSAStates.userChoosingMechanic);

  void assignMechanic(Mechanic mechanic, bool stopListener) {
    state = state.copyWith(mechanic: mechanic,state: RSAStates.userChoseMechanic);
    if(stopListener) {
      NearbyLocations.stopListener();
    }
  }

  void assignNearbyProviders(List<TowProvider> nearbyProviders) =>
      state = state.copyWith(nearbyProviders: nearbyProviders, state: RSAStates.userChoosingProvider);

  void assignProvider(TowProvider provider, bool stopListener) {
      state = state.copyWith(provider: provider,state: RSAStates.userChoseProvider);
      if(stopListener) {
        NearbyLocations.stopListener();
      }
  }

  assignUserLocation(CustomLocation location) => state = state.copyWith(location: location);
  assignProblemDescription(String description) => state = state.copyWith(problemDescription: description);
  assignUser(Client user) => state = state.copyWith(user: user);
  assignEstimatedTime(DateTime estimatedTime)=> state = state.copyWith(estimatedTime: estimatedTime);
  _assignState(RSAStates newState) => state = state.copyWith(state : newState);


  //Functionalities
  Future requestRSA() async {
    _assignState(RSAStates.requestingRSA);
    String? rsaID = await state.requestRSA();
    if(rsaID != null) {
      state = state.copyWith(state: RSAStates.created,rsaID: rsaID);
      return true;
    } else {
      _assignState(RSAStates.failedToRequestRSA);
      return false;
    }
  }

  // customRefresh() => state = state.copyWith(); Testing

  searchNearbyMechanics(){
    _assignState(RSAStates.searchingForNearbyMechanic);
    double radius = state.user != null?state.user!.getSubscriptionRange()!:100;
    NearbyLocations.getNearbyMechanics(state.location!.latitude, state.location!.longitude,radius,ref);
  }

  searchNearbyProviders(){
    state = state.copyWith(state: RSAStates.searchingForNearbyProvider);
    double radius = state.user != null?state.user!.getSubscriptionRange()!:100;
    NearbyLocations.getNearbyMechanics(state.location!.latitude, state.location!.longitude,radius,ref);
  }
}
