import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LocationTracker extends StatefulWidget {
  static const routeName = './map';

  @override
  _LocationTrackerState createState() => _LocationTrackerState();
}

class _LocationTrackerState extends State<LocationTracker> {
  final Completer<GoogleMapController> _controller = Completer();

  // ignore: avoid_init_to_null
  double latitude = null;
  // ignore: avoid_init_to_null
  double longitude = null;

  void getLocationData() {}

  @override
  Widget build(BuildContext context) {
    if (latitude == null && longitude == null) {
      DocumentReference user =
          FirebaseFirestore.instance.collection('users').doc('ABC123');

      return StreamBuilder<DocumentSnapshot>(
        stream: user.snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Loading location ...',
                  ),
                ],
              ),
            );
          }

          GeoPoint location = snapshot.data.data()['location'];
          latitude = location.latitude;
          longitude = location.longitude;

          GoogleMapController mapController;

          return Scaffold(
              appBar: AppBar(),
              body: GoogleMap(
                circles: {
                  Circle(
                      circleId: CircleId("c1"),
                      radius: 10,
                      strokeWidth: 1,
                      fillColor: Colors.red,
                      center: LatLng(
                        latitude,
                        longitude,
                      ))
                },
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: LatLng(latitude, longitude),
                  zoom: 16,
                ),
                onCameraMove: (CameraPosition c) {
                  mapController.animateCamera(CameraUpdate.newLatLng(
                    LatLng(c.target.latitude, c.target.longitude),
                  ));
                },
                onMapCreated: (GoogleMapController controller) {
                  mapController = controller;
                  _controller.complete(controller);
                },
              ));
        },
      );
    }
  }
}
