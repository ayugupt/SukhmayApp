import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class MapPage extends StatefulWidget {
  MapPageState createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  static double lat;
  static double long;
  GoogleMapController mapController;
  bool mapCreated = false;

  Geolocator locator = Geolocator();

  static StreamSubscription<Position> stream;

  @override
  void initState() {
    stream = locator
        .getPositionStream(
            LocationOptions(accuracy: LocationAccuracy.best, distanceFilter: 1))
        .listen((Position position) {
      if (mapCreated) {
        print("Bruh");
        mapController.moveCamera(CameraUpdate.newLatLng(
            LatLng(position.latitude, position.longitude)));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(lat, long),
          zoom: 15,
        ),
        buildingsEnabled: false,
        myLocationEnabled: true,
        scrollGesturesEnabled: false,
        onMapCreated: (controller) {
          mapController = controller;
          mapCreated = true;
        },
      ),
    );
  }
}
