import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slahly/classes/firebase/roadsideassistance/roadsideassistance.dart';
import 'package:slahly/classes/models/location.dart';
import 'package:slahly/classes/models/mechanic.dart';
import 'package:slahly/classes/models/towProvider.dart';

final rsaProvider = StateNotifierProvider<RSAData, RSA>((ref) {
  return RSAData();
});

class RSAData extends StateNotifier<RSA> {

  RSAData() : super(RSA());
///TODO update state in each function
  //setters
  void assignMechanic(Mechanic mechanic, bool stopListener) {
    state = state.copyWith(mechanic: mechanic);
  // state.setMechanic(mechanic, stopListener);
  // state =
  // state = RSA(
  //   Mechanic(name: "Moudzzzz",email: "momomo",isCenter: true,
  //       rating: 2),
  // TowProvider(
  //     name: "name",
  //     email: "email",
  //     isCenter: true,
  //     avatar: "https://www.woolha.com/media/2020/03/eevee.png"),"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a ",);
  // state = state;
}

  void assignProvider(TowProvider provider, bool stopListener) =>
      state = state.copyWith(provider: provider);
      // state.setProvider(provider, stopListener);

  void assignUserLocation(CustomLocation location) => state = state.copyWith(location: location);
  void assignProblemDescription(String description) => state = state.copyWith(problemDescription: description);
  void assignUser(String description) => state = state.copyWith(problemDescription: description);

  //Getters
  Mechanic getMechanic()=>state.getMechanic();
  TowProvider getProvider()=>state.getProvider();
  String getProblemDescription()=>state.getProblemDescription();

  //Functionalities
  Future requestRSA() async {
    state.state = RSA_state.requesting_rsa;
    bool created = await state.requestRSA();
    if(created) {
      state.state = RSA_state.waiting_for_mech_response;
    } else {
      state.state = RSA_state.failed_to_request_rsa;
    }
    return created;
  }
  void getNearbyMechanics(){
    state.state = RSA_state.searching_for_nearby_mech;
    state.requestNearbyMechanics();
  }

  void getNearbyProviders(){
    state.state = RSA_state.searching_for_nearby_prov;
    state.requestNearbyProviders();
  }
}
