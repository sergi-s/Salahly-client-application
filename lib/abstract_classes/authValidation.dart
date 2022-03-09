import 'package:slahly/abstract_classes/user.dart';

abstract class AuthValidation {
  bool signupValidation(UserType newUser) {
    return (emailValidate(newUser.email!) && nameValidate(newUser.name!) && passValidate(newUser.password));
  }

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

  passValidate(String password) {
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
