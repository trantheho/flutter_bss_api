class Location{
  String street;
  String city;
  String state;

  Location (this.street, this.city, this.state);

  Location.fromJson(Map<String, dynamic> parsedJson)
      : street = parsedJson["street"],
        city = parsedJson["city"],
        state = parsedJson["state"];

}