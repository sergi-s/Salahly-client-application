import 'package:slahly/abstract_classes/authentication.dart';
import 'package:slahly/classes/models/client.dart';
import 'package:firebase_auth/firebase_auth.dart';


class FirebaseAuth extends Authentication{

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
  void signup(Client client) {
    // TODO: H

  }

}