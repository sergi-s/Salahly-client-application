import 'package:string_validator/string_validator.dart';

class Validator {
  static bool emailValidator(String email) {
    print("inside validator ${isEmail(email)} ${email}");
    if (email != "" && isEmail(email)) {
      return true;
    }
    return false;
  }

  static bool passValidator(String pass) {
    if (pass != "" &&
        pass.contains(RegExp(r'^(?=.*?[a-z])(?=.*?[0-9]).{5,}$')) &&
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
    if (phone != "" && phone.contains(RegExp(r"^01[0125][0-9]{8}$"))) {
      //egypt phone number

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
