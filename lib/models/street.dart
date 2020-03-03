
class Street {
  int number;
  String name;

  Street ({this.number, this.name});

  Street.fromJson(Map<String, dynamic> json)
      : number = json["number"],
        name = json["name"];

  Map<String, dynamic> toMap() => {
    "number": number,
    "name" : name,
  };

  @override
  String toString() {
    String out = '$number $name';
    return out;
  }


}