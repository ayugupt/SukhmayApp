import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:sukhmay/login.dart';

import 'profilePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:geolocator/geolocator.dart';
import 'authentication.dart';
import 'main.dart';
import 'getUserData.dart';

import 'package:video_player/video_player.dart';
import 'mapPage.dart';
import 'JsonClass.dart';
import 'databaseClass.dart';
import 'package:flutter/semantics.dart';
import 'package:firebase_database/firebase_database.dart';

class HomePage extends StatefulWidget {
  HomePageState createState() => HomePageState();
}

AnimationController _controller;

class HomePageState extends State<HomePage> with TickerProviderStateMixin {
  Timer _timer;
  double _start = 1;
  VideoPlayerController _vidcontroller;
 Future<void> _initializeVideoPlayerFuture;
  int _selectedIndex = 0;
  bool run = true;
  static bool maps = false;
  bool sosSending = false;

  static Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  GeolocationStatus permissionStatus = GeolocationStatus.granted;
  static var locationOptions =
      LocationOptions(accuracy: LocationAccuracy.best, distanceFilter: 5);

  static Auth auth = new Auth();
  static GetUserData getData = new GetUserData();

  static Future<String> connectFlutterToBackend() async {
    if (Platform.isAndroid) {
      var channel = MethodChannel("com.example.sukhmay.messages");
      String data = await channel.invokeMethod("startService");
      print(data);
      return data;
    }
    return null;
  }

  String victimData;

  Future<void> locationPermission() async {
    GeolocationStatus stat =
        await Geolocator().checkGeolocationPermissionStatus();
    if (stat != GeolocationStatus.granted) {
      try {
        await geolocator.getCurrentPosition();
        permissionStatus =
            await Geolocator().checkGeolocationPermissionStatus();
      } catch (e) {
        permissionStatus =
            await Geolocator().checkGeolocationPermissionStatus();
      }
    } else {
      permissionStatus = stat;
    }
  }

  static Future<StreamSubscription<Position>> streamPositon(String path) async {
    String uid = await auth.returnUid();
    return geolocator
        .getPositionStream(locationOptions)
        .listen((Position position) {
      //MapPageState.lat = position.latitude;
      //MapPageState.long = position.longitude;
      dataBase.pushDataWithoutKey(path + "/$uid/Latitude", position.latitude);
      dataBase.pushDataWithoutKey(path + "/$uid/Longitude", position.longitude);
    });
  }

  static DatabaseClass dataBase = new DatabaseClass();

  static StreamSubscription<Position> alwaysPositionStream;
  static StreamSubscription<Position> sosPositionStream;

  Widget sos;
  List<Widget> itemWidgets = new List<Widget>();

  @override
  void initState() {
   _vidcontroller = VideoPlayerController.asset("images/tick.mp4");
   _initializeVideoPlayerFuture = _vidcontroller.initialize();
   _vidcontroller.setLooping(false);
   _vidcontroller.setVolume(0.0);
    _controller = AnimationController(
      vsync: this,
      lowerBound: 0.5,
      duration: Duration(seconds: 4),
    )..repeat();
    locationPermission().then((_) async {
      setState(() {});
      if (permissionStatus == GeolocationStatus.granted) {
        connectFlutterToBackend();
        //alwaysPositionStream = await streamPositon("Users");
      }
    });

    /*dataBase.sosAlert().then((stream) {
      stream.listen((event) async {
        victimData = await connectFlutterToBackend();
        setState(() {});
      });
    });*/

    itemWidgets = <Widget>[
      sosF(),
      FutureBuilder(
          future: getData.fetchData(),
          builder: (BuildContext c, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              List<dynamic> dataLis = snapshot.data;
              return ProfilePage(
                  dataLis[0], dataLis[1], dataLis[2], dataLis[3], dataLis[4]);
            } else {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          }),
      Icon(Icons.reorder)
    ];

    super.initState();
  }

  Widget sosSent(BuildContext c){
    return Container(
      decoration: BoxDecoration(
        color: Color(0x0350b3ab).withOpacity(1),
        border: Border.all(
          color: Color(0x0350b3ab),
          width: 0,
        ),
      ),
      child: Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:<Widget>[
            Text(
              'Don’t worry, Help is on it’s way!',
              style: TextStyle(
                fontSize: 17,
                color: Colors.white,
              ),
            ),
            Container(
              width: MediaQuery.of(c).size.width*0.7,
            child: FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    _vidcontroller.play();
                  return Center(
                      child: AspectRatio(
                      aspectRatio: _vidcontroller.value.aspectRatio,
                      child: VideoPlayer(_vidcontroller),
                      ),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
        ),
    );
  }

Widget startTimer(BuildContext c) {
  const oneSec = const Duration(milliseconds: 3);
  _timer = new Timer.periodic(
    oneSec,
    (Timer timer) => setState(
      () {
        if (_start < 0.1) {
          timer.cancel();
          setState(() {
                    _vidcontroller.seekTo(Duration(milliseconds: 500));
                    _start=1;
                    itemWidgets[0]=sosSent(c);
                  });
        } else {
          _start = _start - 0.01;
          itemWidgets[0]=transition(_start);
        }
      },
    ),
  );
}

Widget transition(double val){
  return Builder(
      builder: (BuildContext c) {
        return Center(
          child: Container(
            child: InkWell(
              child: Material(
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: new BorderRadius.all(Radius.circular(1000*_start)),
                    color: Color(0x0350b3ab),
                    border: Border.all(
                      color: Color(0x0350b3ab),
                      width: 0,
                    ),
                  ),
                  alignment: Alignment(0, 0),
                ),
              ),
            ),
            color: Colors.grey[850],
            width: MediaQuery.of(c).size.width*(1-_start),
            height: MediaQuery.of(c).size.height*(1-_start),
          ),
        );
      },
    );
}

  Widget sosF() {
    return Builder(
      builder: (BuildContext c) {
        return Center(
          child: Container(
            child: InkWell(
              child: Material(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[850],
                    border: Border.all(
                      color: Colors.grey[850],
                      width: 0,
                    ),
                  ),
                  alignment: Alignment(0, 0),
                  child: _buildBody(),
                ),
              ),
              onLongPress: () async {
                //connectFlutterToBackend();
                if (sosSending == false) {
                  sosSending = true;
                  //alwaysPositionStream.cancel();
                  sosPositionStream = await streamPositon("SOS");
                  Timer(Duration(minutes: 1), () async {
                    print("cancelled");
                    sosSending = false;
                    setState(() {
                      itemWidgets[0] = sosF();
                    });
                    sosPositionStream.cancel();
                    //alwaysPositionStream = await streamPositon("Users");
                    await dataBase.removeFromSos();
                  });
                  setState(() {

                    startTimer(c);
                  });
                }
              },
            ),
            color: Colors.grey[850],
            width: MediaQuery.of(c).size.width*1.5,
            height: MediaQuery.of(c).size.width*1.5,
          ),
        );
      },
    );
  }

  Widget _buildBody() {
    return AnimatedBuilder(
      animation: CurvedAnimation(parent: _controller, curve: Curves.linear),
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            _buildContainer(200),
            _buildContainer(200+50*(2*_controller.value-1)),
            _buildContainer(250+50*(2*_controller.value-1)),
            _buildContainer(300+50*(2*_controller.value-1)),
            _buildContainer(350+50*(2*_controller.value-1)),
            _buildContainer(400+50*(2*_controller.value-1)),
            _buildContainer(450+50*(2*_controller.value-1)),
            Align(
              child: Text(
                'SOS',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildContainer(double radius) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        border: Border.all(
          //color: Colors.cyan[(radius/50).round()*100-200],
          width: 0,
        ),
        shape: BoxShape.circle,
        color: Color(0x0350b3ab)
            .withOpacity((500 - radius)/500),
      ),
    );
  }

  Widget build(BuildContext context) {
    return permissionStatus == GeolocationStatus.granted
        ? Scaffold(
            backgroundColor: Colors.grey[850],
            body: itemWidgets[_selectedIndex],
            bottomNavigationBar: BottomNavigationBar(
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: Icon(Icons.home,color:_selectedIndex==0?Colors.blue:Colors.white), title: Text("Home",style:TextStyle(color:_selectedIndex==0?Colors.blue:Colors.white))),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person_pin,color:_selectedIndex==1?Colors.blue:Colors.white), title: Text("Profile",style:TextStyle(color:_selectedIndex==1?Colors.blue:Colors.white))),
                BottomNavigationBarItem(
                    icon: Icon(Icons.event,color:_selectedIndex==2?Colors.blue:Colors.white), title: Text("Events",style:TextStyle(color:_selectedIndex==2?Colors.blue:Colors.white))),
              ],
              currentIndex: _selectedIndex,
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              selectedItemColor: Colors.blue,
              backgroundColor: Color(0x33333333),
            ),
            floatingActionButton: Row(
              children: <Widget>[
                FloatingActionButton(
                  child: Icon(Icons.exit_to_app),
                  onPressed: () {
                    OpeningScreenState.authStatus = AuthStatus.NOT_LOGGED_IN;
                    auth.logOut();
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (BuildContext c) {
                      return LoginPage();
                    }), (Route<dynamic> route) => false);
                  },
                  backgroundColor: Colors.blueAccent,
                  heroTag: 1,
                ),
                SizedBox(width: 20),
                FloatingActionButton(
                    child: Icon(Icons.map),
                    onPressed: () async {
                      maps = !maps;
                      if (maps == true) {
                        //alwaysPositionStream.cancel();
                        itemWidgets[0] = MapPage();
                      } else {
                        MapPageState.streamSub.cancel();
                        //alwaysPositionStream = await streamPositon("Users");
                        if (sosSending == false) {
                          itemWidgets[0] = sosF();
                        } else {
                          itemWidgets[0] = sosSent(context);
                        }
                      }
                      setState(() {});
                    },
                    heroTag: 2,
                    backgroundColor: Colors.green)
              ],
              mainAxisAlignment: MainAxisAlignment.end,
            ))
        : Scaffold(
            body: Container(
              child: Center(
                child: Column(
                  children: <Widget>[
                    Text(
                        "You cannot use the app without giving permission.(Choose 'Allow all the time')"),
                    RaisedButton(
                      child: Text("OK"),
                      onPressed: () {
                        locationPermission().then((_) async {
                          setState(() {});

                          if (permissionStatus == GeolocationStatus.granted) {
                            alwaysPositionStream = await streamPositon("Users");
                          }
                        });
                      },
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
              ),
            ),
          );
  }
}
