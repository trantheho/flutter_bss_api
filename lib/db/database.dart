import 'dart:async';
import 'dart:io' as io;
import 'package:flutter_bss_api/models/location.dart';
import 'package:flutter_bss_api/models/name.dart';
import 'package:flutter_bss_api/models/user.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';


class DatabaseHelper{
  //define
  static Database _db;
  static const String GENDER = 'gender';
  static const String TITLE = 'title';
  static const String FIRST = 'first';
  static const String LAST = 'last';
  static const String STREET = 'street';
  static const String CITY = 'city';
  static const String STATE = 'state';
  static const String EMAIL = 'email';
  static const String USERNAME = 'username';
  static const String PASSWORD = 'password';
  static const String PHONE = 'phone';
  static const String CELL = 'cell';
  static const String PICTURE = 'picture';

  static const String DB_NAME = 'user.db';
  static const String TABLE = 'user';

  Future<Database> get db async{
    if(_db != null){
      return _db;
    }
    _db = await initDB();
    return _db;
  }

  initDB() async{
    io.Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);

    return  db;
  }

  _onCreate(Database db, int version) async{
    await db.execute('CREATE TABLE $TABLE ($GENDER TEXT,'
        '$TITLE TEXT,'
        '$FIRST TEXT,'
        '$LAST TEXT,'
        '$STREET TEXT,'
        '$CITY TEXT,'
        '$STATE TEXT,'
        '$EMAIL TEXT,'
        '$USERNAME TEXT,'
        '$PASSWORD TEXT,'
        '$PHONE TEXT,'
        '$CELL TEXT,'
        '$PICTURE TEXT)');
  }

  Future<int> saveUser(User user) async{
    var dbClient = await db;
    var imagePath = await DefaultCacheManager().getSingleFile(user.picture);
    var result = await dbClient.insert(TABLE, user.toMap(imagePath.path),);
    return result;
  }

  Future<List<User>> getUser() async{
    var dbClient = await db;
    List<Map<String, dynamic>> value = await dbClient.rawQuery('SELECT * FROM $TABLE');
    List<User> list = List();

    for(int i=0; i<value.length; i++){
      var name = Name(title: value[i]["title"], first: value[i]["first"], last: value[i]["last"]);
      var location = Location(street: value[i]["street"], city: value[i]["city"], state: value[i]["state"]);

      var user = User(gender: value[i]["gender"],
          name: name,
          location: location,
          email: value[i]["email"],
          username: value[i]["username"],
          password: value[i]["password"],
          phone: value[i]["phone"],
          cell: value[i]["cell"],
          picture: value[i]["picture"]);

      list.add(user);
    }
    print("List local: $list");
    return list;
  }

  Future<void> deleteData() async{
    var dbClient = await db;
    await dbClient.delete(TABLE);
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }



}