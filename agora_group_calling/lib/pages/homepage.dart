import 'package:agora_group_calling/pages/callpage.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  final _userName = TextEditingController();
  final _channelName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height*0.1,
              ),
              Image.asset(
                'assets/logo.png',
                height: MediaQuery.of(context).size.height*0.08,
              ),
              Text(
                'Group Video Calling', 
                style: TextStyle(
                  color: Colors.white, 
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
              ),
              Center(
                child: Column(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width*0.8,
                      child: TextField(
                        style: TextStyle(color: Colors.white),
                        controller: _userName,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          hintText: 'Username',
                          hintStyle: TextStyle(color: Colors.white60),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(40),
                          ),   
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height*0.05,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width*0.8,
                      child: TextField(
                        controller: _channelName,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Channel Name',
                          hintStyle: TextStyle(color: Colors.white60),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(40),
                          ),   
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height*0.15,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width*0.5,
                      height: MediaQuery.of(context).size.height*0.07,
                      child: FlatButton(
                        onPressed: _onJoin,
                        color: Color(0xFF006AD8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                          side: BorderSide(
                            color: Color(0xFF006AD8)
                          )
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Get Started! ', 
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20
                              )
                            ),
                            Icon(
                              Icons.chevron_right,
                              color: Colors.white,
                              size: 30,
                            )
                          ],
                        )
                      ),
                    )
                  ],
                )
              )         
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onJoin() async{
    await _handleCameraAndMic(Permission.camera);
    await _handleCameraAndMic(Permission.microphone);

    Navigator.push(context, 
    MaterialPageRoute(builder: (context)=>CallPage(_channelName.text)
    )
   );
  }


  Future<void> _handleCameraAndMic(Permission permission) async{
    final status = await permission.request();
    print(status);
  }
}