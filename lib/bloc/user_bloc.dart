import 'package:flutter_bss_api/db/database.dart';
import 'package:flutter_bss_api/models/user.dart';
import 'package:flutter_bss_api/providers/user_api_provider.dart';
import 'package:flutter_bss_api/responses/user_response.dart';
import 'package:rxdart/rxdart.dart';

class UserBloc {
  final UserApiProvider _userApiProvider = UserApiProvider();
  final BehaviorSubject<List<User>> _subject = BehaviorSubject<List<User>> ();
  List<User> list = List();

  /**
   *StreamController là StreamSink để quản lí luồng như Rxdart.
   * Bản demo sài RxDart
   *
   * Trong RxDart gồm: BehaviorSubject, ReplaySubject, PublishSubject
   * BehaviorSubject: nhận giá trị respone
   */
  //final BehaviorSubject<UserResponse> _subject = BehaviorSubject<UserResponse> ();
  final ReplaySubject<List<User>> _userSubject = ReplaySubject<List<User>> ();
  final DatabaseHelper db = DatabaseHelper();

  getUser() async{
    for(int i= 1 ; i<3; i++){
      UserResponse response = await _userApiProvider.getUser();
      list.add(response.results[0]);
    }
    _subject.sink.add(list);
  }

  Future<UserResponse> initUser() async {
    UserResponse response = await _userApiProvider.getUser();
    return response;
  }

  getLocalUser() async{
    List<User> list = await db.getUser();
    _userSubject.sink.add(list);
  }

  dispose() {
    _subject.close();
    _userSubject.close();
  }

  BehaviorSubject<List<User>> get subject => _subject;
  ReplaySubject<List<User>> get userSubject => _userSubject;

}

final bloc = UserBloc();