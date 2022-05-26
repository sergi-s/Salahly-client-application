import 'package:flutter/material.dart';

class MyInput extends StatelessWidget {

  final String hint;
  final Function fn;
  final Widget? widget;
  final TextEditingController? controller;

  MyInput(
      {Key? key,

      required this.hint,
      required this.fn,
      this.controller,
      this.widget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              padding: EdgeInsets.symmetric(horizontal: 20),
              width: size.width * 0.8,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.grey[200],
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueGrey,
                      blurRadius: 2.0,
                      spreadRadius: 0.0,
                      offset: Offset(3, 0),
                    ),
                  ]),

              child: Row(
                children: [
                  widget == null
                      ? Container()
                      : Container(
                    child: widget,
                  ),
                  // SizedBox(
                  //   width: MediaQuery.of(context).size.width * 0.02,
                  // ),

                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        fn(value);
                      },
                      readOnly: widget == null ? false : true,
                      autofocus: false,
                      cursorColor: Colors.blue,
                      controller: controller,
                      // controller: controller,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[900],
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        // errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        hintText: hint,
                        hintStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
