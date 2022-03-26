import 'package:flutter/material.dart';

import 'Input_container.dart';

// ignore: camel_case_types
class Registration_Input extends StatelessWidget {
  Registration_Input({
    Key? key,
    required this.hintText,
    required this.icon,
    required this.fn,
  }) : super(key: key);
  final String hintText;
  final IconData icon;
  final TextEditingController _textEditingController = TextEditingController();
  final Function fn;

  @override
  Widget build(BuildContext context) {
  return InputContainer(
    child: TextField(
      onChanged: (value) {
        fn(value);

      },
      controller: _textEditingController,
      cursorColor: Colors.blue,
      decoration: InputDecoration(
        icon: Icon(
          icon,
          color: Colors.blue,
        ),
        hintText: hintText,
        border: InputBorder.none,
      ),
    ),
  );
  }
}
