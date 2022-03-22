import 'package:flutter/src/widgets/framework.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:slahly/classes/firebase/firebase.dart';
import 'package:slahly/classes/models/client.dart';
import 'package:slahly/main.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';
import 'package:slahly/screens/roadsideassistance/choosemechanic.dart';
import 'package:slahly/screens/roadsideassistance/chooseprovider.dart';
import 'package:slahly/widgets/homepage/AppCard.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key, }) : super(key: key);
  static final routeName = "/homepage";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          alignment: Alignment.centerRight,
          child: CircleAvatar(
            backgroundImage:
            AssetImage('assets/images/tarek.jpg'),
          ),
        ),
          flexibleSpace:
          Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/logo white.png'),
                fit: BoxFit.contain
            )
        ),
      ) ,foregroundColor: Colors.white,backgroundColor: Colors.indigo[800]),
      body: Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children:[

          Text('Welcome Mr Ahmed',style: TextStyle(fontWeight:FontWeight.bold ,color: Colors.indigo[800]),textScaleFactor: 1.5,),
          CardWidget(
          title:'RoadSide Assistant',
          subtitle: 'Lorem ipsum dolor sitc onsectetur adipiscing sed do eiusmod tempor'  ,
          image:'assets/images/tow-truck 2.png' ),
          CardWidget(title: 'Workshop Assistant',
              subtitle: 'Lorem ipsum dolor sitc onsectetur adipiscing sed do eiusmod tempor',
              image: 'assets/images/mechanic.png')
        ],
      ),
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
              DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.transparent,
                image: DecorationImage(image:AssetImage('assets/images/wavy shape copy.png'),alignment:Alignment.topCenter
              ),),
              child: Text('',textAlign: TextAlign.left,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
            ),
            ListTile(
              title: const Text('Add profile'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Update profile'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('History'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Set Reminder'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Image.asset('assets/images/bot2.png'),
        foregroundColor: Colors.white,
        backgroundColor:Colors.indigo[900] ,
        onPressed:(){} ,
      ),
    );
  }
}
