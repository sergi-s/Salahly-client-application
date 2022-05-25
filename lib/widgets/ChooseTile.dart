import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:slahly/abstract_classes/user.dart';

class ChooseTile extends StatelessWidget {
  String? email;
  String? avatar;
  String? phone;
  String? name;
  bool? isCenter;
  double? rating;
  String? address;
  Type? type;
  String? estimatedTime;

  ChooseTile(
      {this.email,
      this.avatar,
      this.phone,
      this.name,
      this.address,
      this.type,
      this.isCenter,
      this.rating,
      this.estimatedTime});

  @override
  Widget build(BuildContext context) {
    print("yeeeeeeeeeeeeeeeeeeeeeeessssssssssssss ${estimatedTime}");

    return SizedBox(
      height: 135,
      width: 100,
      child: Card(
        // color: Color(0xFFd1d9e6), //#D3D3D3 Color(0xFFf7f7f7)
        // shape: RoundedRectangleBorder(
        //     borderRadius: new BorderRadius.circular(30.0)),
        elevation: 5,
        color: const Color(0xFFF2F1F0),
        child: Column(
          children: [
            Flexible(
              child: ListTile(
                // horizontalTitleGap: 50.0,
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                    avatar ??
                        "https://thumbs.dreamstime.com/b/default-avatar-photo-placeholder-profile-image-default-avatar-photo-placeholder-profile-image-eps-file-easy-to-edit-124557892.jpg",
                  ),
                  radius: 30,
                ),
                title: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    name ?? "NAME",
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
                              : (isCenter ?? false)
                              ? ("center".tr())
                              : ("mechanic".tr()),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Rating : ${rating.toString()}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            type != Type.provider
                                ? ("${'Address'.tr()}:\t" +
                                    (address ?? 'address'))
                                : '',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        )
                      ],
                    ),
                    (estimatedTime != null)
                        ? Row(
                            children: [
                              Flexible(
                                child: Text(
                                  ("${'Estimated Time'.tr()}:\t" +
                                      (estimatedTime ?? "--")),
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              )
                            ],
                          )
                        : Container(),
                  ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
