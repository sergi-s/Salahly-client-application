import 'package:string_validator/string_validator.dart';

class Validator {
  static bool emailValidator(String email) {
    if (email != "" && isEmail(email)) {
      return true;
    }
    return false;
  }

  static bool passValidator(String pass) {
    if (pass != "" &&
        pass.contains(
            r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$")) {
      return true;
    }
    return false;
  }

  static bool creditValidator(String credit) {
    //credit card if u wanna
    if (isCreditCard(credit)) {
      return true;
    }
    return false;
  }
}

class Validate {
  static bool emailValidate(String email) {
    bool Validemail = RegExp(
            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
        .hasMatch(email);

    return Validemail;
  }

  static bool nameValidate(String name) {
    bool Validname = RegExp(
            r"^([a-zA-Z]{2,}\s[a-zA-Z]{1,}'?-?[a-zA-Z]{2,}\s?([a-zA-Z]{1,})?)")
        .hasMatch(name);
    return Validname;
  }

  static bool passValidate(String password) {
    bool Validpass = RegExp(
            r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$")
        .hasMatch(password);
    return Validpass;
    /*At least one upper case English letter, (?=.*?[A-Z])
      At least one lower case English letter, (?=.*?[a-z])
      At least one digit, (?=.*?[0-9])
      At least one special character, (?=.*?[#?!@$%^&*-])
      Minimum eight in length .{8,} (with the anchors)
@            */
  }
}
