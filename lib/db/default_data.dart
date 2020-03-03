import 'package:flutter_bss_api/models/location.dart';
import 'package:flutter_bss_api/models/login.dart';
import 'package:flutter_bss_api/models/name.dart';
import 'package:flutter_bss_api/models/picture.dart';
import 'package:flutter_bss_api/models/street.dart';
import 'package:flutter_bss_api/models/user.dart';

final List<User> user_data = [

  new User(
    gender: "male",
    name: Name(
      title: "Mr",
      first: "Hoang",
      last: "Minh"
    ),
    location: Location(
      street: Street(
        number: 123,
        name: "Ngo Tat To"
      ),
      city: "Ho Chi Minh",
      state: "Viet Nam"
    ),
    email: "sada@gmail.com",
    login: Login(
      username: "username",
      password: "password"
    ),
    phone: "021 1165 5655",
    cell: "0221 565 565",
    picture: Picture(
      large: "https://randomuser.me/api/portraits/men/0.jpg",
      medium: "https://randomuser.me/api/portraits/med/men/0.jpg",
      thumbnail: "https://randomuser.me/api/portraits/thumb/men/0.jpg"
    )
  ),

  new User(
      gender: "fesmale",
      name: Name(
          title: "Mrs",
          first: "Hoang",
          last: "Thu"
      ),
      location: Location(
          street: Street(
              number: 123,
              name: "Nguyen Van Troi"
          ),
          city: "Ho Chi Minh",
          state: "Viet Nam"
      ),
      email: "sada@gmail.com",
      login: Login(
          username: "username",
          password: "password"
      ),
      phone: "021 1165 5655",
      cell: "0221 565 565",
      picture: Picture(
          large: "https://randomuser.me/api/portraits/women/62.jpg",
          medium: "https://randomuser.me/api/portraits/women/62.jpg",
          thumbnail: "https://randomuser.me/api/portraits/women/62.jpg"
      )
  )

];