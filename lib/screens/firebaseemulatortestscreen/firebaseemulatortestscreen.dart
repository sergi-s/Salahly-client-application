import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:slahly/main.dart';
import 'package:slahly/utils/constants.dart';

class FirebaseEmulatorScreen extends StatelessWidget {
  static final routeName = "/firebaseemulatortestscreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: _sendMessage, child: Text("Test send msg")),
              ElevatedButton(
                  onPressed: () async {
                    readmsg();
                  },
                  child: Text("Test read msg")),
              ElevatedButton(
                  onPressed: () async {
                    signupAccount();
                  },
                  child: Text("Sign up test")),
              ElevatedButton(
                  onPressed: () async {
                    login();
                  },
                  child: Text("login test")),
              ElevatedButton(
                  onPressed: () async {
                    httptest();
                  },
                  child: Text("http test")),
            ],
          ),
        ),
      ),
    );
  }

  void readmsg() {
    //.child("1")
    // FirebaseDatabase.instance.reference().child("users").get().then((snap) => () {
    //       print(snap.value);
    //     });
    final DatabaseReference messagesRef = FirebaseDatabase.instance.ref();
    //messagesRef
    dbRef.child("users").child("1").get().then((value) {
       print(value.value);
    });
    print("OK");
  }

  void _sendMessage() {
    if (true) {
      final message = Message("Hello test", DateTime.now());
      saveMessage(message);
    }
  }

  Future<bool> login() async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    // TODO: Magdy
    try {
      final user = await _firebaseAuth.signInWithEmailAndPassword(
          email: "mo@mo.mo", password: "momomo");
      if (user != null) {
        return true;
      }
    } catch (e) {
      print(e);
      return false;
    }
    return false;
  }

  Future signupAccount() async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final User? firebaseUser = (await _firebaseAuth
            .createUserWithEmailAndPassword(
                email: "mo@mo.mo", password: "momomo")
            .catchError((errMsg) {
      print(errMsg);
      return false;
    }))
        .user;

    if (firebaseUser != null) {
      //user created
      return true;
    }
    return false;
  }

  void httptest() async {
    var url = Uri.parse(fbcfurl + "helloWorld");
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

//    ".read": "now < 1649368800000",  // 2022-4-8
//    ".write": "now < 1649368800000",  // 2022-4-8

  void saveMessage(Message message) {
    // final DatabaseReference messagesRef =  FirebaseDatabase.instance.ref().child('messages');
    final DatabaseReference messagesRef = FirebaseDatabase.instance.ref();
    messagesRef.child("messages").set({'date': 'sergi', 'text': 'kokoko'});
    // messagesRef.push().set(message.toJson());
    print("OK");
  }
// Query getMessageQuery() {
//   return messagesRef;
// }
}

class Message {
  final String text;
  final DateTime date;

  Message(this.text, this.date);

  Message.fromJson(Map<dynamic, dynamic> json)
      : date = DateTime.parse(json['date'] as String),
        text = json['text'] as String;

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'date': date.toString(),
        'text': text,
      };
}
