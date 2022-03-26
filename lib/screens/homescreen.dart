import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:slahly/classes/firebase/nearbylocations.dart';
import 'package:slahly/classes/firebase/roadsideassistance/roadsideassistance.dart';
import 'package:slahly/classes/models/location.dart';
import 'package:slahly/classes/models/mechanic.dart';
import 'package:slahly/classes/models/towProvider.dart';
import 'package:slahly/main.dart';

class HomeScreen extends StatefulWidget {
  static final routeName = "/homescreen";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late CustomLocation userLoc;
  NearbyLocations geo = NearbyLocations();
  @override
  void initState() {

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ElevatedButton(
            //     onPressed: ()async{
            //       geo.addNearbyMechanics();
            //     },
            //     child: Text('Add mechanics')),
            // ElevatedButton(
            //     onPressed: ()async{
            //       geo.addNearbyProviders();
            //     },
            //     child: Text('Add providers')),

            ElevatedButton(
                onPressed: ()async{
                  List<Mechanic> nearb = [];
                  // await FirebaseAuth.instance.signOut();
                  NearbyLocations.getNearbyMechanics(31.206971, 29.919035,100,nearb);


                  // print("Keys retrieved "+NearbyLocations.keysRetrieved.length.toString());
                  // for(var k in NearbyLocations.keysRetrieved){
                  //   print("WE RETREIVED: "+k);
                  // }
                },
                child: Text('get nearby mechanics')),

            ElevatedButton(
                onPressed: ()async{
                  // await FirebaseAuth.instance.signOut();
                  List<TowProvider> nearb = [];
                  NearbyLocations.getNearbyProviders(31.206971, 29.919035,100,nearb);


                  // print("Keys retrieved "+NearbyLocations.keysRetrieved.length.toString());
                  // for(var k in NearbyLocations.keysRetrieved){
                  //   print("WE RETREIVED: "+k);
                  // }
                },
                child: Text('get nearby providers')),
            ElevatedButton(
                onPressed: ()async{
                  Mechanic m = Mechanic(name: "",email: "",id: "123");
                  TowProvider p = TowProvider(name: "name", email: "email", isCenter: false,id: "456",nationalID: "123");
                  CustomLocation l = CustomLocation(longitude: 1,latitude: 2);
                  // RSA r = RSA();
                  // r.setLocation(l);
                  // r.setMechanic(m,false);
                  // r.setProvider(p,false);
                  // print("sad");
                  // r.requestRSA();
                  ///TODO reimplement after reconstruction
                },
                child: Text('Test RSA request')),

          ],
        ),
      ),
    );
  }


}
