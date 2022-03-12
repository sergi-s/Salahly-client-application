import 'package:slahly/classes/models/location.dart';

enum AccountState { active, block }
enum Sex { none, male, female }
enum Type { client, mechanic, provider, admin }
enum Language { en, ar }

abstract class UserType {
  String? name;
  String? id;
  String? avatar;
  String? birthDay;
  String? createdDate;
  String? email;
  String? _password;
  String? phoneNumber;
  String? address;
  Location? loc;

  // final Language lang;
  Sex? sex;
  Type? type;
  AccountState? state;

  UserType({
    this.id,
    required this.name,
    required this.email,
    this.birthDay,
    this.createdDate,
    this.state,
    this.sex,
    this.type,
    this.avatar,
    this.loc,
    this.phoneNumber,
  });

  String get password => _password!;

  set setPassword(String value) {
    _password = value;
  }

  bool isValid() {
    return (emailValidate(email!) &&
        nameValidate(name!) &&
        passValidate(password));
  }

  //Validation

  bool emailValidate(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)$")
        .hasMatch(email);
  }

  bool nameValidate(String name) {
    return RegExp(
            r"^([a-zA-Z]{2,}\s[a-zA-Z]{1,}'?-?[a-zA-Z]{2,}\s?([a-zA-Z]{1,})?)")
        .hasMatch(name);
  }

  bool passValidate(String password) {
    return RegExp(r"^(?=.?[A-Z])(?=.?[a-z])(?=.?[0-9])(?=.?[#?!@$%^&*-]).{8,}$")
        .hasMatch(password);

    /*At least one upper case English letter, (?=.?[A-Z])
    At least one lower case English letter, (?=.*?[a-z])
    At least one digit, (?=.*?[0-9])
    At least one special character, (?=.?[#?!@$%^&-])
    Minimum eight in length .{8,} (with the anchors)
    @            */
  }
}
