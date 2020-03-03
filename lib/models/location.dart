import 'package:flutter_bss_api/models/street.dart';

class Location{
  Street street;
  String city;
  String state;

  Location ({this.street, this.city, this.state});

  Location.fromJson(Map<String, dynamic> parsedJson)
      : street = Street.fromJson(parsedJson["street"]),
        city = parsedJson["city"],
        state = parsedJson["state"];



  Map<String, dynamic> toMap() => {
    "street": street,
    "city": city,
    "state": state,
  };

}