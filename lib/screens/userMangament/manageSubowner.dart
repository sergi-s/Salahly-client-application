import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:slahly/classes/models/client.dart';
import 'package:slahly/screens/userMangament/addSubowner.dart';

import '../../main.dart';

class ManageSubowner extends ConsumerStatefulWidget {
  static final routeName = "/manageSubowner";
  String? chasis;

  ManageSubowner({this.chasis});

  @override
  _State createState() => _State();
}

class _State extends ConsumerState<ManageSubowner> {
  @override
  void initState() {
    showSubowner(widget.chasis);
    super.initState();
  }

  List<Client> subowners = [];

  // List<String> info = ['mizo', '7amo', '7amama'];
  // String? name, email, avatar, phone;
  // List emails = [];
  // List name = [];
  // List avatar = [];
  // List phone = [];

  // Addinfo() {
  Widget showList() {
    return SingleChildScrollView(
        child: Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Text(
          "Manage_Ownership".tr(),
          style: TextStyle(fontSize: 35, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ]),
      SizedBox(
        height: 150,
      ),
      ListView.builder(
          padding: EdgeInsets.all(17),
          shrinkWrap: true,
          itemCount: subowners.length,
          itemBuilder: (BuildContext context, index) {
            return Column(children: [
              Container(
                  padding: EdgeInsets.all(5.0), child: rowItem(context, index))
            ]);
          }),
    ]));
  }

  Widget rowItem(context, index) {
    // Random random = new Random();
    // int randomNumber = random.nextInt(1000000);
    // Key k = Key(randomNumber.toString());
    return Dismissible(
        confirmDismiss: (DismissDirection) async {
          return await showAlertbox(context, subowners[index], index);
        },
        key: ValueKey(subowners),
        // key: Key(randomNumber.toString()),
        onDismissed: (direction) {
          // _deleteRecord(k)
          var info = this.subowners[index];
        },
        background: deleteBgItem(),
        child: Container(
          height: 100,
          child: Card(
            child: ListTile(
              leading: CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(
                  subowners[index].avatar.toString(),
                ),
                backgroundColor: Colors.blue,
              ),
              title: Text(subowners[index].name.toString(),
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold)),
              subtitle: Column(
                children: [
                  Row(
                    children: [
                      Text(subowners[index].email.toString(),
                          style: TextStyle(fontSize: 17, color: Colors.black)),
                      TextButton(
                          onPressed: () {
                            removeSubowner(widget.chasis,
                                subowners[index].email.toString());
                          },
                          child: Text("delete"))
                    ],
                  ),
                  Row(
                    children: [
                      Text(subowners[index].address.toString(),
                          style: TextStyle(fontSize: 17, color: Colors.black)),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }

  //
  Future showAlertbox(context, info, index) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Result'.tr()),
        content: Text('are_u_sure_to_delete_this_user'.tr()),
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);

                // ShowSnackbar(context, info, index);
              },
              child: Text('Confirm'.tr())),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('back'.tr()))
        ],
      ),
    );
  }

  ShowSnackbar(context, info, index) {
    return Scaffold.of(context).showSnackBar(SnackBar(
      content: Text('$info deleted '),
    ));
  }

  DatabaseReference car_userRef = FirebaseDatabase.instance.ref().child("user");

  _deleteRecord(var key) async {
    await car_userRef.child(key).remove();
  }

  // UndoDelete(index, info) {}
  Widget deleteBgItem() {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 20),
      color: Colors.red,
      child: Icon(
        Icons.delete_forever,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // showSubowner(widget.chasis);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFd1d9e6),
      appBar: AppBar(
        elevation: 0,
        bottomOpacity: 0.0,
        backgroundColor: const Color(0xFF193566),
        // title: Center(
        //   child: Text('Manage Ownership',
        //       style: TextStyle(fontSize: 30, color: Colors.black)),
        // ),
        title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const []),
      ),
      body: CustomPaint(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: showList(),
        ),
        painter: HeaderCurvedContainer(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(AddSubowner.routeName);
        },
        child: const Icon(Icons.add),
        backgroundColor: Color(0xFF193566),
      ),
    );
  }

  removeSubowner(chasis, email) async {
    DatabaseReference carsUsers = dbRef.child("cars_users").child(chasis);
    DatabaseReference users = dbRef.child("users").child("clients");
    users.orderByChild("email").equalTo(email).once().then((event) {
      final dataSnapshot = event.snapshot;
      print("idddd");
      print(dataSnapshot.value);
      dataSnapshot.children.forEach((element) {
        print(element.key);
        carsUsers
            .child(FirebaseAuth.instance.currentUser!.uid)
            .child(element.key.toString())
            .remove();
        setState(() {
          showSubowner(chasis);
        });
      });
    });
  }

  showSubowner(chasis) async {
    subowners = [];
    DatabaseReference carsUsers = dbRef.child("cars_users").child(chasis);
    DatabaseReference users = dbRef.child("users").child("clients");

    carsUsers
        .child(FirebaseAuth.instance.currentUser!.uid)
        .orderByValue()
        .equalTo(true)
        .once()
        .then((event) {
      final dataSnapshot = event.snapshot;

      dataSnapshot.children.forEach((subownerSnapShot) async {
        print("subownerssss =>>>${subownerSnapShot.key}");
        users.child(subownerSnapShot.key.toString()).once().then((event) {
          final dataSnapshot = event.snapshot;
          print("read" + dataSnapshot.value.toString());
          print(dataSnapshot.child("name").value.toString());
          setState(() {
            subowners.add(Client(
                name: dataSnapshot.child("name").value.toString(),
                email: dataSnapshot.child("email").value.toString(),
                avatar: dataSnapshot.child("image").value.toString(),
                address: dataSnapshot.child("address").value.toString()));
          });
          print(subowners);

          // print(dataSnapshot.child("email").value.toString());
        });

        // idss.add(subownerSnapShot.key.toString());
      });

      // print(idss);
    });
  }
}
//

class HeaderCurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = const Color(0xFF193566);
    Path path = Path()
      ..relativeLineTo(0, 90)
      ..quadraticBezierTo(size.width / 2, 150, size.width, 90)
      ..relativeLineTo(0, -90)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
