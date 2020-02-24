import 'dart:convert';
import 'package:flutter_bss_api/models/location.dart';
import 'package:flutter_bss_api/models/name.dart';

class User {
  String gender;
  Name name;
  Location location;
  String email;
  String username;
  String password;
  String phone;
  String cell;
  String picture;

  User ({this.gender, this.name, this.location, this.email, this.username,
      this.password, this.phone, this.cell, this.picture});

  User.fromJson(Map<String, dynamic> parsedJson)
      : gender = parsedJson["gender"],
        name = Name.fromJson(parsedJson["name"]),
        location = Location.fromJson(parsedJson["location"]),
        email = parsedJson["email"],
        username = parsedJson["username"],
        password = parsedJson["password"],
        phone = parsedJson["phone"],
        cell = parsedJson["cell"],
        picture = parsedJson["picture"];


  Map<String, dynamic> toMap(String path) => {
    "gender": gender,
    "title": name.title,
    "first": name.first,
    "last": name.last,
    "street": location.street,
    "city": location.city,
    "state": location.state,
    "email": email,
    "username": username,
    "password": password,
    "phone": phone,
    "cell": cell,
    "picture": path,
  };

}