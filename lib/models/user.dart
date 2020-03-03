import 'package:flutter_bss_api/models/location.dart';
import 'package:flutter_bss_api/models/login.dart';
import 'package:flutter_bss_api/models/name.dart';
import 'package:flutter_bss_api/models/picture.dart';

class User {
  String gender;
  Name name;
  Location location;
  String email;
  Login login;
  String phone;
  String cell;
  Picture picture;

  User ({this.gender, this.name, this.location, this.email, this.login, this.phone, this.cell, this.picture});

  User.fromJson(Map<String, dynamic> parsedJson)
      : gender = parsedJson["gender"],
        name = Name.fromJson(parsedJson["name"]),
        location = Location.fromJson(parsedJson["location"]),
        email = parsedJson["email"],
        login = Login.fromJson(parsedJson["login"]),
        phone = parsedJson["phone"],
        cell = parsedJson["cell"],
        picture = Picture.fromJson(parsedJson["picture"]);


  Map<String, dynamic> toMap(String path) => {
    "gender": gender,
    "title": name.title,
    "first": name.first,
    "last": name.last,
    "street": location.street.toString(),
    "city": location.city,
    "state": location.state,
    "email": email,
    "username": login.username,
    "password": login.password,
    "phone": phone,
    "cell": cell,
    "picture": path,
  };

}