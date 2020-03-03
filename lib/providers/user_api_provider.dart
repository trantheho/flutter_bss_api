import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_bss_api/responses/user_response.dart';

class UserApiProvider {
  final String _apiUrl = "http://192.168.1.110:3000/api/";
  final String localApi = "assets/user.json";
  final Dio _dio = new Dio();

  //Future như rxjava.
  Future<UserResponse> getUser() async {
    try{
      //await==> Để lấy dữ liệu từ API, luon nam trong async
      Response response = await _dio.get(_apiUrl);
<<<<<<< HEAD
      print("response: ${response.toString()}");
      return UserResponse.fromJson(json.decode(response.toString()));
=======
      //async==> đồng bộ data sau khi api trả về response
      return UserResponse.fromJson(json.decode(response.data));
>>>>>>> master
    }
    catch(error, stacktrace){
      print("Exception: $error stackTrace: $stacktrace");
      return UserResponse.withError("$error");
    }
  }
}