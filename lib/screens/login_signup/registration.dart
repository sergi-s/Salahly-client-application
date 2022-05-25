import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:go_router/go_router.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:slahly/classes/firebase/firebase.dart';
import 'package:slahly/classes/models/location.dart';
import 'package:slahly/main.dart';
import 'package:slahly/screens/homepage.dart';
import 'package:slahly/widgets/login_signup/roundedInput.dart';
import 'package:slahly/widgets/login_signup/text_input.dart';

import '../../abstract_classes/user.dart';
import '../../classes/models/client.dart';
import '../homescreen.dart';
import 'map.dart';

class Registration extends StatefulWidget {
  static final routeName = "/registrationscreen";

  Registration({
    Key? key,
    required this.emailobj,
  }) : super(key: key);
  final String emailobj;

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  FirebaseCustom fb = FirebaseCustom();
  DatabaseReference user = dbRef.child("users").child("clients");
  DateTime? _selectedDate;
  String name = "";
  String phonenumber = "";
  String address = "";
  Type? _userTypeEnum;
  String gender = "";
  String imageUrl = "";
  String _verticalGroupValue = "";
  String? getlocation;
  List<String> _status = ["female".tr(), "male".tr()];
  File? _image;
  String _imagePath = '';
  File? url;
  CustomLocation? locationObject;

  // String gender = "";
  updateusername(String u) {
    name = u;
  }

  updatephonenumber(String pn) {
    phonenumber = pn;
  }

  updateaddress(String adr) {
    address = adr;
  }

  updategender(String gn) {
    gender = gn;
  }

  // updateage(String age) {
  registerOnPress(BuildContext context) async {
    // if (!Validator.usernameValidator(username)) {
    //   return ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(
    //           content: Text('Invalid username!! Please try again')));
    // }
    // if (!Validator.phoneValidator(phonenumber)) {
    //   return ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(
    //           content: Text('Invalid phonenumber!! Please try again')));
    // }
    // if (!Validator.ageValidator(age)) {
    //   return ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(
    //           content:
    //           Text('Invalid age!! Please try again')));
    // }
    Gender g = Gender.none;
    if (gender == "male".tr()) {
      g = Gender.male;
    } else if (gender == "female".tr()) {
      g = Gender.female;
    }
    Client client = Client(
        name: name,
        email: widget.emailobj,
        address: getlocation.toString(),
        birthDay: _selectedDate,
        gender: g,
        phoneNumber: phonenumber,
        subscription: SubscriptionTypes.silver);

    //
    bool check = await fb.registration(client);
    if (check) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text(' Sucessfull ')));
      context.go(HomePage.routeName);
    } else {
      return ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Failed to Register!!')));
    }
  }

  _datePicker(BuildContext context) async {
    DateTime? _pickerDate = await showDatePicker(
        context: context,
        initialDate: DateTime(DateTime.now().year - 16),
        firstDate: DateTime(DateTime.now().year - 100),
        lastDate: DateTime(DateTime.now().year - 16));
    if (_pickerDate != null) {
      setState(() {
        _selectedDate = _pickerDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: const Color(0xFFd1d9e6),
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: const Color(0xFFd1d9e6),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Color(0xFF193566),
            ),
            onPressed: () {},
          ),
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(""),
            Text(
              "Registration".tr(),
              style: TextStyle(
                fontSize: 22,
                letterSpacing: 1,
                color: Color(0xFF193566),
                fontWeight: FontWeight.w600,
              ),
            ),
            Image.asset(
              'assets/images/logodark.png',
              fit: BoxFit.contain,
              height: 32,
            ),
          ]),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  Stack(
                    children: [
                      GestureDetector(
                        child: Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                              border: Border.all(
                                width: 2,
                                color: Color(0xFF193566),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  color: Colors.black.withOpacity(0.1),
                                  offset: Offset(0, 10),
                                ),
                              ],
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage("assets/images/user.png"))),
                          child: CachedNetworkImage(
                            imageUrl: _imagePath,
                            width: 128,
                            height: 128,
                            fit: BoxFit.cover,
                            imageBuilder: (context, imageProvider) => Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.cover),
                              ),
                            ),
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                        onTap: () {},
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(width: 1, color: Colors.white),
                              color: const Color(0xFF193566)),
                          child: GestureDetector(
                            onTap: () {
                              chooseImage();
                            },
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // SizedBox(height:180),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  RounedInput(
                    icon: Icons.face,
                    fn: (v) {
                      updateusername(v);
                    },
                    hint: 'Name',
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  RounedInput(
                    icon: Icons.phone,
                    fn: updatephonenumber,
                    hint: 'Phone',
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  MyInput(
                    hint: _selectedDate != null
                        ? DateFormat.yMMMEd().format(_selectedDate!)
                        : 'Birthdate',
                    fn: () {},
                    widget: IconButton(
                      onPressed: () {
                        _datePicker(context);
                      },
                      icon: const Icon(
                        Icons.calendar_today,
                        color: Color(0xFF193566),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  MyInput(
                    hint: getlocation ?? "Address",
                    fn: () {},
                    widget: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Map_Registration(),
                          ),
                        ).then((value) {
                          setState(() {
                            if (Map_Registration.location != null)
                              getlocation =
                                  Map_Registration.location!.address.toString();
                            locationObject = Map_Registration.location!;
                          });
                          print("${getlocation}PPPPPPPPPPPP");
                          print("${Map_Registration.location.toString()}");
                        });
                      },
                      icon: const Icon(
                        Icons.pin_drop,
                        color: Color(0xFF193566),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  // In Client App
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: size.width * 0.15,
                          ),
                          Text(
                            "Gender",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF193566)),
                          ),
                        ],
                      ),
                      RadioGroup<String>.builder(
                        direction: Axis.horizontal,
                        groupValue: _verticalGroupValue,
                        horizontalAlignment: MainAxisAlignment.spaceAround,
                        onChanged: (value) => setState(() {
                          _verticalGroupValue = value!;
                          gender = value;
                        }),
                        items: _status,
                        textStyle:
                            TextStyle(fontSize: 15, color: Color(0xFF193566)),
                        itemBuilder: (item) => RadioButtonBuilder(
                          item,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  SizedBox(
                    width: size.width * 0.4,
                    height: size.height * 0.06,
                    child: RaisedButton(
                      color: Color(0xFF193566),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      onPressed: () {
                        registerOnPress(context);
                      },
                      child: Text(
                        "Register".tr(),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.04,
                  ),
                ]),
          ),
        ));
  }

  chooseImage() async {
    _SelectPhoto();
  }

  Future _SelectPhoto() async {
    await showModalBottomSheet(
        context: context,
        builder: (context) => BottomSheet(
            onClosing: () {},
            builder: (context) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: Icon(Icons.camera),
                      title: Text("Camera"),
                      onTap: () {
                        _pickImage(ImageSource.camera);
                        Navigator.of(context).pop();
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.filter),
                      title: Text("Pick Image"),
                      onTap: () {
                        _pickImage(ImageSource.gallery);
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                )));
  }

  final ImagePicker _picker = ImagePicker();

  Future _pickImage(ImageSource source) async {
    print("Test  1");
    final pickedFile =
        await _picker.pickImage(source: source, imageQuality: 50);
    print("Test  2");
    if (pickedFile == null) {
       print("Test  3");
       return;
    }
    print("Test  4");
    var file = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1));
    print("Test  5");
    if (file == null) {
      print("Test  6");
      return;
    }
    print("Test  7");
    File file2 = await CompressImage(file.path, 35);
    print("Test  8");
    await _uploadFile(file2.path);
    print("Test  9");
  }

  Future CompressImage(String path, int quality) async {
    print("Test  10");
    final newPath = p.join((await getTemporaryDirectory()).path,
        '${DateTime.now()}.${p.extension(path)}');
    print("Test  11");
    final result = await FlutterImageCompress.compressAndGetFile(path, newPath,
        quality: quality);
    print("Test  12");
    return result;
  }

  Future _uploadFile(String path) async {
    print("Test  13");
    final ref = await FirebaseStorage.instance
        .ref()
        .child("users")
        // .child("clients")
        .child("profile_picture")
        .child(FirebaseAuth.instance.currentUser!.uid);
    final result = await ref.putFile(File(path));
    final fileUrl = await result.ref.getDownloadURL();
    user
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child('image')
        .set(fileUrl);
    setState(() {
      _image = File(fileUrl);
      _imagePath = fileUrl;
      print("Hello " + fileUrl);
    });
    // widget.onFilechanged(fileUrl);
  }
}

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
