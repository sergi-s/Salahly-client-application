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
        id: "1",
        name: "Sergi Samir",
        email: "Sergi@yahoo.com",
        subscription: SubscriptionTypes.gold,
        phoneNumber: "015234451112",
        address: "Smouha",
        avatar:
            "https://scontent.fcai19-5.fna.fbcdn.net/v/t1.6435-1/79130787_2501294306773024_4727773538419736576_n.jpg?stp=dst-jpg_s320x320&_nc_cat=101&ccb=1-5&_nc_sid=7206a8&_nc_eui2=AeFR7t8qkSCbSzIwQrEdNmypdm9IP7mRJk12b0g_uZEmTfsvFBUmIrMyx0CDyUtb-MtPfZLzIT610DV62umXiaf4&_nc_ohc=JtjiUUDQ8fEAX-9QUIY&_nc_ht=scontent.fcai19-5.fna&oh=00_AT-EJxgm6ArplPwzkFIR0YPf7NfIxtRvMyY4CtrdnzZmRg&oe=62640722"),
    Client(
        id: "2",
        name: "Mahmoud Magdy",
        email: "Magdy@gmail.com",
        subscription: SubscriptionTypes.gold,
        phoneNumber: "010292929223",
        address: "MONTAZAA m3omraaaa",
        avatar:
            "https://scontent.fcai19-5.fna.fbcdn.net/v/t39.30808-6/241676442_4279329582181382_2167552377324842210_n.jpg?_nc_cat=105&ccb=1-5&_nc_sid=09cbfe&_nc_eui2=AeGKq4FMZp3eGePXQ9yrDTBYkTuL3-uGRVeRO4vf64ZFVyifGvoEaCgfgms4jZSbNSNezryRH0GahKxAbVi2v_V5&_nc_ohc=2j1ZPLP0Oe0AX-V7zp-&_nc_ht=scontent.fcai19-5.fna&oh=00_AT8N6VsLIbTZGsJkVnDDHsebygQtlt5Ks1qS1ZTXL_oq0A&oe=6243CF2E"),
    Client(
        id: "55",
        name: "Aya Adel",
        email: "AyaADEL@gmail.com",
        subscription: SubscriptionTypes.gold,
        phoneNumber: "01550123452",
        address: "Miami 45 sedigabrrrr ",
        avatar:
            "https://scontent.fcai19-5.fna.fbcdn.net/v/t1.6435-1/120053014_3312976808750538_4906589982223067147_n.jpg?stp=dst-jpg_p320x320&_nc_cat=103&ccb=1-5&_nc_sid=7206a8&_nc_eui2=AeHMNvNnR3nl2ObBrXKSD-8UExuDCTt1Yb0TG4MJO3VhvTCrljjmoH9HIzkF3QGEe1f295mLUxwtP4hMO-wnXoB6&_nc_ohc=_H9LRDfeyAEAX-73M7h&_nc_ht=scontent.fcai19-5.fna&oh=00_AT-r5LC5Jqzt7LOR0UyKSoIN3rF9ogcG7d2kDrz75N7xIA&oe=62665C22")
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
          return await showAlertbox(context, client[index], index);
        },
        key: Key(client[index].id.toString()),
        onDismissed: (direction) {
          var info = this.client[index];
        },
        background: deleteBgItem(),
        child: Card(
          child: ListTile(
            leading: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(
                client[index].avatar.toString(),
              ),
              backgroundColor: Colors.transparent,
            ),
            title: Text(client[index].name.toString(),
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold)),
            subtitle: Column(
              children: [
                Row(
                  children: [
                    Text(client[index].email.toString(),
                        style: TextStyle(fontSize: 17, color: Colors.black))
                  ],
                ),
                Row(
                  children: [
                    Text(client[index].phoneNumber.toString(),
                        style: TextStyle(fontSize: 17, color: Colors.black)),
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
