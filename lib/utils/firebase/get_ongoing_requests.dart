import 'package:firebase_database/firebase_database.dart';
import 'package:slahly/classes/firebase/roadsideassistance/roadsideassistance.dart';
import 'package:slahly/classes/models/mechanic.dart';
import 'package:slahly/utils/constants.dart';
import 'package:slahly/utils/firebase/get_mechanic_data.dart';
import 'package:slahly/classes/models/car.dart';

class SingletonOngoing {
  static List<RSA> ongoingRequestsList = [];
  List<Car> cars = [];

  SingletonOngoing(List<Car> cars){
    this.cars = cars;
    getOngoingRequests();
  }

  getOngoingRequests() {
    ongoingRequestsList = [];
    typeOngoingRequests(rsaRef);
    typeOngoingRequests(wsaRef);
  }

  typeOngoingRequests(DatabaseReference local) {
    for (var car in cars) {
      print("Will try car ${car.noChassis}");
      RequestType requestType =
          (local == rsaRef) ? RequestType.RSA : RequestType.WSA;
      local
          .orderByChild("carID")
          .equalTo(car.noChassis)
          .once()
          .then((event) async {
        DataSnapshot rsaDataSnapShot = event.snapshot;
        if (rsaDataSnapShot.value != null) {
          print("found this: ${rsaDataSnapShot.value}");
          for (var element in rsaDataSnapShot.children) {
            String mechanicID = "";
            for (var response in element.child("mechanicsResponses").children) {
              // print("isa 5er ${response.value}");
              if (response.value == "accepted") {
                mechanicID = response.key.toString();
              }
            }
            Mechanic mechanic = await getMechanicData(mechanicID);

            RSA rsa = RSA(
                rsaID: element.key.toString(),
                car: car,
                mechanic: mechanic,
                requestType: requestType);

            // setState(() {
            ongoingRequestsList.add(rsa);
            // });
            // print("list length${ongoingRequestsList.length}");
          }
        }
      });
    }
  }
}
