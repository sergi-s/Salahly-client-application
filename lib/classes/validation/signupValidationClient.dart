import 'package:slahly/abstract_classes/authValidation.dart';
import 'package:slahly/abstract_classes/user.dart';

class SignUpValidatorClient extends AuthValidation{

  @override
  bool signupValidation(UserType newUser, Function validation) {
    return validation(newUser);
//     throw UnimplementedError();
  }

  bool validationFun(Client newUser){
    if(newUser.email.isEmpty){
      print("Enter email");
      return false;
    }
    if(newUser.password.length >= 6){
      print("Password not good");
      return false;
    }
    return true;
  }
}