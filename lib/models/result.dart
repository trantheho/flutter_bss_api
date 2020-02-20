import 'package:flutter_bss_api/models/user.dart';

class Result {
  User user;
  String seed;
  String version;

  Result (this.user, this.seed, this.version);

  Result.fromJson(Map<String, dynamic> parsedJson)
      : user = User.fromJson(parsedJson["user"]),
        seed = parsedJson["seed"],
        version = parsedJson["version"];

}