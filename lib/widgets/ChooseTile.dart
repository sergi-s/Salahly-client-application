import 'package:flutter/material.dart';
import 'package:slahly/abstract_classes/user.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';

class ChooseTile extends StatelessWidget {
  String email;
  String avatar;
  String phone;
  String name;
  bool isCenter;
  String address;
  Type type;

  ChooseTile(this.email, this.avatar, this.phone, this.name, this.address,
      this.type, this.isCenter);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      width: 100,
      child: GestureDetector(
        onTap: () {
          print('card tapped');
        },
        child: Card(
          // color: Color(0xFFd1d9e6), //#D3D3D3 Color(0xFFf7f7f7)
          // shape: RoundedRectangleBorder(
          //     borderRadius: new BorderRadius.circular(30.0)),
          elevation: 5,
          color: Color(0xFFF2F1F0),
          child: Column(
            children: [
              Flexible(
                child: ListTile(
                  // horizontalTitleGap: 50.0,
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      avatar,
                    ),
                    radius: 30,
                  ),
                  title: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(left: 0),
                    child: Column(children: [
                      Row(
                        children: [
                          Text(
                            type != Type.mechanic
                                ? ""
                                : (isCenter)
                                ? ("center".tr())
                                : ("mechanic".tr()),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Clipboard.setData(ClipboardData(text: phone));
                              },
                              label: Text(
                                phone,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xFFff193566).withOpacity(0),
                                elevation: 0,
                                animationDuration: Duration.zero,
                              ),
                              icon: const Icon(
                                Icons.copy,
                                color: Colors.black,
                              ),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: const [
                          Text(
                            'Rating : 4.8',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              type != Type.provider ? address : "",
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                          // SizedBox(height: 20),
                        ],
                      ),
                    ]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
