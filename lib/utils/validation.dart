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
