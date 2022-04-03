import 'package:flutter/material.dart';



class ViewHistory extends StatelessWidget {
  static final routeName = "/viewhistory.dart";
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: const Color(0xFFd1d9e6),
      appBar: new AppBar(
        backgroundColor: const Color(0xFF193566),
        title: new Text("View History"),
      ), // appBar
      body: new Container(
        padding: new EdgeInsets.all(10.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new myCardLayout(theIcon: Icons.view_agenda, theText: "Report 1"),
            new myCardLayout(theIcon: Icons.view_agenda, theText: "Report 2"),
            new myCardLayout(theIcon: Icons.view_agenda, theText: "Report 3"),
            new myCardLayout(theIcon: Icons.view_agenda, theText: "Report 4"),
            //this is not the list example, so when you add new cards, it won't be inside of the list.
          ],
        ), // column
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
      child: new Card(


        elevation:3,
        margin: EdgeInsets.all(10),
        color: Color(0xFFE8E8E8),
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new ListTile(
              leading: new Icon(theIcon,
                  size: 40.0, color: Colors.grey),
              title: new Text(

                theText,
                style: new TextStyle(

                    fontSize: 20.0),
              ),

              subtitle:

              const Text('Date: 20/2/2022 \n Car: MG 6 \n Number Plate:س ق ه | 2544'),
            ),

            new ButtonTheme(
              // make buttons use the appropriate styles for cards
              child: new ButtonBar(
                children: <Widget>[
                  new FlatButton(
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