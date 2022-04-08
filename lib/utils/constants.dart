
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_flavor/flutter_flavor.dart';

dynamic getGoogleMapsAPI() {
  return "AIzaSyCuDZsh0WAgOreWhre_G2PlPJ61yLfGVc4";
  // return FlavorConfig.instance.variables["maps_api"];
  // return await DotEnv().env['GOOGLE_MAPS_API'];
}


DatabaseReference wsaRef = FirebaseDatabase.instance.ref().child("wsa");
DatabaseReference rsaRef = FirebaseDatabase.instance.ref().child("rsa");

final googleMapsAPI = "AIzaSyCuDZsh0WAgOreWhre_G2PlPJ61yLfGVc4";

// geoCoding Key
final geoCodingKey = "iuB50RlAEGAluJnwc4M4rDHBBQSbknBS";

// For firebase emulator (don't touch)
final localHostString = Platform.isAndroid? '10.0.2.2' : 'localhost';
const int fbdbport = 9000;
const fbauthport = 9099;
const _fbcfport = 5001;
final fbcfurl = "http://"+localHostString+":$_fbcfport/salahny-6bfea/us-central1/";
