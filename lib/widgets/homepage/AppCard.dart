import 'dart:ui';
import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  const CardWidget(
      {Key? key,
        required this.title,
        required this.subtitle,
        required this.image,
        required this.fun})
      : super(key: key);
  final Function fun;
  final String title;
  final String subtitle;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width*0.88,
        height: MediaQuery.of(context).size.height*0.16,

        child: Card(
          semanticContainer: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 10,
          color: Color(0xFFFAF9F6),
          // margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: () {
              fun();
            },
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: Image.asset(image,
                        width: 45, height: 170, alignment: Alignment.centerLeft),
                    title: Text(
                      title,
                      textScaleFactor: 1.5,
                      style: TextStyle(color: Colors.indigo[800]),
                    ),
                    subtitle: Text(
                      subtitle,
                      style: const TextStyle(color: Colors.black54,fontSize:15),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
