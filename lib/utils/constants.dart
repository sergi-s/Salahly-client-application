import 'dart:io';

import 'package:firebase_database/firebase_database.dart';

dynamic getGoogleMapsAPI() {
  return "AIzaSyCuDZsh0WAgOreWhre_G2PlPJ61yLfGVc4";
  // return FlavorConfig.instance.variables["maps_api"];
  // return await DotEnv().env['GOOGLE_MAPS_API'];
}

DatabaseReference wsaRef = FirebaseDatabase.instance.ref().child("wsa");
DatabaseReference rsaRef = FirebaseDatabase.instance.ref().child("rsa");
DatabaseReference ttaRef = FirebaseDatabase.instance.ref().child("tta");
DatabaseReference conflictRef = FirebaseDatabase.instance.ref("cars_conflict");

const googleMapsAPI = "AIzaSyCuDZsh0WAgOreWhre_G2PlPJ61yLfGVc4";

// geoCoding Key
const geoCodingKey = "iuB50RlAEGAluJnwc4M4rDHBBQSbknBS";

// For firebase emulator (don't touch)
final localHostString = Platform.isAndroid ? '10.0.2.2' : 'localhost';
const int fbdbport = 9000;
const fbauthport = 9099;
const _fbcfport = 5001;

final fbcfurl =
    "http://" + localHostString + ":$_fbcfport/salahny-6bfea/us-central1/";

// final fbcfurl =
//     "http://" + localHostString + ":$_fbcfport/salahny-6bfea/us-central1/";

const bool kReleaseMode = bool.fromEnvironment('dart.vm.product');
const bool kProfileMode = bool.fromEnvironment('dart.vm.profile');
const bool kDebugMode = !kReleaseMode && !kProfileMode;


const double dialogRadius = 20;
