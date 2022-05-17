import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slahly/classes/firebase/roadsideassistance/roadsideassistance.dart';
import 'package:slahly/classes/models/car.dart';
import 'package:slahly/classes/models/client.dart';
import 'package:slahly/classes/models/location.dart';
import 'package:slahly/classes/models/mechanic.dart';
import 'package:slahly/classes/provider/ongoing_data.dart';
import 'package:slahly/main.dart';
import 'package:slahly/utils/constants.dart';
import 'package:slahly/utils/firebase/get_mechanic_data.dart';

loadRequestFromDB(
    {required String id,
    required String requestType,
    Car? alreadyHaveCar}) async {
  DataSnapshot dataSnapshot = await dbRef.child(requestType).child(id).get();
  RequestType t = RSA.stringToRequestType(requestType.toUpperCase())!;
  if (alreadyHaveCar == null) {
    DataSnapshot carSnapshot = await dbRef
        .child("cars")
        .child(dataSnapshot.child("carID").value.toString())
        .get();
    alreadyHaveCar = Car(
      // color: carSnapshot.child("color").value.toString(),
      noPlate: carSnapshot.child("plate").value.toString(),
      model: carSnapshot.child("model").value.toString(),
    );
  }

  DataSnapshot userSnapshot = await dbRef
      .child("users")
      .child("clients")
      .child(dataSnapshot.child("userID").value.toString())
      .get();

  //custom drop off location
  CustomLocation? dropOffLocation;
  if (RSA.stringToRequestType(requestType.toUpperCase()) == RequestType.TTA) {
    if (dataSnapshot.child("destination").value != null) {
      double lat = double.parse(
          (dataSnapshot.child("destination").child("latitude").value)
              .toString());
      double lon = double.parse(
          (dataSnapshot.child("destination").child("longitude").value)
              .toString());
      dropOffLocation = CustomLocation(latitude: lat, longitude: lon);
    }
  }

//get mechanic if there is
  String? mechanicID;
  Mechanic? mechanic;
  for (var response in dataSnapshot.child("mechanicsResponses").children) {
    if ((response.value == "accepted" &&
            RSA.stringToRequestType(requestType.toUpperCase()) ==
                RequestType.RSA) ||
        (response.value == "chosen" &&
            RSA.stringToRequestType(requestType.toUpperCase()) !=
                RequestType.RSA)) {
      mechanicID = response.key.toString();
    }
  }
  if (mechanicID != null) {
    //there is a mechanic and we have his id
    mechanic = await getMechanicData(mechanicID);
  }

  //get date
  DateTime? createdAt;
  if (dataSnapshot.child("createdAt").value != null) {
    createdAt =
        DateTime.parse(dataSnapshot.child("createdAt").value.toString());
  }
  DateTime? updatedAt;
  if (dataSnapshot.child("updatedAt").value != null) {
    updatedAt =
        DateTime.parse(dataSnapshot.child("updatedAt").value.toString());
  }

  /////////////////////////
  print("RSA added ${dataSnapshot.key.toString()}");
  RSA rsa = RSA(
    user: Client(
      name: userSnapshot.child("name").value.toString(),
      phoneNumber: userSnapshot.child("phoneNumber").value.toString(),
    ),
    car: alreadyHaveCar,
    state: RSA.stringToState(dataSnapshot.child("state").value.toString()),
    rsaID: dataSnapshot.key.toString(),
    requestType: t,
    location: CustomLocation(
      name: "Location",
      latitude: double.parse(dataSnapshot.child("latitude").value.toString()),
      longitude: double.parse(dataSnapshot.child("longitude").value.toString()),
    ),
    dropOffLocation: dropOffLocation,
    mechanic: mechanic,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
  return rsa;
}

getRequestOfType(DatabaseReference local, List<Car> cars, WidgetRef ref) {
  print("SAAAAAAAAAAD${cars}");
  for (var car in cars) {
    local
        .orderByChild("carID")
        .equalTo(car.noChassis)
        .once()
        .then((event) async {
      DataSnapshot rsaDataSnapShot = event.snapshot;

      for (var element in rsaDataSnapShot.children) {
        late String requestType;
        if (local == rsaRef) requestType = "rsa";
        if (local == wsaRef) requestType = "wsa";
        if (local == ttaRef) requestType = "tta";

        print("WE WILL TRY ${element.key.toString()}");
        RSA rsa = loadRequestFromDB(
            id: element.key.toString(),
            requestType: requestType,
            alreadyHaveCar: car);
        ref.watch(HistoryProvider).add(rsa);
      }
    });
  }
}
