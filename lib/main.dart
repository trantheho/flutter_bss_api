import 'package:flutter/material.dart';
import 'package:flutter_bss_api/bloc/overlay_bloc.dart';
import 'package:flutter_bss_api/bloc/user_bloc.dart';
import 'package:flutter_bss_api/db/default_data.dart';
import 'package:flutter_bss_api/models/user.dart';
import 'package:flutter_bss_api/pages/cards.dart';
import 'package:flutter_bss_api/pages/favorite_page.dart';
import 'package:flutter_bss_api/pages/user_screen.dart';
import 'package:flutter_bss_api/utils/cards_demo.dart';
import 'package:flutter_bss_api/utils/matches.dart';
import 'package:flutter_bss_api/utils/top_indicator.dart';

void main() {
  runApp(MyApp());
}

/*final MatchEngine matchEngine = new MatchEngine(
    matches: user_data.map((User user) {
      return Match(user: user);
    }).toList());*/

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColorBrightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Match match = new Match();
  MatchEngine matchEngine;
  List<User> list;


  @override
  void initState () {
    bloc.updateUser();
    list = [];
    overlayBloc.inputValue.add(true);
  }

  Widget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      title: Text(
        'Demo API Flutter'
      ),
      actions: <Widget>[
        new IconButton(
          icon: new Icon(
            Icons.favorite,
            color: Colors.redAccent,
            size: 40.0,
          ),
          onPressed: () {
            setState(() {
              // using stream to handle overlay value
              overlayBloc.inputValue.add(false);
            });
            Navigator.push(context, MaterialPageRoute(builder: (context) => Favorite()));
          },
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return BottomAppBar(
        color: Colors.transparent,
        elevation: 0.0,
        child: new Padding(
          padding: const EdgeInsets.all(16.0),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              /*new RoundIconButton.small(
                icon: Icons.refresh,
                iconColor: Colors.orange,
                onPressed: () {},
              ),*/
              new RoundIconButton.large(
                icon: Icons.favorite,
                iconColor: Colors.green,
                onPressed: () {
                  matchEngine.currentMatch.like();
                },
              ),
              new RoundIconButton.small(
                icon: Icons.arrow_upward,
                iconColor: Colors.blue,
                onPressed: () {
                  matchEngine.currentMatch.superLike();
                },
              ),
              new RoundIconButton.large(
                icon: Icons.clear,
                iconColor: Colors.red,
                onPressed: () {
                  matchEngine.currentMatch.nope();
                },
              ),


             /* new RoundIconButton.small(
                icon: Icons.lock,
                iconColor: Colors.purple,
                onPressed: () {},
              ),*/
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: StreamBuilder(
        stream: bloc.subject.stream,
        builder: (context, AsyncSnapshot<List<User>> snapshot){
          if(snapshot.hasData){
            matchEngine = new MatchEngine(
                matches: snapshot.data.map((User user) {
                  return Match(user: user);
                }).toList());

            print("data from bloc: ${snapshot.data}");

            return CardStackUser(
              matchEngine: matchEngine,
            );
          }
          else{
            return _buildLoading();
          }
        },
      ),
     /* body: CardStackUser(
        matchEngine: matchEngine,
      ),*/
      bottomNavigationBar: _buildBottomBar(),
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
                  SizedBox(height: 50,),
                  CircularProgressIndicator(),
                ],
              )
          ),
        ],
      ),
    );
  }
}

class RoundIconButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final double size;
  final VoidCallback onPressed;

  RoundIconButton.large({
    this.icon,
    this.iconColor,
    this.onPressed,
  }) : size = 60.0;

  RoundIconButton.small({
    this.icon,
    this.iconColor,
    this.onPressed,
  }) : size = 50.0;

  RoundIconButton({
    this.icon,
    this.iconColor,
    this.size,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: new BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            new BoxShadow(color: const Color(0x11000000), blurRadius: 10.0),
          ]),
      child: new RawMaterialButton(
        shape: new CircleBorder(),
        elevation: 0.0,
        child: new Icon(
          icon,
          color: iconColor,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
