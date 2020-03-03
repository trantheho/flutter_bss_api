import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bss_api/bloc/user_bloc.dart';
import 'package:flutter_bss_api/db/database.dart';
import 'package:flutter_bss_api/models/user.dart';

class UserItem extends StatefulWidget {
  final User user;

  const UserItem( this.user);

  @override
  _UserItemState createState() => _UserItemState();
}

class _UserItemState extends State<UserItem> {
  String _content, label = 'My name is';
  bool first = true;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Card(
        child: Column(
          children: <Widget>[
            Container(
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
                                  image: MemoryImage(loadImage(widget.user.picture.large))
                              )
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    '$label',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 5,),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        checkFirst(first, widget.user),
                        style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      _buildTopIndicator(),
                      Container(
                        margin: EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                //_buildTopIndicator(false),
                                IconButton(
                                  icon: Image(image: AssetImage('assets/icons/ic_user_default.png'),),
                                  onPressed:() {
                                    setState(() {
                                      label = 'My name is';
                                      _content = '${widget.user.name.title}.${widget.user.name.first} ${widget.user.name.last}';
                                      first = false;
                                      checkFirst(first, widget.user);
                                      //_content = setupContent(result, 0);
                                    });
                                  },
                                ),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                //_buildTopIndicator(false),
                                IconButton(
                                  icon: Image(image: AssetImage('assets/icons/ic_schedule_default.png'),),
                                  onPressed: () {
                                    setState(() {
                                      label = 'My schedule is';
                                      _content = '${widget.user.location.street.number} ${widget.user.location.street.name},${widget.user.location.city},${widget.user.location.state}';
                                      //setupContent(result, 1);
                                    });
                                  },
                                ),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                //_buildTopIndicator(true),
                                IconButton(
                                  icon: Image(image: AssetImage('assets/icons/ic_map_selected.png'),),
                                  onPressed: (){
                                    setState(() {
                                      label = 'My address is';
                                      _content = '${widget.user.location.street.name},${widget.user.location.city},${widget.user.location.state}';
                                      //setupContent(result, 2);
                                    });
                                  },
                                ),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                //_buildTopIndicator(false),
                                IconButton(
                                  icon: Image(image: AssetImage('assets/icons/ic_phone_default.png'),),
                                  onPressed: (){
                                    setState(() {
                                      label = 'My phone is';
                                      _content = '${widget.user.phone}';
                                      //setupContent(result, 3);
                                    });
                                  },
                                ),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                //_buildTopIndicator(false),
                                IconButton(
                                  icon: Image(image: AssetImage('assets/icons/ic_privacy_default.png'),),
                                  onPressed: (){
                                    setState(() {
                                      label = 'My password is';
                                      _content = '${widget.user.login.password}';
                                      //setupContent(result, 4);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  )

                ],
              ),
            )
          ],
        ),
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
