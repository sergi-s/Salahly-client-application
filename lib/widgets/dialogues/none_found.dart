import 'package:easy_localization/easy_localization.dart';
import "package:flutter/material.dart";

void noneFound(
  context, {
  required bool who,
}) {
  showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              title: const Text("sorry").tr(),
              content:
                  Text(who ? "didNotFindMechanic" : "didNotFindProvider").tr(),
              actions: [
                ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("ok").tr())
              ]));
}
