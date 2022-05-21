import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:slahly/abstract_classes/user.dart';
import 'package:slahly/classes/firebase/roadsideassistance/roadsideassistance.dart';

void rateServiceProvider(UserType toBeRated, RSA rsa, BuildContext context) {
  // print("idddddddddd-> ${toBeRated.id!}");
  final _ratingDialog = RatingDialog(
    title: const Text('ratePlease').tr(),
    message: Text('Rate Your ${toBeRated.getUserType()}'),
    image: Image.asset(
      "assets/images/rating1.jpeg",
      height: 100,
    ),
    submitButtonText: 'Submit'.tr(),
    onCancelled: () => print('cancelled'),
    onSubmitted: (response) async {
      print('rating: ${response.rating}, '
          'comment: ${response.comment}');

      String childWho = (toBeRated.type == Type.mechanic)
          ? "mechanicsRequests"
          : "providersRequests";

      DataSnapshot old = await FirebaseDatabase.instance
          .ref()
          .child(childWho)
          .child(toBeRated.id!)
          .child(rsa.rsaID!)
          .child("rating")
          .get();

      await FirebaseDatabase.instance
          .ref()
          .child(childWho)
          .child(toBeRated.id!)
          .child(rsa.rsaID!)
          .child("rating")
          .set({"rating": response.rating, "review": response.comment});

      DataSnapshot ds = await FirebaseDatabase.instance
          .ref()
          .child("users")
          .child(toBeRated.id!)
          .child("rating")
          .get();

      int count = 0;
      if ((ds.child("count").value) != null) {
        count = int.parse((ds.child("count").value).toString());
      }

      double sum = 0;
      if ((ds.child("sum").value) != null) {
        sum = double.parse((ds.child("sum").value).toString());
      }
      if (old.value != null) {
        print("Test${old.child("rating").value}");
        sum -= double.parse(old.child("rating").value.toString());
        count -= 1;
      }
      sum += response.rating;
      count += 1;

      await FirebaseDatabase.instance
          .ref()
          .child("users")
          .child(toBeRated.id!)
          .child("rating")
          .set({"sum": sum, "count": count});
    },
  );

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => _ratingDialog,
  );
}
