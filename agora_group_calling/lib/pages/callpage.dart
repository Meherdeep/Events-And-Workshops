import 'package:agora_group_calling/utils/appId.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';

class CallPage extends StatefulWidget {
  final String channelName; 
  CallPage(this.channelName);
  @override
  _CallPageState createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {  
  static final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false; 

  @override
  void initState() { 
    super.initState();
    initialize();
  }

  @override
  void dispose(){
    _users.clear();
    AgoraRtcEngine.leaveChannel();
    AgoraRtcEngine.destroy();
    super.dispose();
  }

  Future<void> initialize() async{ 
    await _addAgoraRtcEngine();
    _addAgoraEventHandlers();
    await AgoraRtcEngine.enableWebSdkInteroperability(true);
    VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    configuration.dimensions = Size(1280, 720);
    await AgoraRtcEngine.setVideoEncoderConfiguration(configuration);
    await AgoraRtcEngine.joinChannel(null, widget.channelName, null, 0);
  }

  Future<void> _addAgoraRtcEngine() async {
    await AgoraRtcEngine.create(APP_ID);
    await AgoraRtcEngine.enableVideo();
  }

  /// agora event handlers
  void _addAgoraEventHandlers() {
    AgoraRtcEngine.onError = (dynamic code) {
      setState(() {
        final info = 'onError: $code';
        _infoStrings.add(info);
      });
    };

    /// Use this function to obtain the uid of the person who joined the channel 
    AgoraRtcEngine.onJoinChannelSuccess = (
      String channel,
      int uid,
      int elapsed,
    ) {
      setState(() {
        final info = 'onJoinChannel: $channel, uid: $uid';
        _infoStrings.add(info);
      });
    };

    AgoraRtcEngine.onLeaveChannel = () {
      setState(() {
        _infoStrings.add('onLeaveChannel');
        _users.clear();
      });
    };

    AgoraRtcEngine.onUserJoined = (int uid, int elapsed) {
      setState(() {
        final info = 'userJoined: $uid';
        _infoStrings.add(info);
        _users.add(uid);
      });
    };

    AgoraRtcEngine.onUserOffline = (int uid, int reason) {
      setState(() {
        final info = 'userOffline: $uid';
        _infoStrings.add(info);
        _users.remove(uid);
      });
    };

    AgoraRtcEngine.onFirstRemoteVideoFrame = (
      int uid,
      int width,
      int height,
      int elapsed,
    ) {
      setState(() {
        final info = 'firstRemoteVideo: $uid ${width}x $height';
        _infoStrings.add(info);
      });
    };
  }

  List<Widget> _getRenderViews() {
    final List<AgoraRenderWidget> list = [
      AgoraRenderWidget(0, local: true, preview: true)
    ];
    _users.forEach((int uid)=> list.add(AgoraRenderWidget(uid)));
    return list;
  }

  Widget _videoView(view) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: view,
    );
  }

  Widget _expandedViewRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      )
    );
  }

  Widget _viewRows() {
    final views = _getRenderViews();
    switch (views.length) {
      case 1:
        return Container(
          child: Column(
            children: <Widget>[
              _videoView(views[0])
            ],
          ),
        );
      case 2:
        return Container(
          child: Column(
            children: <Widget>[
              _expandedViewRow([views[0]]),
              _expandedViewRow([views[1]]),
            ],
          ),
        );
      case 3:
        return Container(
          child: Column(
            children: <Widget>[
              _expandedViewRow(views.sublist(0,2)),
              _expandedViewRow(views.sublist(2,3)),
            ],
          ),
        );
      case 4:
        return Container(
          child: Column(
            children: <Widget>[
              _expandedViewRow(views.sublist(0,2)),
              _expandedViewRow(views.sublist(2,4)),
            ],
          ),
        );   
      default:
    }
    return Container();
  }

  Widget _controlFunctions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.mic_off), 
          onPressed: _toggleMicrophone,
        ),
        IconButton(
          icon: Icon(
            Icons.call_end,
            color: Colors.red,
          ), 
          onPressed: _disconnectCall,
        ),
        IconButton(
          icon: Icon(Icons.switch_camera), 
          onPressed: _switchCamera
        )

      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _viewRows(),
          Align(
            alignment: Alignment.bottomCenter,
            child: _controlFunctions(),
          )
        ],
      ),
     
    );
  }

  void _toggleMicrophone() async{
    setState(() {
      muted = !muted;
    });
    await AgoraRtcEngine.disableAudio();
  }

  void _switchCamera() async{
    await AgoraRtcEngine.switchCamera();
  }

  void _disconnectCall() {
    Navigator.pop(context);
  } 
} 