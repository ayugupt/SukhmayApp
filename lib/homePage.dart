import 'dart:async';
import 'package:sukhmay/login.dart';

import 'profilePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:geolocator/geolocator.dart';
import 'authentication.dart';
import 'main.dart';
import 'getUserData.dart';

import 'mapPage.dart';
import 'JsonClass.dart';
import 'databaseClass.dart';

class HomePage extends StatefulWidget {
  HomePageState createState() => HomePageState();
}

AnimationController _controller;

class HomePageState extends State<HomePage> with TickerProviderStateMixin{
  int _selectedIndex = 0;

  static bool maps = false;

  static Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  GeolocationStatus permissionStatus = GeolocationStatus.granted;
  static var locationOptions =
      LocationOptions(accuracy: LocationAccuracy.best, distanceFilter: 5);

  static Auth auth = new Auth();
  static GetUserData getData = new GetUserData();

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
      MapPageState.lat = position.latitude;
      MapPageState.long = position.longitude;
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
    _controller = AnimationController(
      vsync: this,
      lowerBound: 0.5,
      duration: Duration(seconds: 3),
    )..repeat();
    locationPermission().then((_) async {
      setState(() {});
      if (permissionStatus == GeolocationStatus.granted) {
        alwaysPositionStream = await streamPositon("Users");
      }
    });


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
                alwaysPositionStream.cancel();
                sosPositionStream = await streamPositon("SOS");
                Timer(Duration(minutes: 5), () async {
                  print("cancelled");
                  sosPositionStream.cancel();
                  alwaysPositionStream = await streamPositon("Users");
                });
              },
            ),
            color:Colors.grey[850],
            width: MediaQuery.of(c).size.width * 0.8,
            height: MediaQuery.of(c).size.width * 0.8, 
            
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
              _buildContainer((1367.879 - 8142.996*_controller.value + 17771.74*_controller.value*_controller.value - 16457.44*_controller.value*_controller.value*_controller.value + 5485.813*_controller.value*_controller.value*_controller.value*_controller.value - 4.439086e-8*_controller.value*_controller.value*_controller.value*_controller.value*_controller.value)),
              _buildContainer(2*(1367.879 - 8142.996*_controller.value + 17771.74*_controller.value*_controller.value - 16457.44*_controller.value*_controller.value*_controller.value + 5485.813*_controller.value*_controller.value*_controller.value*_controller.value - 4.439086e-8*_controller.value*_controller.value*_controller.value*_controller.value*_controller.value)),
              _buildContainer(3*(1367.879 - 8142.996*_controller.value + 17771.74*_controller.value*_controller.value - 16457.44*_controller.value*_controller.value*_controller.value + 5485.813*_controller.value*_controller.value*_controller.value*_controller.value - 4.439086e-8*_controller.value*_controller.value*_controller.value*_controller.value*_controller.value)),
              _buildContainer(4*(1367.879 - 8142.996*_controller.value + 17771.74*_controller.value*_controller.value - 16457.44*_controller.value*_controller.value*_controller.value + 5485.813*_controller.value*_controller.value*_controller.value*_controller.value - 4.439086e-8*_controller.value*_controller.value*_controller.value*_controller.value*_controller.value)),
              _buildContainer(5*(1367.879 - 8142.996*_controller.value + 17771.74*_controller.value*_controller.value - 16457.44*_controller.value*_controller.value*_controller.value + 5485.813*_controller.value*_controller.value*_controller.value*_controller.value - 4.439086e-8*_controller.value*_controller.value*_controller.value*_controller.value*_controller.value)),
              _buildContainer(6*(1367.879 - 8142.996*_controller.value + 17771.74*_controller.value*_controller.value - 16457.44*_controller.value*_controller.value*_controller.value + 5485.813*_controller.value*_controller.value*_controller.value*_controller.value - 4.439086e-8*_controller.value*_controller.value*_controller.value*_controller.value*_controller.value)),
              _buildContainer(7*(1367.879 - 8142.996*_controller.value + 17771.74*_controller.value*_controller.value - 16457.44*_controller.value*_controller.value*_controller.value + 5485.813*_controller.value*_controller.value*_controller.value*_controller.value - 4.439086e-8*_controller.value*_controller.value*_controller.value*_controller.value*_controller.value)),
              _buildContainer(8*(1367.879 - 8142.996*_controller.value + 17771.74*_controller.value*_controller.value - 16457.44*_controller.value*_controller.value*_controller.value + 5485.813*_controller.value*_controller.value*_controller.value*_controller.value - 4.439086e-8*_controller.value*_controller.value*_controller.value*_controller.value*_controller.value)),
              _buildContainer(400),
              Align(
                child: Text(
                    'SOS',
                    style: TextStyle(
                      fontSize: 30,
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
          color: Colors.purple[(-80*_controller.value*_controller.value+120*_controller.value-35).round()*100-100],
          width:radius*0.01,
        ),
        shape: BoxShape.circle,
        color: Colors.purple[(-64*_controller.value*_controller.value+96*_controller.value-27).round()*100-300].withOpacity(1 - 0.5*_controller.value),
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
                    icon: Icon(Icons.home), title: Text("Home")),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person), title: Text("Profile")),
                BottomNavigationBarItem(
                    icon: Icon(Icons.event), title: Text("Events")),
              ],
              currentIndex: _selectedIndex,
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              selectedItemColor: Colors.white,
              backgroundColor: Colors.grey,
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
                  backgroundColor: Colors.grey,
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
                        MapPageState.stream.cancel();
                        //alwaysPositionStream = await streamPositon("Users");
                        itemWidgets[0] = sosF();
                      }
                      setState(() {});
                    },
                    heroTag: 2,
                    backgroundColor: Colors.grey)
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
