import 'package:easy_localization/easy_localization.dart';
import "package:flutter/material.dart";
import 'package:slahly/classes/firebase/roadsideassistance/roadsideassistance.dart';
import 'package:slahly/widgets/location/finalScreen.dart';

class RequestTile extends StatelessWidget {
  RequestTile({Key? key, required this.rsa}) : super(key: key);
  RSA rsa;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(14),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              blurRadius: 10.0,
            ),
          ],
          borderRadius: BorderRadius.circular(8.0),
          color: const Color(0xFFd1d9e6),
        ),
        child: SingleChildScrollView(
          child: ListTile(
            leading: CircleAvatar(
                backgroundImage: NetworkImage((rsa.mechanic == null)
                    ? ""
                    : rsa.mechanic!.avatar.toString())),
            // Text(ongoingRequestsList[index].car!.noPlate),
            title: Row(
              children: [
                Text(
                  (rsa.mechanic == null)
                      ? "${'searching'.tr()}..."
                      : rsa.mechanic!.name.toString().capitalize(),
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF193566)),
                ),
                const Expanded(
                  child: Divider(
                    thickness: 0,
                  ),
                ),
                (rsa.mechanic != null && rsa.mechanic!.rating != null)
                    ? Text(
                        rsa.mechanic!.rating.toString().capitalize(),
                        style: const TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(
                              255,
                              127,
                              97,
                              11,
                            )),
                      )
                    : Container(),
                const SizedBox(height: 50),
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.all(0),
              child: Column(children: [
                Row(
                  children: [
                    Text(
                      "at".tr() + " ",
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      (rsa.mechanic != null && rsa.mechanic!.address != null)
                          ? rsa.mechanic!.address.toString().capitalize()
                          : "...",
                      style: const TextStyle(
                          fontSize: 18,
                          color: Color(0xFF193566),
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Text(
                      "workingOn".tr() + " ",
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Text(rsa.car!.noPlate.toString(),
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF193566))),
                    const Expanded(
                        child: Divider(
                      thickness: 0,
                    )),
                    Text(
                      rsa.car!.getCarAccess().toString(),
                    ).tr(),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Text("request".tr() + " ",
                        style: const TextStyle(
                          fontSize: 18,
                        )),
                    Text(
                      RSA.requestTypeToString(rsa.requestType!),
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF193566)),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                (rsa.createdAt == null)
                    ? Container()
                    : Row(
                        children: [
                          Text("When".tr() + " ",
                              style: const TextStyle(
                                fontSize: 18,
                              )),
                          Text(
                            DateFormat('yyyy-MM-dd – kk:mm')
                                .format(rsa.createdAt!),
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF193566)),
                          ),
                        ],
                      ),
                const SizedBox(height: 5),
                const SizedBox(height: 5),
                (rsa.semiReport != null)
                    ? Row(
                        children: [
                          Text(
                            "initialReport".tr() + " ",
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          Flexible(
                            flex: 5,
                            child: Text(
                              rsa.semiReport.toString(),
                              style: const TextStyle(
                                  fontSize: 18,
                                  color: Color(0xFF193566),
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      )
                    : Container(),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
