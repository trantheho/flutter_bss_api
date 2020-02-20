import 'package:flutter_bss_api/providers/user_api_provider.dart';
import 'package:flutter_bss_api/responses/user_response.dart';
import 'package:rxdart/rxdart.dart';

class UserBloc {
  final UserApiProvider _userApiProvider = UserApiProvider();
  final BehaviorSubject<UserResponse> _subject = BehaviorSubject<UserResponse> ();

  getUser() async{
    UserResponse response = await _userApiProvider.getUser();
    _subject.sink.add(response);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<UserResponse> get subject => _subject;

}

final bloc = UserBloc();