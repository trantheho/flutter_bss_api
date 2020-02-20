class Name {
  String title;
  String first;
  String last;

  Name (this.title, this.first, this.last);

  Name.fromJson(Map<String, dynamic> parsedJson)
      : title = parsedJson["title"],
        first = parsedJson["first"],
        last = parsedJson["last"];

}