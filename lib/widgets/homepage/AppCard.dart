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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 10,
        color:Colors.white,
        // margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            fun();
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.88,
            height: MediaQuery.of(context).size.height * 0.17,
            decoration:BoxDecoration(
              borderRadius: BorderRadius.circular(18.0),
              boxShadow: [
                BoxShadow(
                  color:Colors.indigo.withOpacity(0.3) ,
                  offset: const Offset(
                    5.0,
                    5.0,
                  ),
                  blurRadius: 10.0,
                  spreadRadius: 2.0,
                ), //BoxShadow
                BoxShadow(
                  color: Colors.white,
                  offset: const Offset(0.0, 0.0),
                  blurRadius: 0.0,
                  spreadRadius: 0.0,
                ), //BoxShadow
              ],
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: Image.asset(image,
                        width: 45,
                        height: 170,
                        alignment: Alignment.centerLeft),
                    title: Text(
                      title,
                      textScaleFactor: 1.5,

                      style: TextStyle(color: Colors.indigo[800],fontSize:15),

                    ),
                    subtitle: Text(
                      subtitle,
                      style:
                          const TextStyle(color: Colors.black54, fontSize: 15),
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
