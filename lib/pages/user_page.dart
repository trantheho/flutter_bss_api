import 'package:flutter/material.dart';
import 'package:flutter_bss_api/bloc/user_bloc.dart';
import 'package:flutter_bss_api/models/result.dart';
import 'package:flutter_bss_api/models/user.dart';
import 'package:flutter_bss_api/responses/user_response.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc.getUser();
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
          Text('Please wait to loading data...'),
          CircularProgressIndicator(),
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
