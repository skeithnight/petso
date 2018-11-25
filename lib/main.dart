import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:petso/screens/login_screen.dart';
import 'package:petso/screens/splash_screen.dart';
import 'package:petso/screens/main_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
              return new MainScreen();
            }
            print("Kosong");
            return new LoginScreen();
          }
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
