import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:slahly/classes/firebase/roadsideassistance/roadsideassistance.dart';

import 'package:slahly/classes/provider/rsadata.dart';

class Arrival extends StatefulWidget {
  static const routeName = "/Select";
  bool? type;

  Arrival({this.type});

  @override
  _ArrivalState createState() => _ArrivalState();
}

class _ArrivalState extends State<Arrival> with SingleTickerProviderStateMixin {
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
    return Consumer(
      builder: (context, ref, child) {
        final RSA rsa = ref.watch(rsaProvider);
        // if (rsa.towProvider?.name == null) {}
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
                              Consumer(
                                builder: (context, ref, child) {
                                  final RSA rsa = ref.watch(rsaProvider);

                                  return Text(rsa.towProvider?.name ??
                                      "searching for provider");
                                },
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                    height: 100,
                                  ),
                                  Text(
                                    "Booking_successful".tr(),
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
      },
    );
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
