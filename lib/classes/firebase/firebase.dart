import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:slahly/abstract_classes/authentication.dart';
import 'package:slahly/classes/models/client.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseAuth extends Authentication {
  @override
  void login(Client client) {
    // TODO: Magdy
    try {
      final user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (user != null) {
        Navigator.pushNamed(context, ChatScreen.id);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<bool> signup(Client client) async {
    DatabaseReference usersRef =
        FirebaseDatabase.instance.reference().child("user");

    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

    final User firebaseUser =
        (await _firebaseAuth.createUserWithEmailAndPassword(
                email: client.email, password: client.password))
            .catchError((errMsg) {
      print(errMsg);
      return false;
    }).user;
    if (firebaseUser != null) {
      //user created
      Map userDataMap = {
        "name": client.name,
        "email": client.email,
        "birthday": client.birthday,
        "createdDate": client.createdDate,
        "sex": client.sex,
        "type": client.type,
        "avatar": client.avatar,
        "address": client.address,
        "phoneNumber": client.phoneNumber,
        "loc": client.loc
      };
      usersRef.child(firebaseUser.uid).set(userDataMap);
      return true;
    }
    return false;
  }
}
