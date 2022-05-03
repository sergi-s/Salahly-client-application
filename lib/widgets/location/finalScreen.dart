import "package:flutter/material.dart";
import 'package:slahly/widgets/gloable_widgets/app_bar.dart';
import 'package:slahly/widgets/gloable_widgets/app_drawer.dart';

class RequestFinalScreen extends StatefulWidget {
  static const String routeName = "/requestFinalScreen";

  RequestFinalScreen({Key? key}) : super(key: key);

  @override
  State<RequestFinalScreen> createState() => _RequestFinalScreenState();
}

class _RequestFinalScreenState extends State<RequestFinalScreen> {
  final String cta = "";

  final String img = "https://via.placeholder.com/200";

  final Function tap = () {
    print("Place holder function");
  };

  final String title = "Placeholder Title";

  bool _checkboxValue = false;

  final double height = 200;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: salahlyAppBar(),
        extendBodyBehindAppBar: true,
        drawer: salahlyDrawer(context),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(""), fit: BoxFit.cover)),
            ),
            SafeArea(
              child: ListView(children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 16, left: 16.0, right: 16.0, bottom: 32),
                  child: Card(
                      elevation: 5,
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Container(
                          height: MediaQuery.of(context).size.height * 0.78,
                          color: Color.fromRGBO(255, 255, 255, 1.0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 24.0, bottom: 8),
                                    child: Center(
                                        child: Text("Register",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600))),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      RawMaterialButton(
                                        onPressed: () {},
                                        elevation: 4.0,
                                        fillColor:
                                            Color.fromRGBO(59, 89, 152, 1.0),
                                        child: Icon(Icons.facebook,
                                            size: 16.0, color: Colors.white),
                                        padding: EdgeInsets.all(15.0),
                                        shape: CircleBorder(),
                                      ),
                                      RawMaterialButton(
                                        onPressed: () {},
                                        elevation: 4.0,
                                        fillColor:
                                            Color.fromRGBO(91, 192, 222, 1.0),
                                        child: Icon(Icons.animation,
                                            size: 16.0, color: Colors.white),
                                        padding: EdgeInsets.all(15.0),
                                        shape: CircleBorder(),
                                      ),
                                      RawMaterialButton(
                                        onPressed: () {},
                                        elevation: 4.0,
                                        fillColor:
                                            Color.fromRGBO(234, 76, 137, 1.0),
                                        child: Icon(Icons.car_repair,
                                            size: 16.0, color: Colors.white),
                                        padding: EdgeInsets.all(15.0),
                                        shape: CircleBorder(),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 24.0, bottom: 24.0),
                                    child: Center(
                                      child: Text("or be classical",
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  154, 154, 154, 1.0),
                                              fontWeight: FontWeight.w200,
                                              fontSize: 16)),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Input(
                                          placeholder: "First Name...",
                                          prefixIcon:
                                              Icon(Icons.school, size: 20),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Input(
                                            placeholder: "Last Name...",
                                            prefixIcon:
                                                Icon(Icons.email, size: 20)),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0,
                                            left: 8.0,
                                            right: 8.0,
                                            bottom: 0),
                                        child: Input(
                                            placeholder: "Your Email...",
                                            prefixIcon:
                                                Icon(Icons.lock, size: 20)),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, top: 0, bottom: 16),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Checkbox(
                                                value: _checkboxValue,
                                                activeColor: Colors.purple,
                                                onChanged: (bool? newValue) {
                                                  setState(() =>
                                                      _checkboxValue =
                                                          newValue!);
                                                }),
                                            Text(
                                                "I agree with the terms and conditions",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w200)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Center(
                                    child: RaisedButton(
                                      textColor: Colors.white,
                                      color: Color.fromRGBO(249, 99, 50, 1.0),
                                      onPressed: () {
                                        // Respond to button press
                                        Navigator.pushReplacementNamed(
                                            context, '/home');
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(32.0),
                                      ),
                                      child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 32.0,
                                              right: 32.0,
                                              top: 12,
                                              bottom: 12),
                                          child: Text("Get Started",
                                              style:
                                                  TextStyle(fontSize: 14.0))),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ))),
                ),
              ]),
            )
          ],
        ));
  }
}

class Input extends StatelessWidget {
  late final String? placeholder;
  late final Widget? suffixIcon;
  late final Widget? prefixIcon;
  late final Function? onTap;
  late final Function? onChanged;
  late final TextEditingController? controller;
  late final bool? autofocus;
  late final Color? borderColor;

  Input(
      {this.placeholder,
      this.suffixIcon,
      this.prefixIcon,
      this.onTap,
      this.onChanged,
      this.autofocus = false,
      this.borderColor,
      this.controller});

  // {
  //   this.placeholder = this.placeholder ?? "placeholder";
  //   this.suffixIcon = this.suffixIcon ?? Container();
  //   this.prefixIcon = this.prefixIcon ?? Container();
  //   this.onTap = this.onTap ??
  //       () {
  //         print("onTap Input");
  //       };
  //   this.onChanged = this.onChanged ??
  //       () {
  //         print("onChange Input");
  //       };
  //   this.controller = this.controller ?? TextEditingController();
  //   this.borderColor = this.borderColor ?? Color.fromRGBO(231, 231, 231, 1.0);
  // }

  @override
  Widget build(BuildContext context) {
    return TextField(
        cursorColor: Color.fromRGBO(136, 152, 170, 1.0),
        // onTap: onTap,
        // onChanged: onChanged,
        controller: controller ?? TextEditingController(),
        autofocus: autofocus ?? false,
        style: TextStyle(
            height: 0.55,
            fontSize: 13.0,
            color: Color.fromRGBO(154, 154, 154, 1.0)),
        textAlignVertical: const TextAlignVertical(y: 0.6),
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintStyle: TextStyle(
              color: Color.fromRGBO(154, 154, 154, 1.0),
            ),
            suffixIcon: suffixIcon ?? Container(),
            prefixIcon: prefixIcon ?? Container(),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32.0),
                borderSide: BorderSide(
                    color: borderColor ?? Colors.amber,
                    width: 1.0,
                    style: BorderStyle.solid)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32.0),
                borderSide: BorderSide(
                    color: borderColor ?? Colors.amber,
                    width: 1.0,
                    style: BorderStyle.solid)),
            hintText: placeholder));
  }
}
