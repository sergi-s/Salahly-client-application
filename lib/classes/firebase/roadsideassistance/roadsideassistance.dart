import 'package:slahly/classes/models/location.dart';
import 'package:slahly/classes/models/mechanic.dart';
import 'package:slahly/classes/models/towProvider.dart';

class RSA {
  RSA_state state = RSA_state.created;
  late CustomLocation location;
  late String RSA_id;
  late String userID;
  late TowProvider towProvider;
  late Mechanic mechanic;
  late DateTime estimatedTime;
  late List<Mechanic> nearbyMechanics;
  late List<TowProvider> nearbyProviders;

  bool requestNearbyMechanics(){
    //uses location get nearby mechs
    nearbyMechanics = [];
    return false;
  }

  bool requestNearbyProviders(){
    //uses location get nearby mechs
    nearbyProviders = [];
    return false;
  }

  bool chooseMechanic(Mechanic mech) {
    //momken nbdlha b firebase ID aw ayan kan
    mechanic = mech;

    return false;
  }

  bool chooseProvider(TowProvider provider) {
    //momken nbdlha b firebase ID aw ayan kan
    towProvider = provider;

    return false;
  }

  Future<bool> createRSA(loc,uId) async {
    _RSA(location: loc, userID: uId);
    return (RSA_id != null);
  }
  // the constructor private so you should use the createRSA function
  _RSA({required location,required userID}) async {
   // create RSA in firebase
    String rsaId = "";
    if(rsaId != null){

      RSA_id = rsaId;
    }else{
      throw Exception("Could not create RSA");
    }

   // return RSA_id
  }
}

enum RSA_state {
  canceled,
  created,
  user_choosing_mech,
  user_choosing_prov,
  waiting_for_arrival,
  confirmed_arrival,
  done,
  searching_for_nearby_mech,
  searching_for_nearby_prov,
  waiting_for_mech_response,
  waiting_for_prov_response
}
