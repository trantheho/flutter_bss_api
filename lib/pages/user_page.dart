import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bss_api/bloc/user_bloc.dart';
import 'package:flutter_bss_api/db/database.dart';
import 'package:flutter_bss_api/models/user.dart';
import 'package:flutter_bss_api/providers/user_api_provider.dart';
import 'package:flutter_bss_api/responses/user_response.dart';

class UserPage extends StatefulWidget {
  //User user;
  /*List<User> user;
  double bottom;
  double right;
  double left;
  double cardWidth;
  double rotation;
  double skew;
  int flag;
  Function addUser;
  Function swipeRight;
  Function swipeLeft;


  UserPage (this.user, this.bottom, this.right, this.left, this.cardWidth,
      this.rotation, this.skew, this.flag, this.addUser, this.swipeRight, this.swipeLeft);
*/
  //UserPage(this.user);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> with TickerProviderStateMixin{
  bool swipeLeft = false, swipeRight = false, first = true;
  int flag =0;
  List<User> list = [];
  UserResponse response;
  UserApiProvider apiProvider;
  String _content, label;
  DatabaseHelper db;
  Animation<double> rotate;
  Animation<double> bottom;
  Animation<double> width;
  Animation<double> right;
  Animation<double> _fadeInFadeOut;
  AnimationController _buttonController;
  double opacity =0;



  @override
  void initState() {
    super.initState();
    db = DatabaseHelper();
    bloc.getUser();
    label = 'My address is';

    _buttonController = new AnimationController(
        duration: new Duration(milliseconds: 2000), vsync: this);


    _fadeInFadeOut = Tween<double>(begin: 1.0, end: 1).animate(_buttonController);

    rotate = new Tween<double>(
      begin: -0.0,
      end: -180.0,
    ).animate(
      new CurvedAnimation(
        parent: _buttonController,
        curve: Curves.ease,
      ),
    );

    right = new Tween<double>(
      begin: 0.0,
      end: 400.0,
    ).animate(
      new CurvedAnimation(
        parent: _buttonController,
        curve: Curves.easeInOutCirc,
      ),
    );
    bottom = new Tween<double>(
      begin: 20.0,
      end: 150.0,
    ).animate(
      new CurvedAnimation(
        parent: _buttonController,
        curve: Curves.fastOutSlowIn,
      ),
    );
    width = new Tween<double>(
      begin: 20.0,
      end: 25.0,
    ).animate(
      new CurvedAnimation(
        parent: _buttonController,
        curve: Curves.bounceOut,
      ),
    );


  }


  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return Stack(
      children: <Widget>[
        Positioned(
          bottom: 80+bottom.value,
          right: flag == 0 ? right.value != 0.0 ? right.value : null : null,
          left: flag == 1 ? right.value != 0.0 ? right.value : null : null,
          child: Dismissible(
              crossAxisEndOffset: -0.2,
              key: new Key(new Random().toString()),
              child: RotationTransition(
                turns: new AlwaysStoppedAnimation(-rotate.value / 360),
                child: _buildProfile(),
              )
          ),
        ),
      ],
=======
    return StreamBuilder(
      //đầu ra dữ liệu
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
>>>>>>> master
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

  Widget _buildProfile(){
    //User result = data;
    DragStartDetails startVerticalDragDetails;
    DragUpdateDetails updateVerticalDragDetails;

    return GestureDetector(
      child: Stack(
        children: <Widget>[
          _buildProfileCard(),
          /*Padding(
            padding: const EdgeInsets.all(4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                                      image: NetworkImage(result.picture.large)
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
                            checkFirst(first, result),
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
                                          _content = '${result.name.title}.${result.name.first} ${result.name.last}';
                                          first = false;
                                          checkFirst(first, result);
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
                                          _content = '${result.location.street.number} ${result.location.street.name},${result.location.city},${result.location.state}';
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
                                          _content = '${result.location.street.number} ${result.location.street.name},${result.location.city},${result.location.state}';
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
                                          _content = '${result.phone}';
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
                                          _content = '${result.login.password}';
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
          ),*/
        ],
      ),
    );
  }

  Widget _buildTopIndicator(){
    /*if(value){*/
      return Container(
        width: 200,
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              AnimatedPositioned(
                duration: Duration(milliseconds: 300),
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
              ),

            ],
          ),
        ),
      );
    //}
    /*else{
      return Container(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              height: 10,
                margin: EdgeInsets.only(bottom: 2),
                *//*child: Image(image: AssetImage('assets/icons/ic_up_arrow.png'), width: 10, height: 10,)*//*
            ),
            Container(
              width: 30,
              height: 2,
              color: Colors.white,
            ),
          ],
        ),
      );
    }*/

  }

  String checkFirst(bool value, User result){
    if(value){
      return '${result.location.street},${result.location.city},${result.location.state}';
    }
    else{
      return _content;
    }
  }

  String setupContent(User result, int position){
    if(position == 0) {
        return _content = '${result.name.title}.${result.name.first} ${result.name.last}';
    }
    if(position == 1) {
      return _content = '${result.location.street},${result.location.city},${result.location.state}';
    }
    if(position == 2) {
      return _content = '${result.location.street},${result.location.city},${result.location.state}';
    }
    if(position == 3) {
      return _content = '${result.phone}';
    }
    if(position == 4) {
      return _content = '${result.login.password}';
    }
  }

  Widget _buildProfileCard(){
    return GestureDetector(
      /*onHorizontalDragStart: (start){
        setState(() {
          opacity = opacity == 0.0 ? 1.0 : 0.0;
        });
      },*/

      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 350,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                        color: Colors.grey[200]
                    ),
                  ),
                  Container(
                    height: 2,
                    width: double.infinity,
                    color: Colors.grey,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }




}
