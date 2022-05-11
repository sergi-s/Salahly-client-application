import 'package:flutter/material.dart';
import 'package:slahly/abstract_classes/user.dart';
import 'package:slahly/classes/models/location.dart';
import 'package:slahly/classes/models/road_side_assistance.dart';
import 'package:slahly/classes/models/towProvider.dart';
import 'package:slahly/screens/history_management/accordion.dart';
import 'package:slahly/screens/history_management/add_custom_history.dart';

class ViewHistory extends StatelessWidget {
  static const routeName = "/viewhistory";

  ViewHistory({Key? key}) : super(key: key);

  List<RSA> rsaHistory = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFd1d9e6),
        appBar: AppBar(
          backgroundColor: const Color(0xFF193566),
          bottom: const TabBar(
            tabs: [
              Tab(text: "History"),
              Tab(text: "Custom History"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Builder(builder: (context) {
              return Column(
                        children: [
                          SizedBox(height: 10),
                          ListView.builder(
                            itemBuilder: (BuildContext, index) {
                              return Accordion(
                                  providers[index].email.toString(),
                                  providers[index].avatar.toString(),
                                  providers[index].phoneNumber.toString(),
                                  providers[index].name.toString(),
                                  providers[index].loc!.address.toString(),
                                  providers[index].type!,
                                  false);
                            },
                            itemCount: providers.length,
                            shrinkWrap: true,
                            padding: EdgeInsets.all(5),
                            scrollDirection: Axis.vertical,
                          ),
                        ],
                      );
                    }
                ),


                Builder(
                    builder: (context) {
                      return Column(
                        children: [
                          SizedBox(height: 10),
                          ListView.builder(
                            itemBuilder: (BuildContext, index) {
                              return Accordion(
                                  providers[index].email.toString(),
                                  providers[index].avatar.toString(),
                                  providers[index].phoneNumber.toString(),
                                  providers[index].name.toString(),
                                  providers[index].loc!.address.toString(),
                                  providers[index].type!,
                                  false);
                            },
                            itemCount: providers.length,
                            shrinkWrap: true,
                            padding: EdgeInsets.all(5),
                            scrollDirection: Axis.vertical,
                          ),
                          FloatingActionButton(
                            backgroundColor: const Color(0xFF193566),
                            foregroundColor: Colors.white,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => AddCustomHistory()));
                            },
                            child: Icon(Icons.add),)

                        ],
                      );

                    }

                ),


              ],
            ),
          ),
        ));
  }
}















List<TowProvider> providers = [
  TowProvider(
      nationalID: '123132',
      name: 'Report 1',
      phoneNumber: 'MG 6',
      loc: CustomLocation(
          address:
          "Factorya, shar3 45 odam mtafy 12311321312312hasdhdashjss221",
          longitude: 11,
          latitude: 11),
      avatar: 'https://www.woolha.com/media/2020/03/eevee.png',
      email: 'email@yahoo.com',
      type: Type.provider),
  TowProvider(
      nationalID: '123132',
      name: 'Report 2',
      phoneNumber: 'Bmw 320I',
      loc: CustomLocation(
          address:
          "Factorya, shar3 45 odam mtafy 12311321312312hasdhdashjss221",
          longitude: 11,
          latitude: 11),
      avatar: 'https://www.woolha.com/media/2020/03/eevee.png',
      email: 'email@yahoo.com',
      type: Type.provider),
];







































