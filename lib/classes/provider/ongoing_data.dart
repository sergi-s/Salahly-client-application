// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:slahly/classes/firebase/roadsideassistance/roadsideassistance.dart';
// import 'package:slahly/utils/constants.dart';
//
// import '../../utils/firebase/get_mechanic_data.dart';
// import '../models/car.dart';
// import '../models/mechanic.dart';
//
// final HistoryProvider = StateNotifierProvider<HistoryNotifier, History>((ref) {
//   return HistoryNotifier();
// });
//
// class HistoryNotifier extends StateNotifier<History> {
//   HistoryNotifier() : super(History());
//
//   void assignRequests(List<Car> cars) {
//     // state = state.copyWith(rsa: []);
//     print("in ass 1${state.requests}");
//     getRequestOfType(rsaRef, cars);
//     print("in cars $cars");
//     print("in ass 2${state.requests}");
//     getRequestOfType(wsaRef, cars);
//     print("in ass 3${state.requests}");
//   }
//
//   getRequestOfType(DatabaseReference local, List<Car> cars) {
//     // List<RSA> ongoingRequestsList = [];
//     for (var car in cars) {
//       print("Will try car inside ass ${car.noChassis}");
//       local
//           .orderByChild("carID")
//           .equalTo(car.noChassis)
//           .once()
//           .then((event) async {
//         DataSnapshot rsaDataSnapShot = event.snapshot;
//
//         for (var element in rsaDataSnapShot.children) {
//           String mechanicID = "";
//
//           for (var response in element.child("mechanicsResponses").children) {
//             if (response.value == "accepted") {
//               mechanicID = response.key.toString();
//             }
//           }
//           Mechanic mechanic = await getMechanicData(mechanicID);
//
//           late RequestType requestType;
//           if (local == rsaRef) requestType = RequestType.RSA;
//           if (local == wsaRef) requestType = RequestType.WSA;
//           if (local == ttaRef) requestType = RequestType.TTA;
//
//           print("isa 5er ${requestType}");
//           RSA rsa = RSA(
//               rsaID: element.key.toString(),
//               car: car,
//               mechanic: mechanic,
//               requestType: requestType,
//               state: RSA.stringToState(element.child("state").toString()));
//
//           state = state.copyWith(rsa: [...state.requests, rsa]);
//         }
//       });
//     }
//   }
//
//   addRequest(RSA newRSA) {
//     state = state.copyWith(rsa: [...state.requests, newRSA]);
//   }
// }
//
// class History {
//   List<RSA> _requests = [];
//
//   History({List<RSA>? rsa}) {
//     _requests = rsa ?? _requests;
//   }
//
//   List<RSA> get requests => _requests;
//
//   History copyWith({List<RSA>? rsa}) => History(rsa: rsa ?? _requests);
// }

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slahly/classes/firebase/roadsideassistance/roadsideassistance.dart';
import 'package:slahly/utils/constants.dart';

import '../../utils/firebase/get_mechanic_data.dart';
import '../models/car.dart';
import '../models/mechanic.dart';

final HistoryProvider =
    StateNotifierProvider<HistoryNotifier, List<RSA>>((ref) {
  return HistoryNotifier();
});

class HistoryNotifier extends StateNotifier<List<RSA>> {
  HistoryNotifier() : super(const []);

  void assignRequests(List<Car> cars) {
    state = [];
    // print("in ass 1${state.requests}");
    getRequestOfType(rsaRef, cars);
    print("in assignRequests $cars");
    // print("in ass 2${state.requests}");
    getRequestOfType(wsaRef, cars);
    // print("in ass 3${state.requests}");
  }

  getRequestOfType(DatabaseReference local, List<Car> cars) {
    // List<RSA> ongoingRequestsList = [];
    for (var car in cars) {
      print("Will try car inside ass ${car.noChassis}");
      local
          .orderByChild("carID")
          .equalTo(car.noChassis)
          .once()
          .then((event) async {
        DataSnapshot rsaDataSnapShot = event.snapshot;
        print("SHIT ${rsaDataSnapShot}");

        for (var element in rsaDataSnapShot.children) {
          late RequestType requestType;
          if (local == rsaRef) requestType = RequestType.RSA;
          if (local == wsaRef) requestType = RequestType.WSA;
          if (local == ttaRef) requestType = RequestType.TTA;

          print(element.key.toString());
          print(requestType.toString());
          print(element.child("createdAt").value.toString());

          String mechanicID = "";

          for (var response in element.child("mechanicsResponses").children) {
            if ((response.value == "accepted" &&
                    requestType == RequestType.RSA) ||
                (response.value == "chosen" &&
                    requestType != RequestType.RSA)) {
              mechanicID = response.key.toString();
            }
          }
          Mechanic mechanic = await getMechanicData(mechanicID);

          RSA rsa = RSA(
            rsaID: element.key.toString(),
            car: car,
            mechanic: mechanic,
            requestType: requestType,
            state: RSA.stringToState(element.child("state").value.toString()),
            // createdAt:
            //     DateTime.parse(element.child("createdAt").value.toString()),
            // updatedAt:
            //     DateTime.parse(element.child("updatedAt").value.toString()),
          );

          // print("${rsa.rsaID} isa 5er ${rsa.requestType} and el mafrod ${element.child("state").value.toString()} ${rsa.state} he should sees it as"
          //     " ${RSA.stateToString(RSAStates.done)}");
          addRequest(rsa);
        }
      });
    }
  }

  addRequest(RSA newRSA) {
    bool flag = false;
    for (var rsa in state) {
      if (rsa.rsaID == newRSA.rsaID) {
        flag = true;
      }
    }
    if (!flag) {
      state = [...state, newRSA];
    }
  }
}
