import 'package:flutter/material.dart';
import 'package:slahly/widgets/login_signup/Input_container.dart';

class RounedPasswordInput extends StatefulWidget {
  RounedPasswordInput({
    Key? key,
    required this.hint,
    required this.function,
  }) : super(key: key);

  final String hint;
  final Function function;

  @override
  State<RounedPasswordInput> createState() => _RounedPasswordInputState();
}

class _RounedPasswordInputState extends State<RounedPasswordInput> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return InputContainer(
      child: TextField(
        onChanged: (value) {
          widget.function(value);
        },
        controller: _textEditingController,
        cursorColor: Colors.blue,
        obscureText: true,
        decoration: InputDecoration(
          icon: Icon(
            Icons.lock,
            color: Color(0xFF193566),
          ),
          hintText: widget.hint,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
