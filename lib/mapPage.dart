import 'dart:async';
import 'dart:core';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'databaseClass.dart';
import 'homePage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'authentication.dart';

class MapPage extends StatefulWidget {
  MapPageState createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  double lat;
  double long;
  GoogleMapController mapController;
  bool mapCreated = false;

  DatabaseClass dataBase = new DatabaseClass();
  String victimData;

  Geolocator locator = Geolocator();

  static StreamSubscription<Position> streamSub;

  bool helpNeeded = false;

  static StreamSubscription victimStream;
  //Set<Marker> victimMarkerSet = new Set<Marker>();
  MarkerId markerId = new MarkerId("Victim");
  Marker victimMarker;
  Map<MarkerId, Marker> victimMarkerMap = <MarkerId, Marker>{};

  DatabaseReference vic;
  String uid;

  //Auth auth = new Auth();

  @override
  void initState() {
    //victimMarkerSet.add(victimMarker);
    lat = 100.0;
    long = 50.0;
    victimMarker = new Marker(markerId: markerId);
    victimMarkerMap[markerId] = victimMarker;
    locator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((pos) {
      setState(() {
        lat = pos.latitude;
        long = pos.longitude;
      });
    });

    dataBase.sosAlert().then((stream) {
      stream.listen((event) async {
        victimData = await HomePageState.connectFlutterToBackend();
        if (victimData != "" && helpNeeded == false) {
          vic =
              FirebaseDatabase.instance.reference().child("Users/$victimData");

          vic.once().then((snap) {
            setState(() {
              helpNeeded = true;
              victimMarker = new Marker(
                  markerId: markerId,
                  position:
                      LatLng(snap.value["Latitude"], snap.value["Longitude"]));
              victimMarkerMap[markerId] = victimMarker;
            });
          });
        }
      });
    });

    streamSub = locator
        .getPositionStream(LocationOptions(
            accuracy: LocationAccuracy.best, distanceFilter: 10))
        .listen((Position position) {
      if (mapCreated) {
        print("Lat: ${position.latitude}, Long: ${position.longitude}");
        mapController.moveCamera(CameraUpdate.newLatLng(
            LatLng(position.latitude, position.longitude)));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (helpNeeded) {
      victimStream =
          dataBase.getVictimsLocation(victimData).listen((event) async {
        DataSnapshot snaps = await vic.once();
        if (mapCreated) {
          //victimMarkerSet.remove(victimMarker);
          if (event.snapshot.key == "Latitude") {
            victimMarker = new Marker(
              markerId: markerId,
              position: LatLng(event.snapshot.value, snaps.value["Longitude"]),
            );
          } else if (event.snapshot.key == "Longitude") {
            victimMarker = new Marker(
              markerId: markerId,
              position: LatLng(snaps.value["Latitude"], event.snapshot.value),
            );
          }
          //victimMarkerSet.add(victimMarker);
        }
        setState(() {
          victimMarkerMap[markerId] = victimMarker;
        });
      });
      Timer(Duration(minutes: 1), () {
        victimStream.cancel();
        setState(() {
          victimMarker = new Marker(markerId: markerId);
          victimMarkerMap[markerId] = victimMarker;
        });
      });
      helpNeeded = false;
    }
    return Container(
      child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(lat, long),
            zoom: 15,
          ),
          buildingsEnabled: false,
          myLocationEnabled: true,
          onMapCreated: (controller) {
            mapController = controller;
            mapCreated = true;
          },
          markers: Set<Marker>.of(victimMarkerMap.values)),
    );
  }
}
