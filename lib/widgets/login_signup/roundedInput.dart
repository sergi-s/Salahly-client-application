import 'package:flutter/material.dart';
import 'package:slahly/widgets/login_signup/Input_container.dart';

class RounedInput extends StatelessWidget {
  RounedInput({
    Key? key,
    required this.icon,
    required this.hint,
    required this.fn,
  }) : super(key: key);

  final IconData icon;
  final String hint;
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
          hintText: hint,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
