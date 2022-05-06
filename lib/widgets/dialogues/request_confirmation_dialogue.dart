import "package:flutter/material.dart";

import 'package:slahly/utils/constants.dart';

void requestConfirmationDialogue(context,
    {required content,
    required List<Widget> titleChildren,
    required List<Widget> actionChildren}) {
  showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(dialogRadius),
          ),
          title: Container(
            alignment: Alignment.center,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: titleChildren),
          ),
          content: content,
          actions: actionChildren));
}
