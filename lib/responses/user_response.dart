import 'package:flutter_bss_api/models/user.dart';

class UserResponse {
  final List<User> results ;
  final String error;

  UserResponse (this.results, this.error);

  UserResponse.fromJson(Map<String, dynamic> parsedJson)
      : results =(parsedJson["results"] as List).map((i) => new User.fromJson(i)).toList(),
        error = "";

  UserResponse.withError(String errorValue)
      : results = List(),
        error = errorValue;

}