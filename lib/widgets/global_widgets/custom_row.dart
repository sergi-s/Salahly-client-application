import 'package:flutter/material.dart';

Widget customRow({String? title, String? content}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          title!,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          content!,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    ],
  );
}
