class Location{
  String street;
  String city;
  String state;
  String zip;

  Location (this.street, this.city, this.state, this.zip);

  Location.fromJson(Map<String, dynamic> parsedJson)
      : street = parsedJson["street"],
        city = parsedJson["city"],
        state = parsedJson["state"],
        zip = parsedJson["zip"];

}