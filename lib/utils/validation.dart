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

  static bool phoneValidator(String phone) {
    //credit card if u wanna
    if (phone != "" && phone.contains(r"^(?:[+0][1-9])?[0-9]{10,12}$")) {
      // ^ beginning of a string
      // (?:[+0][1-9])? optionally match a + or 0 followed by a digit from 1 to 9
      // [0-9]{10,12} match 10 to 12 digits
      // $ end of the string

      return true;
    }
    return false;
  }

  static bool usernameValidator(String username) {
    if (username != "" &&
        username.contains(
            r"^(?=.{8,20}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])$")) {
      return true;
    }
    return false;
  }

  static bool ageValidator(String date) {
    // regex for validation of date format : dd.mm.yyyy, dd/mm/yyyy, dd-mm-yyyy
    if (date != "" &&
        date.contains(
            r"^(?:(?:31(\/|-|\.)(?:0?[13578]|1[02]))\1|(?:(?:29|30)(\/|-|\.)(?:0?[13-9]|1[0-2])\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})$|^(?:29(\/|-|\.)0?2\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))$|^(?:0?[1-9]|1\d|2[0-8])(\/|-|\.)(?:(?:0?[1-9])|(?:1[0-2]))\4(?:(?:1[6-9]|[2-9]\d)?\d{2})$")) {
      return true;
    }
    return false;
  }
}
