import 'package:firebase_auth/firebase_auth.dart';
import 'package:slahly/classes/provider/user_data.dart';
import 'package:slahly/main.dart';

getUserData(ref) async {
  dbRef
      .child("users")
      .child("clients")
      .child(FirebaseAuth.instance.currentUser!.uid)
      .once()
      .then((event) {
    final dataSnapshot = event.snapshot;
    print("read" + dataSnapshot.value.toString());
    var data = dataSnapshot.value as Map;
    ref.watch(userProvider.notifier).assignEmail(data["email"]);
    ref.watch(userProvider.notifier).assignName(data["name"]);
    ref.watch(userProvider.notifier).assignPhoneNumber(data["phoneNumber"]);
    ref.watch(userProvider.notifier).assignAvatar(data["image"]);
    ref.watch(userProvider.notifier).assignAddress(data["address"]!);
    // print(ref.watch(userProvider).avatar);
  });
}
