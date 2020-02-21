import 'package:flutter_bss_api/models/user.dart';

class Result {
  User user;


  Result (this.user);

  Result.fromJson(dynamic parsedJson)
      : user = User.fromJson(parsedJson['user']);


}