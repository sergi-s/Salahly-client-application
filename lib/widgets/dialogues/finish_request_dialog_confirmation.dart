import 'package:easy_localization/easy_localization.dart';
import "package:flutter/material.dart";
import 'package:go_router/go_router.dart';
import 'package:slahly/classes/provider/rsadata.dart';
import 'package:slahly/screens/homepage.dart';
import 'package:slahly/utils/constants.dart';
import 'package:slahly/classes/provider/app_data.dart';

//Dialogs
void confirmFinish(context, ref) {
  RSANotifier rsaNotifier = ref.watch(rsaProvider.notifier);

  showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(dialogRadius),
            ),
            title: Text("are_you_sure".tr()),
            content: Text("finish request"),
            actions: <Widget>[
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xFF193566),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel".tr())),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xFF193566),
                  ),
                  onPressed: () async {
                    ref.watch(rsaProvider.notifier).finishRequest();
                    ref.watch(salahlyClientProvider.notifier).deAssignRequest();
                    context.pop();
                    context.go(HomePage.routeName);
                  },
                  child: Text("confirm".tr()))
            ],
          ));
}
