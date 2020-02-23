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

class HomePageState extends State<HomePage>{
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
                  alignment: Alignment(0, 0),
                  child: Text(
                    'SOS',
                    style: TextStyle(
                      fontSize: 90,
                      color: Colors.white,
                    ),
                  ), 
                ),
                color: Colors.red[800],
                shape: CircleBorder(),
                elevation: 30.0,
                shadowColor: Colors.black,
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
            width: MediaQuery.of(c).size.width * 0.7,
            height: MediaQuery.of(c).size.width * 0.7, 
            
          ),
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return permissionStatus == GeolocationStatus.granted
        ? Scaffold(
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
