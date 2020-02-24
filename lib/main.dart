import 'package:flutter/material.dart';
import 'package:flutter_bss_api/pages/favorite_page.dart';
import 'package:flutter_bss_api/pages/user_page.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Api'),
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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Favorite()),
              );
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(8) ,
              decoration: BoxDecoration(
                gradient: new LinearGradient(
                    colors: [
                      Color(0xff1976D2),
                      Color(0xff448AFF),
                    ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),

              child: Stack(
                children: <Widget>[
                  _buildProfileCard(),
                  UserPage(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildProfileCard(){
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
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
                      borderRadius: BorderRadius.circular(12),
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

  Widget _buildProfile(){
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 400,
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
                        padding: const EdgeInsets.all(4),
                        child: Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage("http://api.randomuser.me/portraits/women/87.jpg")
                              )
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    'My address is',
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                  SizedBox(height: 15,),
                  Text(
                    '4661 Aubuun Ave',
                    style: TextStyle(fontSize: 26, color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20,),
                  Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: InkWell(
                            child: Image(
                              image: AssetImage('assets/icons/ic_user_default.png'),
                              width: 40,
                              height: 40,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: InkWell(
                            child: Image(
                              image: AssetImage('assets/icons/ic_schedule_default.png'),
                              width: 40,
                              height: 40,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: InkWell(
                            child: Image(
                              image: AssetImage('assets/icons/ic_map_selected.png'),
                              width: 40,
                              height: 40,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: InkWell(
                            child: Image(
                              image: AssetImage('assets/icons/ic_phone_default.png'),
                              width: 40,
                              height: 40,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: InkWell(
                            child: Image(
                              image: AssetImage('assets/icons/ic_privacy_default.png'),
                              width: 40,
                              height: 40,
                            ),
                          ),
                        )
                      ],
                    ),
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
