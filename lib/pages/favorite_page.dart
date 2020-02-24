import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bss_api/bloc/user_bloc.dart';
import 'package:flutter_bss_api/db/database.dart';
import 'package:flutter_bss_api/models/user.dart';

class Favorite extends StatefulWidget {
  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  DatabaseHelper db;
  List<User> list;

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
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () => Navigator.of(context).pop(false)),
      ),

      body: StreamBuilder(
        stream: bloc.userSubject.stream,
        builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot ){
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index){
                return Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Card(
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            height: 370,
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Container(
                                    width: 160,
                                    height: 160,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(width: 2, color: Colors.grey),
                                      color: Colors.white,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(2),
                                      child: Container(
                                        width: 160,
                                        height: 160,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: MemoryImage(loadImage(snapshot.data[index].picture)),
                                            )
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  'My address is',
                                  style: TextStyle(fontSize: 18, color: Colors.grey),
                                ),
                                SizedBox(height: 5,),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    child: Text(
                                      '${snapshot.data[index].location.street} ${snapshot.data[index].location.city}',
                                      style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Container(
                                    padding: EdgeInsets.only(bottom: 16),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Column(
                                            children: <Widget>[
                                              _buildTopIndicator(),
                                              InkWell(
                                                child: Image(
                                                  image: AssetImage('assets/icons/ic_user_default.png'),
                                                  width: 30,
                                                  height: 30,
                                                ),
                                                onTap: () {},
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Column(
                                            children: <Widget>[
                                              _buildTopIndicator(),
                                              InkWell(
                                                child: Image(
                                                  image: AssetImage('assets/icons/ic_schedule_default.png'),
                                                  width: 30,
                                                  height: 30,
                                                ),
                                                onTap: (){},
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Column(
                                            children: <Widget>[
                                              _buildTopIndicator(),
                                              InkWell(
                                                child: Image(
                                                  image: AssetImage('assets/icons/ic_map_selected.png'),
                                                  width: 30,
                                                  height: 30,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Column(
                                            children: <Widget>[
                                              _buildTopIndicator(),
                                              InkWell(
                                                child: Image(
                                                  image: AssetImage('assets/icons/ic_phone_default.png'),
                                                  width: 30,
                                                  height: 30,
                                                ),
                                                onTap: () {},
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Column(
                                            children: <Widget>[
                                              _buildTopIndicator(),
                                              InkWell(
                                                child: Image(
                                                  image: AssetImage('assets/icons/ic_privacy_default.png'),
                                                  width: 30,
                                                  height: 30,
                                                ),
                                                onTap: (){

                                                },
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )

                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
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

  Widget _buildTopIndicator(){
    return Container(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(bottom: 2),
              child: Image(image: AssetImage('assets/icons/ic_up_arrow.png'), width: 10, height: 10,)),
          Container(
            width: 30,
            height: 2,
            color: Colors.green[700],
          ),
        ],
      ),
    );
  }

  Uint8List loadImage(String path){
    File file = File(path);
    Uint8List byte = file.readAsBytesSync();
    return byte;
  }

}
