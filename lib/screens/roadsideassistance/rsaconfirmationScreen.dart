import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slahly/abstract_classes/user.dart';
import 'package:slahly/classes/firebase/roadsideassistance/roadsideassistance.dart';
import 'package:slahly/classes/models/mechanic.dart';
import 'package:slahly/classes/models/towProvider.dart';
import 'package:slahly/classes/provider/rsadata.dart';

class RSAConfirmationScreen extends ConsumerWidget {
  static final routeName = "/rsaconfirmation";
  String problem =
      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a ";
  Mechanic mech = Mechanic(
      name: "name",
      email: "email",
      avatar: "https://www.woolha.com/media/2020/03/eevee.png",
      isCenter: false);
  TowProvider prov = TowProvider(
      name: "name",
      email: "email",
      isCenter: true,
      avatar: "https://www.woolha.com/media/2020/03/eevee.png");

  TextEditingController problemController = TextEditingController();

  // @override
  // void initState() {
  //   problemController.text = problem;
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rsa = ref.watch(rsaProvider);
    final read = ref.read(rsaProvider);
    //final count = ref.watch(counterProvider);
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding:
                EdgeInsets.all(1 / 10.0 * MediaQuery.of(context).size.width),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Center(
                  child: Text(
                    "confirm_or_edit_data".tr(),
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text("problem_description".tr(),style: TextStyle(fontSize: 20),),
                    // SizedBox(height: 10,),
                    TextField(
                      minLines: 3,
                      maxLines: 3,
                      controller: problemController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "problem_description".tr(),
                          hintText: "problem_description".tr(),
                          labelStyle: TextStyle(fontSize: 25)),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "mechanic".tr(),
                      style: TextStyle(fontSize: 20),
                    ),
                    Tilee(usr: ref.watch(rsaProvider.notifier).getMechanic()//ref.watch(rsaProvider).getMechanic()
                    ),

                    ///TODO
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "provider".tr(),
                      style: TextStyle(fontSize: 20),
                    ),
                    TileeProv(usr: rsa.getProvider()),
                  ],
                ),
                ElevatedButton(
                    onPressed: () {
                      // rsa.getMechanic().name  = "MOUZAAA";
                      ref.watch(rsaProvider.notifier).assignMechanic(
                            Mechanic(name: "Moudzzzz",email: "momomo",isCenter: true,
                            rating: 2),
                            false,
                          );

                    },
                    child: Text("Change Mech data"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TileeProv extends StatelessWidget {
  TileeProv({required this.usr});

  TowProvider usr;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: Image.network(usr.avatar.toString()).image,
        radius: 25,
      ),
      title: Text(
        usr.name.toString(),
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      subtitle: Container(
        child: Column(children: [
          Row(
            children: [
              Text(
                usr.email.toString(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Icon(
                (usr.isCenter!) ? Icons.favorite : null,
                color: Colors.pink,
                size: 24.0,
                semanticLabel: 'Text to announce in accessibility modes',
              )
            ],
          ),
          Row(
            children: [
              Container(
                // padding: const EdgeInsets.symmetric(
                //     horizontal: 83.0),
                child: Text(
                  'Rating : ' + usr.rating.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),

              // mechanics[index].isCenter? : null ,
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 100.0,
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text('Confirm'),
                  style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(), primary: Colors.blueGrey),
                ),
              )
            ],
          ),
        ]),
      ),
    );
  }
}

class Tilee extends StatelessWidget {
  Tilee({required this.usr});

  Mechanic usr;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: Image.network(usr.avatar.toString()).image,
        radius: 25,
      ),
      title: Text(
        usr.name.toString(),
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      subtitle: Container(
        child: Column(children: [
          Row(
            children: [
              Text(
                usr.email.toString(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Icon(
                (usr.isCenter!) ? Icons.favorite : null,
                color: Colors.pink,
                size: 24.0,
                semanticLabel: 'Text to announce in accessibility modes',
              )
            ],
          ),
          Row(
            children: [
              Container(
                // padding: const EdgeInsets.symmetric(
                //     horizontal: 83.0),
                child: Text(
                  'Rating : ' + usr.rating.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),

              // mechanics[index].isCenter? : null ,
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 100.0,
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text('Confirm'),
                  style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(), primary: Colors.blueGrey),
                ),
              )
            ],
          ),
        ]),
      ),
    );
  }
}
