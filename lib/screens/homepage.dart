import 'package:flutter/src/widgets/framework.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:slahly/screens/myLocation/mylocationscreen.dart';
import 'package:slahly/widgets/homepage/AppCard.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget{
  const HomePage({Key? key}) : super(key: key);
  static final routeName = "/";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/images/logo white.png', fit: BoxFit.contain, scale:50),
        centerTitle: true,
        backgroundColor: Color(0xff193566),

        flexibleSpace: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(left:0.0,right:10.0 ),

          child: CircleAvatar(
            backgroundImage: AssetImage('assets/images/tarek.jpg'),
          ),
        ),
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage('assets/images/wavy shape copy.png'),alignment: Alignment.topCenter,fit: BoxFit.fill),
                  color: Colors.transparent
              ),
              child: Text(''),
            ),
            ListTile(
              title: const Text('Add User',style: TextStyle(fontWeight: FontWeight.bold),).tr(),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Update Profile').tr(),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('History').tr(),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Reminder').tr(),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),


      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('WELCOME MR AHMED',textScaleFactor: 1.4 ,style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xff193566)),).tr(),
          CardWidget(
              fun: (){context.go(MyLocationScreen.routeName);},
              title: 'Roadside assistant',
              subtitle: 'Lorem ipsum dolor sit consectetur adipiscing sed do eiusmod tempor ',
              image: 'assets/images/tow-truck 2.png'),

          CardWidget(
              fun: (){

              },
              title: 'Workshop assistant',
              subtitle: 'Lorem ipsum dolor sit consectetur adipiscing sed do eiusmod tempor',
              image: 'assets/images/mechanic.png'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        isExtended: true,
        onPressed: () {
        },
        backgroundColor: Color(0xff193566),
        child: Image.asset('assets/images/bot2.png'),
      ),
    );
  }



}