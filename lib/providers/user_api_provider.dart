import 'package:dio/dio.dart';
import 'package:flutter_bss_api/responses/user_response.dart';

class UserApiProvider {
  final String _apiUrl = "https://randomuser.me/api/0.4/?randomapi";
  final Dio _dio = Dio();

  Future<UserResponse> getUser() async {
    try{
      Response response = await _dio.get(_apiUrl);
      print(response.data);
      return UserResponse.fromJson(response.data);
    }
    catch(error, stacktrace){
      print("Exception: $error stackTrace: $stacktrace");
      return UserResponse.withError("$error");
    }
  }
}