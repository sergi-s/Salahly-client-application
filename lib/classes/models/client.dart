import 'package:slahly/abstract_classes/authValidation.dart';
import 'package:slahly/abstract_classes/user.dart';

class Client extends UserType{
  String _email,_password;

  Client(this._email, this._password);

  get password => _password;

  set password(value) {
    _password = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  bool validateSignup(Client newClient){
    return _SignUpValidatorClient().signupValidation(newClient, _SignUpValidatorClient().validationFun);
  }

}


class _SignUpValidatorClient extends AuthValidation {

  @override
  bool signupValidation(UserType newUser, Function validation) {
    return validation(newUser);
//     throw UnimplementedError();
  }

  bool validationFun(Client newUser) {
    ///TODO data
    if (newUser.email.isEmpty) {
      print("Enter email");
      return false;
    }
    if (newUser.password.length < 6) {
      print("Password not good");
      return false;
    }
    return true;
  }


}
