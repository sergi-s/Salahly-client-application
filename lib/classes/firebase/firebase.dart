// ignore_for_file: avoid_renaming_method_parameters

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:slahly/abstract_classes/authentication.dart';
import 'package:slahly/classes/models/client.dart';
import 'package:slahly/main.dart';
import 'package:slahly/utils/constants.dart';

class FirebaseCustom extends Authentication {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<bool> login(String email, String password) async {
    // TODO: Magdy
    try {
      String emm = ((email) != null ? email : "").toString();
      final user = await _firebaseAuth.signInWithEmailAndPassword(
          email: emm, password: password);
      if (user != null) {
        await _registerFCMToken(FirebaseAuth.instance.currentUser!.uid);
        _registerNotifications();
        return true;
      }
    } catch (e) {
      print(e);
      return false;
    }
    return false;
  }

  logout()async{
    await FirebaseDatabase.instance
        .ref()
        .child("FCMTokens")
        .child(FirebaseAuth.instance.currentUser!.uid)
        .remove();

    await FirebaseAuth.instance.signOut();
  }

  _registerFCMToken(String id) async {
    return await FirebaseMessaging.instance
        .getToken()
        .then((value) => dbRef.child("FCMTokens").child(id).set(value));
  }

  _registerNotifications() {
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("message recieved");
      print(event.notification!.body);
      showSimpleNotification(
          Text("Received a notification, rsaID: " +
              event.notification!.body.toString()),
          background: Colors.green);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
    });
  }

  @override
  Future<bool> signup(String email, String password) async {
    String emm = ((email) != null ? email : "").toString();
    final User? firebaseUser = (await _firebaseAuth
            .createUserWithEmailAndPassword(email: emm, password: password)
            .catchError((errMsg) {
      print(errMsg);
      print('5ara');
      return false;
    }))
        .user;

    if (firebaseUser != null) {
      return true;
      //user created
      // Map userDataMap = {
      //   "name": client.name,
      //   "email": client.email,
      //   "birthday": client.birthDay,
      //   "createdDate": client.createdDate,
      //   "sex": client.sex,
      //   "type": client.type,
      //   "avatar": client.avatar,
      //   "address": client.address,
      //   "phoneNumber": client.phoneNumber,
      //   "loc": client.loc
    }
    // usersRef.child(firebaseUser.uid).set(userDataMap);
    return false;
  }

  @override
  Future<bool> registration(Client client) async {
    final User? user = _firebaseAuth.currentUser;
    if (user == null) {
      return false;
    }
    final uid = user.uid;
    Map<String ,dynamic> userDataMap = {
      "name": client.name,
      "email": client.email,
      "birthday": client.birthDay.toString(),
      "gender": client.gender.toString(),
      // "avatar": client.avatar,
      "address": client.address,
      "phoneNumber": client.phoneNumber,
    };
    usersRef.child("clients").child(uid).update(userDataMap);
    return true;
  }

  final bool use_emulator = true;

  Future _connectToFirebaseEmulator() async {
    final _localHostString = localHostString;
    FirebaseDatabase.instance.useDatabaseEmulator(_localHostString, fbdbport);
    await FirebaseAuth.instance.useAuthEmulator(_localHostString, fbauthport);
    print("Connected to emulator");
  }

  Future connectToEmulator() async {
    if (use_emulator) {
      try {
        await _connectToFirebaseEmulator();
      } catch (Exception) {
        print(Exception);
      }
    } else
      print("Not using emulator");
  }
}
