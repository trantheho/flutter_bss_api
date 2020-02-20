import 'package:flutter_bss_api/models/result.dart';

class UserResponse {
  final List<Result> results ;
  final String error;

  UserResponse (this.results, this.error);

  UserResponse.fromJson(Map<String, dynamic> parsedJson)
      : results =(parsedJson["results"] as List).map((i) => new Result.fromJson(i)).toList(),
        error = "";

  UserResponse.withError(String errorValue)
      : results = List(),
        error = errorValue;

}