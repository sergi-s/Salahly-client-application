import 'package:easy_localization/easy_localization.dart';
import "package:flutter/material.dart";
import 'package:go_router/go_router.dart';

import 'package:slahly/classes/firebase/roadsideassistance/roadsideassistance.dart';
import 'package:slahly/classes/provider/rsadata.dart';
import 'package:slahly/utils/constants.dart';

import '../../classes/provider/app_data.dart';

//Dialogs
void confirmCancellation(context, ref) {
  RSANotifier rsaNotifier = ref.watch(rsaProvider.notifier);

  showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            title: Text("are_you_sure".tr()),
            content: Text("confirm_cancellation".tr()),
            actions: <Widget>[
              ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel".tr())),
              ElevatedButton(
                  onPressed: () async {
                    //Cancel RSA request
                    //From State Management and Firebase
                    print("CANCEL1");
                    rsaNotifier.cancelRequest();
                    ref.watch(salahlyClientProvider.notifier).deAssignRequest();
                    print("CANCEL2");
                    context.pop();
                  },
                  child: Text("confirm".tr()))
            ],
          ));
}
