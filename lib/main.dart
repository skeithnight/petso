import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:petso/screens/login_screen.dart';
import 'package:petso/screens/splash_screen.dart';
import 'package:petso/screens/main_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Position _position;
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  String fcmToken = '';
  @override
  void initState() {
    super.initState();
    _initPlatformState();
    firebaseCloudMessaging_Listeners();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void _initPlatformState() async {
    Position position;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      // Geolocator geolocator = Geolocator()..forceAndroidLocationManager = true;
      position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      print("position");
    } on Exception {
      print("object");
      position = null;
    }
    print(position.latitude.toString()+" : "+ position.longitude.toString());
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }
  Widget _handleCurrentScreen() {
    return StreamBuilder<FirebaseUser>(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print("Waiting......");
            // _onLoading();
            // return Navigator.of(context).pushNamed('/');
            return new SplashScreen();
          } else {
            if (snapshot.hasData) {
              // return Container();
              return new MainScreen();
            }
            print("Kosong");
            return new LoginScreen();
          }
        });
  }
void firebaseCloudMessaging_Listeners() {
    // Firebase messaging
    _firebaseMessaging.subscribeToTopic("rekom3bln");

    _firebaseMessaging.getToken().then((token) {
      print("Token"+token);
    });
  }
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Petso",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.lightBlue, fontFamily: 'Nunito'),
      home: _handleCurrentScreen(),
    );
  }
}
