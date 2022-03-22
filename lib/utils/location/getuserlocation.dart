import 'package:geolocator/geolocator.dart';
import 'package:slahly/classes/models/location.dart';


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
  print("sad");
  Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  return CustomLocation(longitude: pos.longitude, latitude: pos.latitude);
}