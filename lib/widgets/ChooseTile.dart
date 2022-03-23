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
      child: GestureDetector(
        onTap: () {
          print('card tapped');
        },
        child: Card(
          elevation: 5,
          child: Column(
            children: [
              Flexible(
                child: ListTile(
                  horizontalTitleGap: 20.0,
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(
                      avatar,
                    ),
                    radius: 30,
                  ),
                  title: Text(
                    name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                  subtitle: Column(children: [
                    Row(
                      children: [
                        Text(
                          type != Type.mechanic
                              ? ""
                              : (isCenter)
                                  ? ("center".tr())
                                  : ("mechanic".tr()),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
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
                                  fontSize: 16),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
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
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            address,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                        // SizedBox(height: 20),
                      ],
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
