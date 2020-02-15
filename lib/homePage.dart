import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'authentication.dart';
import 'main.dart';
import 'userChoice.dart';

class HomePage extends StatefulWidget {
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  GeolocationStatus permissionStatus = GeolocationStatus.granted;
  static var locationOptions =
      LocationOptions(accuracy: LocationAccuracy.best, distanceFilter: 5);

  Auth auth = new Auth();

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
              child: Image.asset(
                "images/sos.png",
                fit: BoxFit.fill,
              ),
              onTap: () {
                StreamSubscription<Position> positionStream = geolocator
                    .getPositionStream(locationOptions)
                    .listen((Position position) {
                  print(position == null
                      ? 'Unknown'
                      : position.latitude.toString() +
                          ', ' +
                          position.longitude.toString());
                          //position.latitude and position.longitude is to be sent to database
                  /*Scaffold.of(c).showSnackBar(SnackBar(
                    content: Text(
                        "Lat: ${position.latitude} Long: ${position.longitude}"),
                  ));*/
                });
              },
            ),
            decoration: BoxDecoration(color: Colors.black),
            width: MediaQuery.of(c).size.width * 0.7,
            height: MediaQuery.of(c).size.width * 0.7,
          ),
        );
      },
    ),
    Icon(Icons.remove_red_eye),
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
