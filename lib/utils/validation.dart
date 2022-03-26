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
        pass.contains(r'^(?=.*?[a-z])(?=.*?[0-9]).{5,}$') &&
        pass.length > 5) {
      return true;
      // 5 char and number

      //******************
      //r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{5,}$'
      // one special , one capital , one number, number length > 4
      // Vignesh123! : true
      // vignesh123 : false
      // VIGNESH123! : false
      // vignesh@ : false
      // 12345678? : false
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

  static bool ageValidator(DateTime dateTime) {
    // regex for validation of date format : dd.mm.yyyy, dd/mm/yyyy, dd-mm-yyyy
    if (dateTime != "" && dateTime.isBefore(DateTime.now())) {
      return true;
    }
    return false;
  }
}
