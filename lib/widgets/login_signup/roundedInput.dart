import 'package:flutter/material.dart';
import 'package:slahly/widgets/login_signup/Input_container.dart';

class RounedInput extends StatefulWidget {
  RounedInput({
    Key? key,
    required this.icon,
    required this.hint,
    required this.fn,
  }) : super(key: key);

  final IconData icon;
  final String hint;
  final Function fn;

  @override
  State<RounedInput> createState() => _RounedInputState();
}

class _RounedInputState extends State<RounedInput> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return InputContainer(
      child: TextField(
        onChanged: (value) {
          widget.fn(value);
        },
        controller: _textEditingController,
        cursorColor: Colors.blue,
        decoration: InputDecoration(
          icon: Icon(
            widget.icon,
            color: Colors.blue,
          ),
          hintText: widget.hint,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
