import 'package:slahly/abstract_classes/user.dart';

abstract class AuthValidation{
  bool signupValidation(UserType newUser,Function validation);
}
