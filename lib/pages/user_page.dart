import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bss_api/bloc/user_bloc.dart';
import 'package:flutter_bss_api/db/database.dart';
import 'package:flutter_bss_api/models/result.dart';
import 'package:flutter_bss_api/responses/user_response.dart';

class UserPage extends StatefulWidget {

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  bool swipeLeft = false, swipeRight = false;
  String content, label;
  DatabaseHelper db;

  @override
  void initState() {
    super.initState();
    bloc.getUser();
    db = DatabaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.subject.stream,
      builder: (context, AsyncSnapshot<UserResponse> snapshot) {
        if(snapshot.hasData){
          print(snapshot.data);
          if(snapshot.data.error != null && snapshot.data.error.length > 0){
            print("${snapshot.data.error}");
            return _buildError(snapshot.data.error);
          }
          return _buildProfile(snapshot.data);
        }
        else if(snapshot.hasError){
          return _buildError(snapshot.data.error);
        }else{
          return _buildLoading();
        }
      },
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 400,
            child: Column(
              children: <Widget>[
                Text('Please wait to loading data...'),
                CircularProgressIndicator(),
              ],
            )
          ),
        ],
      ),
    );
  }

  Widget _buildError(String error){
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 400,
              child: Column(
                children: <Widget>[
                  Image(image: AssetImage('assets/icons/ic_error.png'),width: 50, height: 50,),
                  Text(error),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfile(UserResponse data){
    Result result = data.results[0];
    DragStartDetails startVerticalDragDetails;
    DragUpdateDetails updateVerticalDragDetails;
    content = "${result.user.location.street} ${result.user.location.city}";
    label = "My address is";

    return Center(
      child: GestureDetector(
        onHorizontalDragStart: (drag){
          startVerticalDragDetails = drag;
        },
        onHorizontalDragUpdate: (drag){
          updateVerticalDragDetails = drag;
        },
        onHorizontalDragEnd: (endDrag){
          double dx = updateVerticalDragDetails.globalPosition.dx - startVerticalDragDetails.globalPosition.dx;

          if(dx > 0){
            bloc.getUser();
          }
          else{
            //saveUser(result.user);
            //networkImageToUnit8List(result.user.picture);
            db.saveUser(result.user);
          }
          },


        child: Padding(
          padding: const EdgeInsets.all(8),
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
                                    image: NetworkImage(result.user.picture)
                                )
                            ),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      label,
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    SizedBox(height: 5,),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          content,
                          style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        padding: EdgeInsets.only(bottom: 16),
                        // default
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
                                    onTap: () {
                                      setState(() {
                                        label = "My name is";
                                        content = "${result.user.name.title}.${result.user.name.first} ${result.user.name.last}";
                                      });
                                    },
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
                                    onTap: (){
                                      setState(() {
                                        label = "My address is";
                                        content = "${result.user.location.street},${result.user.location.city},${result.user.location.state}";
                                      });
                                    },
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
                                    onTap: (){
                                      setState(() {
                                        label = "My address is";
                                        content = "${result.user.location.street}, ${result.user.location.city}, ${result.user.location.state}";
                                      });
                                    },
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
                                    onTap: () {
                                      setState(() {
                                        label = "My phone is";
                                        content = "${result.user.phone}";
                                      });
                                    },
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
                                      setState(() {
                                        label = "My password is";
                                        content = "${result.user.password}";
                                      });
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

  void iconClick(int number, Result result){
    switch(number){
      case 1:
        content = "${result.user.name.title}.${result.user.name.first} ${result.user.name.last}";

    }

  }


}
