
class Picture {
  String large;
  String medium;
  String thumbnail;

  Picture({this.large, this.medium, this.thumbnail});

  Picture.fromJson(Map<String, dynamic> parsedJson)
      : large = parsedJson["large"],
        medium = parsedJson["medium"],
        thumbnail = parsedJson["thumbnail"];

}