import 'package:easy_localization/easy_localization.dart';
import "package:flutter/material.dart";
import 'package:go_router/go_router.dart';
import 'package:slahly/classes/provider/app_data.dart';
import 'package:slahly/classes/provider/rsadata.dart';

import 'package:slahly/screens/homepage.dart';

//TODO refactor it so it will be reused if needed
void allRejected(context, ref, String who) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("${who}Rejected").tr(),
              ],
            ),
            content: Text("${who}RejectedDescription").tr(),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);

                  ref.watch(rsaProvider.notifier).cancelRequest();
                  ref.watch(salahlyClientProvider.notifier).deAssignRequest();

                  context.go(HomePage.routeName);
                },
                child: const Text("goToHomePage").tr(),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("keepWaiting").tr(),
              ),
            ],
          ));
}
