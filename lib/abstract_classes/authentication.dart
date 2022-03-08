
import 'package:slahly/classes/models/client.dart';

abstract class Authentication{
  void login(Client client);
  void signup(Client client);
}