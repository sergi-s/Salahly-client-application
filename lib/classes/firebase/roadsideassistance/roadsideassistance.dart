import 'package:firebase_database/firebase_database.dart';
import 'package:slahly/classes/models/client.dart';
import 'package:slahly/classes/models/location.dart';
import 'package:slahly/classes/models/mechanic.dart';
import 'package:slahly/classes/models/towProvider.dart';
import 'package:slahly/main.dart';

//TODO delete this and make the one in the model folder the primary one or the one in the packge
class RSA {
  RSAStates _state = RSAStates.created;
  CustomLocation? _location; // lazm yt2sm le long w lat
  String? _rsaID;

  ///
  String? _problemDescription;
  Client? _user;
  TowProvider? _towProvider;
  Mechanic? _mechanic;
  DateTime? _estimatedTime;

  ///
  List<Mechanic>? _nearbyMechanics; // not included in FB
  List<TowProvider>? _nearbyProviders; // not included in FB

  Map<String, Mechanic>? _newNearbyMechanics = {}; //make sure it exists
  List<Mechanic>? _acceptedNearbyMechanics = []; // not included in FB

  Map<String, TowProvider> _newNearbyProviders = {};
  List<TowProvider> _acceptedNearbyProviders = [];

  CustomLocation? _dropOffLocation;

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
    DateTime? estimatedTime,
    CustomLocation? dropOffLocation,
    List<Mechanic>? acceptedNearbyMechanics,
    Map<String, Mechanic>? newNearbyMechanics,
    List<TowProvider>? acceptedNearbyProviders,
    Map<String, TowProvider>? newNearbyProviders,
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
    _estimatedTime = estimatedTime ?? _estimatedTime;
    _dropOffLocation = dropOffLocation ?? _dropOffLocation;

    _acceptedNearbyMechanics =
        acceptedNearbyMechanics ?? _acceptedNearbyMechanics;
    _newNearbyMechanics = newNearbyMechanics ?? _newNearbyMechanics;

    _acceptedNearbyProviders =
        acceptedNearbyProviders ?? _acceptedNearbyProviders;
    _newNearbyProviders = newNearbyProviders ?? _newNearbyProviders;
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
    DateTime? estimatedTime,
    CustomLocation? dropOffLocation,
    Map<String, Mechanic>? newNearbyMechanics,
    List<Mechanic>? acceptedNearbyMechanics,
    Map<String, TowProvider>? newNearbyProviders,
    List<TowProvider>? acceptedNearbyProviders,
  }) =>
      RSA(
        mechanic: mechanic ?? _mechanic,
        towProvider: provider ?? _towProvider,
        state: state ?? _state,
        problemDescription: problemDescription ?? _problemDescription,
        nearbyMechanics: nearbyMechanics ?? _nearbyMechanics,
        nearbyProviders: nearbyProviders ?? _nearbyProviders,
        location: location ?? _location,
        rsaID: rsaID ?? _rsaID,
        user: user ?? _user,
        estimatedTime: estimatedTime ?? _estimatedTime,
        dropOffLocation: dropOffLocation ?? _dropOffLocation,
        acceptedNearbyMechanics:
            acceptedNearbyMechanics ?? _acceptedNearbyMechanics,
        newNearbyMechanics: newNearbyMechanics ?? _newNearbyMechanics,
        acceptedNearbyProviders:
            acceptedNearbyProviders ?? _acceptedNearbyProviders,
        newNearbyProviders: newNearbyProviders ?? _newNearbyProviders,
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

  String? get rsaID => _rsaID;

  CustomLocation? get dropOffLocation => _dropOffLocation;

  List<Mechanic>? get acceptedNearbyMechanics => _acceptedNearbyMechanics;

  Map<String, Mechanic>? get newNearbyMechanics => _newNearbyMechanics;

  List<TowProvider>? get acceptedNearbyProviders => _acceptedNearbyProviders;

  Map<String, TowProvider>? get newNearbyProviders => _newNearbyProviders;

  static String stateToString(RSAStates state) {
    return (state.toString()).isNotEmpty
        ? (state.toString()).substring(10)
        : "";
    // deletes "RSAStates." at the beginning
  }
}
/*
 RSA_refactored
  RSA_state_management_and_RSA_confirmation_screen_v1
  for_sergi
  main
  my-location-feature
  my-location-incomplete
  nearby_locations
  nearby_locations+create_RSA

 */

enum RSAStates {
  canceled,

  // searchingForNearbyMechanic,// started searching                               App state
  // userChoosingMechanic,// list loaded (at least 1) and user choosing            App state
  // userChoseMechanic,// chose mechanic                                           RSA state
  // searchingForNearbyProvider,// started searching                               App state
  // userChoosingProvider,// list loaded (at least 1) and user choosing            App state
  // userChoseProvider,// chose provider                                           RSA state

  requestingRSA,
  failedToRequestRSA,
  created, // created RSA on DB

  waitingForMechanicResponse, //
  mechanicConfirmed,
  waitingForProviderResponse,
  providerConfirmed,
  waitingForArrival,
  confirmedArrival,
  done
}
