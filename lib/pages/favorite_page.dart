import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bss_api/bloc/overlay_bloc.dart';
import 'package:flutter_bss_api/bloc/user_bloc.dart';
import 'package:flutter_bss_api/db/database.dart';
import 'package:flutter_bss_api/models/user.dart';
import 'package:flutter_bss_api/utils/item.dart';

class Favorite extends StatefulWidget {
  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  DatabaseHelper db;
  List<User> list;
  String _content, label = 'My name is';
  bool first = true;

  @override
  void initState() {
    super.initState();
    db = DatabaseHelper();
    bloc.getLocalUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite User'),
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: (){
          setState(() {
            overlayBloc.inputValue.add(true);
          });
          Navigator.of(context).pop(false);
        }),
      ),

      body: StreamBuilder(
        stream: bloc.userSubject.stream,
        builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot ){
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index){
                return UserItem(snapshot.data[index]);
              });
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),

    );
  }


  Uint8List loadImage(String path){
    File file = File(path);
    Uint8List byte = file.readAsBytesSync();
    print("path image: $path");
    return byte;
  }

  String checkFirst(bool value, User result){
    if(value){
      return '${result.location.street.name},${result.location.city},${result.location.state}';
    }
    else{
      return _content;
    }
  }

}
