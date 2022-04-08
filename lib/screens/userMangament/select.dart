import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animate_icons/animate_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:slahly/classes/firebase/roadsideassistance/roadsideassistance.dart';

import '../../classes/provider/rsadata.dart';
import '../../classes/provider/user_data.dart';

// class Select extends StatelessWidget {
//   // bool change;
//
//
//   @override
//   Widget build(BuildContext context) {
//     // if (change) {
//     //   //TODOs
//     //   context.go("choose PTOVE PAGE");
//     // }
//     final topPaddin
//     return Container(
//       decoration: BoxDecoration(
//           gradient: LinearGradient(colors: [
//         Color.fromRGBO(145, 131, 222, 1),
//         Color.fromRGBO(160, 148, 227, 1),
//       ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         body: Column(
//           children: [
//             SizedBox(height: ,)
//           ],
//         ),
//       ),
//     );
//   }
// }
// Select(this.change);

class Select extends StatefulWidget {
  static const routeName = "/Select";
  bool? type;

  Select({this.type});

  @override
  _SelectState createState() => _SelectState();
}

class _SelectState extends State<Select> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  )..repeat(reverse: true);

  late final Animation<Offset> _animation = Tween<Offset>(
    begin: Offset.zero,
    end: Offset(0, 0.08),
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFd1d9e6),
        body: CustomPaint(
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 70, top: 130),
                child: Image.asset(
                  'assets/images/clouds.png',
                  height: 150,
                  width: 250,
                ),
              ),
              SlideTransition(
                position: _animation,
                child: Padding(
                  padding: EdgeInsets.only(left: 70, top: 130),
                  child: Image.asset(
                    !widget.type!
                        ? 'assets/images/mechanic.png'
                        : "assets/images/tow-truck 2.png",
                    height: 150,
                    width: 250,
                  ),
                ),
              ),
              Container(
                  padding: EdgeInsets.only(left: 10, top: 300, right: 10),
                  child: Card(
                    color: Colors.transparent,
                    child: Container(
                      color: const Color(0xFFd1d9e6),
                      height: 200,
                      width: 500,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 10,
                                height: 100,
                              ),
                              Text(
                                "Booking successful",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 40,
                                    color: Color(0xFF193566)),
                              ),
                            ],
                          ),
                          Row(children: [
                            // CircleAvatar(
                            //   radius: 25,
                            //   child: Icon(Icons.check, size: 25),
                            //   backgroundColor: Colors.green,
                            // ),
                            SizedBox(
                              width: 20,
                            ),
                            Flexible(
                                child: Text(
                              widget.type!
                                  ? "Provider is coming"
                                  : "Mechanic is waiting",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                  color: Color(0xFF193566)),
                            )),
                            SpinKitThreeBounce(
                              color: Color(0xFF193566),
                              size: 30,
                            )
                          ]),
                        ],
                      ),
                    ),
                    elevation: 0,
                  ))
            ],
          ),
          // painter: HeaderCurvedContainer(),
        ));
  }
}

class HeaderCurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = const Color(0xFF193566);
    Path path = Path()
      ..relativeLineTo(0, 90)
      ..quadraticBezierTo(size.width / 2, 150, size.width, 90)
      ..relativeLineTo(0, -90)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
