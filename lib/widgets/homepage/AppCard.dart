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
      child: Card(
        semanticContainer: true,
        margin: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            fun();
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Image.asset(image,
                    width: 50, height: 200, alignment: Alignment.centerLeft),
                title: Text(
                  title,
                  textScaleFactor: 1.5,
                  style: TextStyle(color: Colors.indigo[800]),
                ),
                subtitle: Text(
                  subtitle,
                  style: const TextStyle(color: Colors.black54),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
