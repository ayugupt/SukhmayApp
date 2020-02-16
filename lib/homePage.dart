import 'dart:async';
import 'package:http/http.dart';

import 'profilePage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'authentication.dart';
import 'main.dart';
import 'userChoice.dart';
import 'getUserData.dart';

import 'JsonClass.dart';
import 'databaseClass.dart';

class HomePage extends StatefulWidget {
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  GeolocationStatus permissionStatus = GeolocationStatus.granted;
  static var locationOptions =
      LocationOptions(accuracy: LocationAccuracy.best, distanceFilter: 5);

  static Auth auth = new Auth();
  static GetUserData getData = new GetUserData();

  Future<void> locationPermission() async {
    //geolocator = Geolocator()..forceAndroidLocationManager;
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

  static DatabaseJson jsonData = new DatabaseJson();
  static DatabaseClass dataBase = new DatabaseClass();

  @override
  void initState() {
    locationPermission().then((_) {
      setState(() {});
    });
    super.initState();
  }

  List<Widget> itemWidgets = <Widget>[
    Builder(
      builder: (BuildContext c) {
        return Center(
          child: Container(
            child: InkWell(
              child: Material(
                child: Container(
                  alignment: Alignment(0,0),
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
              onTap: () async {
                String uid = await auth.returnUid();

                StreamSubscription<Position> positionStream = geolocator
                    .getPositionStream(locationOptions)
                    .listen((Position position) {
                  jsonData.lat = position.latitude;
                  jsonData.long = position.longitude;
                  jsonData.sos = true;
                  dataBase.pushDataWithoutKey(
                      "Citizen/$uid", jsonData.toJson());
                  print(position == null
                      ? 'Unknown'
                      : position.latitude.toString() +
                          ', ' +
                          position.longitude.toString());
                  //position.latitude and position.longitude is to be sent to database
                  Scaffold.of(c).showSnackBar(SnackBar(
                    content: Text(
                        "Lat: ${position.latitude} Long: ${position.longitude}"),
                  ));
                });
                Timer(Duration(seconds: 10), () {
                  print("cancelled");
                  DatabaseJson finalJson = jsonData;
                  finalJson.sos = false;
                  dataBase.pushDataWithoutKey(
                      "Citizen/$uid", finalJson.toJson());
                  positionStream.cancel();
                });
              },
            ),
            width: MediaQuery.of(c).size.width * 0.7,
            height: MediaQuery.of(c).size.width * 0.7,
          ),
        );
      },
    ),
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
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.exit_to_app),
              onPressed: () {
                OpeningScreenState.authStatus = AuthStatus.NOT_LOGGED_IN;
                auth.logOut();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (BuildContext c) {
                  return UserChoice();
                }), (Route<dynamic> route) => false);
              },
              backgroundColor: Colors.grey,
            ),
          )
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
                        locationPermission().then((_) {
                          setState(() {});
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
