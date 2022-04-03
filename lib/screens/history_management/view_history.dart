import 'package:flutter/material.dart';
import 'package:slahly/classes/firebase/roadsideassistance/roadsideassistance.dart';



class ViewHistory extends StatelessWidget {
  late List<RSA> rsaHistory;

  static final routeName = "/viewhistory";
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: const Color(0xFFd1d9e6),
      appBar:  AppBar(
        backgroundColor: const Color(0xFF193566),
        title:  Text("View History"),
      ), // appBar
      body:  SingleChildScrollView(
        child: Container(
          padding:  EdgeInsets.all(10.0),
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
               myCardLayout(theIcon: Icons.view_agenda, theText: "Report 1"),
               myCardLayout(theIcon: Icons.view_agenda, theText: "Report 2"),
               myCardLayout(theIcon: Icons.view_agenda, theText: "Report 3"),
               myCardLayout(theIcon: Icons.view_agenda, theText: "Report 4"),
              //this is not the list example, so when you add new cards, it won't be inside of the list.
            ],
          ), // column
        ),
      ), // Container
    ); // scaffold
  }
}

class myCardLayout extends StatelessWidget {
  // default constructor
  myCardLayout({required this.theIcon, required this.theText});

  // init variables
  final IconData theIcon;
  final String theText;

  @override
  Widget build(BuildContext context) {
    return Container(
      child:  Card(


        elevation:3,
        margin: EdgeInsets.all(10),
        color: Color(0xFFE8E8E8),
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child:  Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
             ListTile(
              leading:  Icon(theIcon,
                  size: 40.0, color: Colors.grey),
              title:  Text(

                theText,
                style:  TextStyle(

                    fontSize: 20.0),
              ),

              subtitle:

              const Text('Date: 20/2/2022 \n Car: MG 6 \n Number Plate:س ق ه | 2544'),
            ),

             ButtonTheme(
              // make buttons use the appropriate styles for cards
              child:  ButtonBar(
                children: <Widget>[
                   FlatButton(
                    child: const Text('View'),
                    onPressed: () {
                      /* ... */
                    },
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}