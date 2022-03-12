
import 'package:slahly/classes/models/client.dart';

abstract class Authentication{
  Future<bool> login(Client client);
  Future<bool> signup(Client client);
}