import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:slahly/main.dart';
import 'package:slahly/classes/models/client.dart';

class ManageSubowner extends StatelessWidget {
  static final routeName = "/manageSubowner";

  List<String> info = ['mizo', '7amo', '7amama'];
  List<Client> client = [
    Client(
        name: "Sergi Samir",
        email: "Sergi@yahoo.com",
        subscription: SubscriptionTypes.gold,
        phoneNumber: "015234451112",
        address: "Smouha",
        avatar: ""),
    Client(
        name: "Mahmoud Magdy",
        email: "Magdy@gmail.com",
        subscription: SubscriptionTypes.gold,
        phoneNumber: "010292929223",
        address: "MONTAZAA",
        avatar: ""),
    Client(
        name: "Aya Adel",
        email: "AyaADEL@gmail.com",
        subscription: SubscriptionTypes.gold,
        phoneNumber: "01550123452",
        address: "Miamisad ",
        avatar: "")
  ];

  // Addinfo() {
  //   info.add('mizo');
  //   info.add('7amo');
  //   info.add('tito');
  // }

  Widget showList() {
    return ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: client.length,
        itemBuilder: (BuildContext context, index) {
          return rowItem(context, index);
        });
  }

  Widget rowItem(context, index) {
    return Dismissible(
        confirmDismiss: (DismissDirection) async {
          return await showAlertbox(context, info[index], index);
        },
        key: Key(info[index]),
        onDismissed: (direction) {
          var info = this.client[index];
        },
        background: deleteBgItem(),
        child: Card(
          child: ListTile(
            leading: CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage(
                client[index].avatar.toString(),
              ),
            ),
            title: Text(client[index].name.toString(),
                style: TextStyle(fontSize: 18, color: Colors.black)),
            subtitle: Column(
              children: [
                Row(
                  children: [],
                ),
                Row(
                  children: [
                    Text(client[index].phoneNumber.toString(),
                        style: TextStyle(fontSize: 18, color: Colors.black)),
                  ],
                )
              ],
            ),
          ),
        ));
  }
  //
  // Widget rowItem(context, info, index) {
  //   // var info = this.info[index];
  //   return Expanded(
  //     child: Row(
  //       children: [
  //         Card(
  //           child: ListTile(
  //             title: Text(info),
  //           ),
  //         ),
  //         deleteBgItem()
  //       ],
  //     ),
  //   );
  // }

  Future showAlertbox(context, info, index) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Result'),
        content: Text('are u sure to delete this user'),
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);

                // ShowSnackbar(context, info, index);
              },
              child: Text('Confirm')),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Back'))
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
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
        title: Center(
          child: Text('Manage Ownership',
              style: TextStyle(fontSize: 30, color: Colors.black)),
        ),
      ),
      body: Container(
        child: showList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/addSubowner');
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
//
// class Dismiss extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Dismissible(
//         key: Key(),
//         child: Card(
//           child: ListTile(
//             title: Text(info),
//           ),
//         ),
//       confirmDismiss: (DismissDirection direction) async {
//         return await showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: const Text("Confirm"),
//               content: const Text("Are you sure you wish to delete this item?"),
//               actions: <Widget>[
//                 FlatButton(
//                     onPressed: () => Navigator.of(context).pop(true),
//                     child: const Text("DELETE")
//                 ),
//                 FlatButton(
//                   onPressed: () => Navigator.of(context).pop(false),
//                   child: const Text("CANCEL"),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
// }
