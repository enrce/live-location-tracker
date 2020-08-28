import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';

import './map.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Live location tracker',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHomePage(title: 'Live location tracker'),
        routes: {
          LocationTracker.routeName: (ctx) => LocationTracker(),
        });
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _initialized = false;
  bool _error = false;

  // ignore: avoid_init_to_null
  LocationData locationData = null;

  void initState() {
    super.initState();
    initializeFlutterFire();
  }

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  Future<void> startSendingLocation() async {
    try {
      Location location = Location();
      final locData = await location.getLocation();
      sendLocation(locData);

      location.onLocationChanged.listen((LocationData currentLocData) {
        sendLocation(currentLocData);
      });
    } catch (error) {
      return;
    }
  }

  void sendLocation(LocationData location) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    users
        .doc('ABC123')
        .update({
          'location': GeoPoint(
            location.latitude,
            location.longitude,
          ),
        })
        .then((value) => print('location updated'))
        .catchError((error) => print('Failed to update data: $error'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: !_initialized
              ? <Widget>[
                  Text(
                    'Initialising app ...',
                  ),
                ]
              : <Widget>[
                  RaisedButton(
                      child: Text('Share live location'),
                      onPressed: startSendingLocation),
                  RaisedButton(
                      child: Text('Track live location'),
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(LocationTracker.routeName);
                      }),
                ],
        ),
      ),
    );
  }
}
