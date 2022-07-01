import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:slahly/classes/firebase/roadsideassistance/roadsideassistance.dart';
import 'package:slahly/widgets/dialogues/rating.dart';
import 'package:slahly/widgets/global_widgets/app_bar.dart';

class RequestFullDataScreen extends StatefulWidget {
  RequestFullDataScreen({required this.rsa});

  static const routeName = "/roadsideassistantfulldata";
  RSA rsa;

  @override
  State<RequestFullDataScreen> createState() => _RequestFullDataScreenState();
}

class _RequestFullDataScreenState extends State<RequestFullDataScreen> {
  late RSA rsa;

  @override
  void initState() {
    rsa = widget.rsa;
    super.initState();
  }
  Widget personDetailCard(RSA rsa) {

    return Container(
      // height: MediaQuery
      //     .of(context)
      //     .size.height*0.6,
      alignment: Alignment.center,
      child: Card(
        color: Colors.grey[100],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Text(RSA.requestTypeToString(widget.rsa.requestType!) +" "+((rsa.user!.id == FirebaseAuth.instance.currentUser!.uid)
                          ? "you".tr()
                          : ""),
                  style: const TextStyle(
                      color: Color(0xff193566),
                      fontWeight: FontWeight.bold,
                      fontSize: 24)),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              CircleAvatar(
                backgroundImage: NetworkImage(
                    (rsa.user != null && rsa.user!.avatar != null)
                        ? rsa.user!.avatar!
                        : ""),
                radius: MediaQuery.of(context).size.height * 0.05,
              ),
              Text(
                "client".tr(),
                style: const TextStyle(
                    color: Color(0xff193566),
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
              (rsa.user != null)
                  ? ListTile(
                leading: const Padding(
                    padding: EdgeInsets.only(right: 10.0),
                    child: Icon(CupertinoIcons.profile_circled,
                        color: Color(0xff97a7c3), size: 40)),
                title: Padding(
                  padding: const EdgeInsets.only(
                      top: 10.0, bottom: 6.0, right: 8.0),
                  child: Text((rsa.user!.name ?? "client_name".tr()) + " ",
                      textScaleFactor: 1.1,
                      style: const TextStyle(
                          color: Color(0xff193566),
                          fontWeight: FontWeight.bold)),
                ),
              )
                  : Container(),
              (rsa.car != null)
                  ? ListTile(
                leading: const Padding(
                    padding: EdgeInsets.only(
                        top: 10.0, bottom: 15.0, right: 10.0),
                    child: Icon(CupertinoIcons.car_detailed,
                        color: Color(0xff97a7c3), size: 39)),
                title: Padding(
                  padding: const EdgeInsets.only(top: 6.0, bottom: 6.0),
                  child: Text(rsa.car!.model ?? 'Car Type',
                      textScaleFactor: 1.1,
                      style: const TextStyle(
                          color: Color(0xff193566),
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left)
                      .tr(),
                ),
              )
                  : Container(),
              (rsa.car != null)
                  ? ListTile(
                leading: const Padding(
                    padding: EdgeInsets.only(
                        top: 6.0, bottom: 6.0, right: 8.0),
                    child: Icon(Icons.power_input_outlined,
                        color: Color(0xff97a7c3), size: 40)),
                title: Padding(
                  padding: const EdgeInsets.only(top: 6.0, bottom: 6.0),
                  child: Text(rsa.car!.noPlate ?? 'Car Number',
                      textScaleFactor: 1.1,
                      style: const TextStyle(
                          color: Color(0xff193566),
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left)
                      .tr(),
                ),
              )
                  : Container(),
              // SizedBox(height:MediaQuery.of(context).size.height*0.02),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: const Divider(
                    thickness: 2,
                    color: Color(0xFF193566),
                  )),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              (rsa.mechanic != null) ? mechanicData() : Container(),
              (rsa.towProvider != null) ? towProviderData() : Container(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFFd1d9e6),
      appBar: salahlyAppBar(title: 'requests'.tr()),
      body: SingleChildScrollView(
        child: SizedBox(
          // height: size.height,
          // width: double.infinity,
          child: SingleChildScrollView(
            child: Stack( 
              children: [
                Positioned(
                  child: Column(
                    children: [
                      personDetailCard(rsa),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column mechanicData() {
    return Column(children: [
      (rsa.mechanic!.avatar != null)
          ? CircleAvatar(
              backgroundImage: NetworkImage(rsa.mechanic!.avatar!),
              radius: MediaQuery.of(context).size.height * 0.05,
            )
          : CircleAvatar(
              backgroundImage: const AssetImage("assets/images/mechanic.png"),
              radius: MediaQuery.of(context).size.height * 0.05,
            ),
      const Text(
        "mechanic",
        style: TextStyle(
            color: Color(0xff193566),
            fontWeight: FontWeight.bold,
            fontSize: 15),
      ).tr(),
      Row(
        children: [
          SizedBox(width: MediaQuery.of(context).size.width * 0.7),
          Text(
            (rsa.mechanic!.rating != null)
                ? rsa.mechanic!.rating.toString()
                : "1",
            style: const TextStyle(fontSize: 18, color: Color(0xFFA38A00)),
          ),
        ],
      ),
      ListTile(
        leading: const Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: Icon(CupertinoIcons.profile_circled,
                color: Color(0xff97a7c3), size: 40)),
        title: Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 6.0, right: 8.0),
          child: Text(
              (rsa.mechanic!.name != null)
                  ? rsa.mechanic!.name!
                  : ("Name".tr()),
              textScaleFactor: 1.1,
              style: const TextStyle(
                  color: Color(0xff193566), fontWeight: FontWeight.bold)),
        ),
      ),
      ListTile(
        leading: const Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 15.0, right: 10.0),
            child: Icon(Icons.business_rounded,
                color: Color(0xff97a7c3), size: 43)),
        title: Padding(
          padding: const EdgeInsets.only(top: 6.0, bottom: 6.0),
          child: Text(
                  (rsa.mechanic!.address != null)
                      ? rsa.mechanic!.address!
                      : (rsa.mechanic!.loc!.address != null)
                          ? (rsa.mechanic!.loc!.address!)
                          : "address".tr(),
                  textScaleFactor: 1.1,
                  style: const TextStyle(
                      color: Color(0xff193566), fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left)
              .tr(),
        ),
      ),
      (rsa.semiReport != null)
          ? ListTile(
              leading: const Padding(
                  padding:
                      EdgeInsets.only(top: 10.0, bottom: 15.0, right: 10.0),
                  child: Icon(Icons.bookmark,
                      color: Color(0xff97a7c3), size: 43)),
              title: Padding(
                padding: const EdgeInsets.only(top: 6.0, bottom: 6.0),
                child: Text(rsa.semiReport!,
                        textScaleFactor: 1.1,
                        style: const TextStyle(
                            color: Color(0xff193566),
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left)
                    .tr(),
              ),
            )
          : Container(),

      ///-------------------------------------------
      (rsa.user != null &&
              rsa.user!.id == FirebaseAuth.instance.currentUser!.uid)
          ? Center(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xFF193566),
                  ),
                  onPressed: () {
                    print(rsa.rsaID);
                    // _showRatingDialog(widget.rsa!.towProvider!);

                    rateServiceProvider(rsa.mechanic!, rsa, context);
                  },
                  child: Text('${"review".tr()} ${"mechanic".tr()}')),
            )
          : Container(),

      Container(
        width: MediaQuery.of(context).size.width * 0.6,
        child: const Divider(
          thickness: 2,
          color: Color(0xFF193566),
        ),
      ),
    ]);
  }

  Column towProviderData() {
    return Column(children: [
      (rsa.towProvider!.avatar != null)
          ? CircleAvatar(
              backgroundImage: NetworkImage(rsa.towProvider!.avatar!),
              radius: MediaQuery.of(context).size.height * 0.05,
            )
          : CircleAvatar(
              backgroundImage: const AssetImage("assets/images/Tow.png"),
              radius: MediaQuery.of(context).size.height * 0.05,
            ),
      Text(
        "provider".tr(),
        style: const TextStyle(
            color: Color(0xff193566),
            fontWeight: FontWeight.bold,
            fontSize: 15),
      ),
      Row(
        children: [
          SizedBox(width: MediaQuery.of(context).size.width * 0.7),
          Text(
            (rsa.towProvider!.rating != null)
                ? rsa.towProvider!.rating.toString()
                : "1",
            style: const TextStyle(fontSize: 18, color: Color(0xFFA38A00)),
          ),
        ],
      ),
      ListTile(
        leading: const Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: Icon(CupertinoIcons.profile_circled,
                color: Color(0xff97a7c3), size: 40)),
        title: Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 6.0, right: 8.0),
          child: Text(
              (rsa.towProvider!.name != null)
                  ? rsa.towProvider!.name!
                  : ("Name".tr()),
              textScaleFactor: 1.1,
              style: const TextStyle(
                  color: Color(0xff193566), fontWeight: FontWeight.bold)),
        ),
      ),
      ListTile(
        leading: const Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 15.0, right: 10.0),
            child: Icon(Icons.business_rounded,
                color: Color(0xff97a7c3), size: 43)),
        title: Padding(
          padding: const EdgeInsets.only(top: 6.0, bottom: 6.0),
          child: Text(
                  (rsa.towProvider!.address != null)
                      ? rsa.towProvider!.address!
                      : "address".tr(),
                  textScaleFactor: 1.1,
                  style: const TextStyle(
                      color: Color(0xff193566), fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left)
              .tr(),
        ),
      ),
      (rsa.user != null &&
              rsa.user!.id == FirebaseAuth.instance.currentUser!.uid)
          ? Center(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xFF193566),
                  ),
                  onPressed: () {
                    print(rsa.rsaID);
                    rateServiceProvider(rsa.towProvider!, rsa, context);
                  },
                  child: Text('${"review".tr()} ${"provider".tr()}')),
            )
          : Container(),
      Container(
        width: MediaQuery.of(context).size.width * 0.6,
        child: const Divider(
          thickness: 2,
          color: Color(0xFF193566),
        ),
      ),
    ]);
  }
}
