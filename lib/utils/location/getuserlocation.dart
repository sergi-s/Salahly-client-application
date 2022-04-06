import 'package:geolocator/geolocator.dart';
import 'package:slahly/classes/models/location.dart';
import 'dart:math' show cos, sqrt, asin;

import '../http_request.dart';

Future _checkLocationPermission() async {
  bool serviceEnabled;
  LocationPermission permission;
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    print("Location services are disabled.");
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      print('Location permissions are denied');
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    print(
        'Location permissions are permanently denied, we cannot request permissions.');
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }
  return true;
}

Future<CustomLocation> getUserLocation() async {
  _checkLocationPermission().onError((error, stackTrace) {
    print(error);
    return null;
  });
  Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  return CustomLocation(longitude: pos.longitude, latitude: pos.latitude);
}

double calculateDistance(lat1, lon1, lat2, lon2) {
  var p = 0.017453292519943295;
  var c = cos;
  var a = 0.5 -
      c((lat2 - lat1) * p) / 2 +
      c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
  return 12742 * asin(sqrt(a));
}

Future<List> getApproximateLocation() async {
  List retValu = [];
  var response = await httpRequest("http://ip-api.com/json/");
  if (response != "failed") {
    retValu.add(response["lat"] as double);

    retValu.add(response["lon"] as double);
  }
  return retValu;
}

/*
  String placeAddress = "";
  String geoURL =
      "https://maps.googleapis.com/maps/api/geocode/json?&key=$googleMapsAPI&latlng=${lat},${long}";

  String str1, str2, str3, str4;

  var response = await httpRequest(geoURL);

  if (response != "failed") {
    str1 = "${response["results"][0]["address_components"][1]["long_name"]}";
    str2 = "${response["results"][0]["address_components"][2]["long_name"]}";
    str3 = "${response["results"][0]["address_components"][3]["long_name"]}";
    // str4 = "${response["results"][0]["address_components"][6]["long_name"]}";

    placeAddress = "$str1, $str2, $str3";
  }
  return placeAddress;
}

* */
