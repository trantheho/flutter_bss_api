
class Login {
  String username;
  String password;

  Login({this.username, this.password});

  Login.fromJson( Map<String,dynamic> parsedJson)
      : username = parsedJson["username"],
        password = parsedJson["password"];

}