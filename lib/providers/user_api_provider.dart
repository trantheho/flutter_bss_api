import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_bss_api/responses/user_response.dart';

class UserApiProvider {
  final String _apiUrl = "https://randomuser.me/api/0.4/?randomapi";
  final Dio _dio = new Dio();

  Future<UserResponse> getUser() async {
    try{
      Response response = await _dio.get(_apiUrl);
      print("response: ${response}");
      return UserResponse.fromJson(json.decode(response.data));
    }
    catch(error, stacktrace){
      print("Exception: $error stackTrace: $stacktrace");
      return UserResponse.withError("$error");
    }
  }
}