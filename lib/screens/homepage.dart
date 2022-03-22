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

class HomePage extends StatelessWidget{
  const HomePage({Key? key}) : super(key: key);
  static final routeName = "/homepage";

 @override
 Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       backgroundColor: Colors.white10,
         centerTitle: true,
       elevation: 0.0,
        toolbarHeight: 180,
         flexibleSpace: Container(
         decoration: BoxDecoration(
         image: DecorationImage(
         image: AssetImage('assets/images/wavy shape copy.png'),
     fit: BoxFit.fill ,alignment: Alignment.bottomCenter),),),),
     body: Container(
       alignment: Alignment.topCenter,
       child: Center(
         child: Column(
           mainAxisSize: MainAxisSize.max ,
           mainAxisAlignment: MainAxisAlignment.center,
           crossAxisAlignment: CrossAxisAlignment.center,
           children: [
             SizedBox( // <-- use a sized box and change the height
               height: 2,
             ),
             Image.asset('assets/images/car job.png', fit: BoxFit.contain ,scale:21, alignment: Alignment.topCenter),
             ElevatedButton(onPressed: (){}, child: Text("Choose Mechanic").tr()),
             Image.asset('assets/images/Towing-amico copy.png', fit: BoxFit.contain ,scale:10,alignment: Alignment.topCenter),
             ElevatedButton(onPressed: (){}, child: Text("Choose Provider")),

           ],
         ),
       ),
     ),
   );
 }

















}