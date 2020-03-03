import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_bss_api/responses/user_response.dart';

class UserApiProvider {
  final String _apiUrl = "http://192.168.1.110:3000/api/";
  final String localApi = "assets/user.json";
  final Dio _dio = new Dio();

  Future<UserResponse> getUser() async {
    try{
      Response response = await _dio.get(_apiUrl);
      print("response: ${response.toString()}");
      return UserResponse.fromJson(json.decode(response.toString()));
    }
    catch(error, stacktrace){
      print("Exception: $error stackTrace: $stacktrace");
      return UserResponse.withError("$error");
    }
  }
}