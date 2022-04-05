import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:slahly/classes/models/client.dart';
import 'package:slahly/screens/userMangament/addSubowner.dart';

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
            "https://scontent-hbe1-1.xx.fbcdn.net/v/t1.6435-1/79130787_2501294306773024_4727773538419736576_n.jpg?stp=dst-jpg_s320x320&_nc_cat=101&ccb=1-5&_nc_sid=7206a8&_nc_ohc=TStj9OkVc68AX9r5iXm&_nc_ht=scontent-hbe1-1.xx&oh=00_AT85JFYVsgGCK_t9dtbdu0vMH6zliaL5tgiTaIQCtgjJGg&oe=626BF022"),

    Client(
        id: "2",
        name: "Mahmoud Magdy",
        email: "Magdy@gmail.com",
        subscription: SubscriptionTypes.gold,
        phoneNumber: "010292929223",
        address: "MONTAZAA m3omraaaa",
        avatar:
            "https://see.news/wp-content/uploads/2019/09/8872540_1531078574.jpg"),
    // avatar:
    //     "https://scontent.fcai19-5.fna.fbcdn.net/v/t39.30808-6/241676442_4279329582181382_2167552377324842210_n.jpg?_nc_cat=105&ccb=1-5&_nc_sid=09cbfe&_nc_eui2=AeGKq4FMZp3eGePXQ9yrDTBYkTuL3-uGRVeRO4vf64ZFVyifGvoEaCgfgms4jZSbNSNezryRH0GahKxAbVi2v_V5&_nc_ohc=2j1ZPLP0Oe0AX-V7zp-&_nc_ht=scontent.fcai19-5.fna&oh=00_AT8N6VsLIbTZGsJkVnDDHsebygQtlt5Ks1qS1ZTXL_oq0A&oe=6243CF2E"),
    Client(
        id: "55",
        name: "Aya Adel",
        email: "AyaADEL@gmail.com",
        subscription: SubscriptionTypes.gold,
        phoneNumber: "01550123452",
        address: "Miami 45 sedigabrrrr ",
        // avatar: "https://pbs.twimg.com/profile_images/1440433307859111939/mG5NGNHn_400x400.jpg")
        avatar:
// <<<<<<< HEAD
//             "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.egypttoday.com%2FArticle%2F4%2F78359%2FTamer-Hosny-to-break-a-Guinness-World-Record-for-the&psig=AOvVaw1KakqcJ-fDoulAiCEEB-ZN&ust=1648993859676000&source=images&cd=vfe&ved=0CAsQjRxqFwoTCIjo5fzC9fYCFQAAAAAdAAAAABAD")
// =======
            "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.egypttoday.com%2FArticle%2F4%2F78359%2FTamer-Hosny-to-break-a-Guinness-World-Record-for-the&psig=AOvVaw1KakqcJ-fDoulAiCEEB-ZN&ust=1648993859676000&source=images&cd=vfe&ved=0CAsQjRxqFwoTCIjo5fzC9fYCFQAAAAAdAAAAABAD")
// >>>>>>> 931e111d966e6532a25d6451b6fa85ee81a45bd7
  ];

  // Addinfo() {
  //   info.add('mizo');
  //   info.add('7amo');
  //   info.add('tito');
  // }

  Widget showList() {
    return SingleChildScrollView(
        child: Column(children: [
      // <<<<<<< HEAD
      //     Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      //       Text(
      //         "Manage Ownership",
      //         style: TextStyle(fontSize: 35, color: Colors.white),
      //         textAlign: TextAlign.center,
      //       ),
      //     ]),
      //     SizedBox(
      //       height: 150,
      //     ),
      //     ListView.builder(
      //         padding: EdgeInsets.all(17),
      //         shrinkWrap: true,
      //         itemCount: client.length,
      //         itemBuilder: (BuildContext context, index) {
      //           return Column(children: [
      //             Container(
      //                 padding: EdgeInsets.all(5.0),
      //                 child: rowItem(context, index))
      //           ]);
      //         }),
      //     ]));
      // =======
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Text(
          "Manage Ownership",
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
          itemCount: client.length,
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
          return await showAlertbox(context, client[index], index);
        },
        key: ValueKey(client[index]),
        // key: Key(randomNumber.toString()),
        onDismissed: (direction) {
          // _deleteRecord(k)
          var info = this.client[index];
        },
        background: deleteBgItem(),
        child: Container(
          height: 100,
          child: Card(
            child: ListTile(
              leading: CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(
                  client[index].avatar.toString(),
                ),
                backgroundColor: Colors.blue,
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
