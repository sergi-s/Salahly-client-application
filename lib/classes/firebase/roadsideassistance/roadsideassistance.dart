import 'package:firebase_database/firebase_database.dart';
import 'package:slahly/classes/models/client.dart';
import 'package:slahly/classes/models/location.dart';
import 'package:slahly/classes/models/mechanic.dart';
import 'package:slahly/classes/models/towProvider.dart';
import 'package:slahly/main.dart';

class RSA {

  RSAStates _state = RSAStates.created;
  CustomLocation? _location; // lazm yt2sm le long w lat
  String? _rsaID;///
  String? _problemDescription;
  Client? _user;
  TowProvider? _towProvider;
  Mechanic? _mechanic;
  DateTime? _estimatedTime;///
  List<Mechanic>? _nearbyMechanics; // not included in FB
  List<TowProvider>? _nearbyProviders; // not included in FB


  RSA({
    Mechanic? mechanic,
    TowProvider? towProvider,
    RSAStates? state,
    String? problemDescription,
    List<Mechanic>? nearbyMechanics,
    List<TowProvider>? nearbyProviders,
    CustomLocation? location,
    String? rsaID,
    Client? user,
    DateTime? estimatedTime
  }) {
    _mechanic = mechanic ?? _mechanic;
    _towProvider = towProvider ?? _towProvider;
    _state = state ?? _state;
    _problemDescription = problemDescription ?? problemDescription;
    _nearbyMechanics = nearbyMechanics ?? _nearbyMechanics;
    _nearbyProviders = nearbyProviders ?? _nearbyProviders;
    _location = location ?? _location;
    _rsaID = rsaID ?? _rsaID;
    _user = user ?? _user;
    _estimatedTime = estimatedTime?? _estimatedTime;
  }

  RSA copyWith({
    Mechanic? mechanic,
    TowProvider? provider,
    RSAStates? state,
    String? problemDescription,
    List<Mechanic>? nearbyMechanics,
    List<TowProvider>? nearbyProviders,
    CustomLocation? location,
    String? rsaID,
    Client? user,
    DateTime? estimatedTime
  }) =>
      RSA(
          mechanic:mechanic ?? _mechanic,
          towProvider : provider ?? _towProvider,
          state : state ?? _state,
          problemDescription : problemDescription ?? _problemDescription,
          nearbyMechanics : nearbyMechanics ?? _nearbyMechanics,
          nearbyProviders : nearbyProviders ?? _nearbyProviders,
          location : location ?? _location,
          rsaID : rsaID ?? _rsaID,
          user : user ?? _user,
          estimatedTime : estimatedTime?? _estimatedTime
      );


  //Getters
  CustomLocation? get location => _location;

  String? get problemDescription => _problemDescription;

  Client? get user => _user;

  TowProvider? get towProvider => _towProvider;

  Mechanic? get mechanic => _mechanic;

  DateTime? get estimatedTime => _estimatedTime;

  List<Mechanic>? get nearbyMechanics => _nearbyMechanics;

  List<TowProvider>? get nearbyProviders => _nearbyProviders;

  RSAStates get state => _state;



  Future requestRSA() async {
    //testing purpose
    _user = Client(

        email: 'momo',
        name: "sd",
        id: "3",
        subscription: SubscriptionTypes.silver);

    ///TODO MAKE THIS FROM USER DATA

    DatabaseReference newRSA = dbRef.child("rsa").push();

    await newRSA.set({
      "userID": _user!.id,
      "latitude": _location!.latitude,
      "longitude": _location!.longitude,
      "towProviderID": _towProvider!.id,
      "mechanic": _mechanic!.id,
      "state": RSAStates.waitingForMechanicResponse.toString()
    });
    return newRSA.key;

  }
}

enum RSAStates {
  canceled,

  searchingForNearbyMechanic,// started searching
  userChoosingMechanic,// list loaded (at least 1) and user choosing
  userChoseMechanic,// chose mechanic
  searchingForNearbyProvider,// started searching
  userChoosingProvider,// list loaded (at least 1) and user choosing
  userChoseProvider,// chose provider

  requestingRSA,
  failedToRequestRSA,
  created,// created RSA

  waitingForMechanicResponse,//
  mechanicConfirmed,
  waitingForProviderResponse,
  providerConfirmed,

  waitingForArrival,
  confirmedArrival,
  done
}
