import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:petso/data.dart' as data;

import 'package:petso/screens/petshop_screen.dart';
import 'package:petso/screens/konsultasi_screen.dart';
import 'package:petso/screens/kawin_screen.dart';
import 'package:petso/screens/profile_screen.dart';
// import 'request_darah_screen.dart' as requestDarah;

class MainScreen extends StatelessWidget {
  static String tag = 'main-page';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = new GoogleSignIn();

  Future<Null> _signOut() async {
    await FirebaseAuth.instance.signOut();
    await googleSignIn.signOut();
  }

  Widget bottomNavigator() => TabBar(
        labelColor: Colors.black,
        tabs: <Widget>[
          Tab(
            icon: new Icon(
              Icons.store,
              color: Colors.black,
            ),
            text: "Petshop",
          ),
          Tab(
              icon: new Icon(
                Icons.local_hospital,
                color: Colors.black,
              ),
              text: "Konsultasi"),
          Tab(
              icon: new Icon(
                Icons.pets,
                color: Colors.black,
              ),
              text: "Pacak"),
          Tab(
              icon: new Icon(
                Icons.person,
                color: Colors.black,
              ),
              text: "Profile"),
        ],
      );
  Widget appBar() => new AppBar(
        title: Text(data.appName),
        // actions: <Widget>[
        //   IconButton(
        //     icon: Icon(
        //       Icons.exit_to_app,
        //       color: Colors.white,
        //     ),
        //     onPressed: () {
        //       _signOut();
        //     },
        //   )
        // ],
      );
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      color: Colors.yellow,
      home: DefaultTabController(
        length: 4,
        child: SafeArea(
          child: Scaffold(
            // appBar: appBar(),
            body: TabBarView(
              children: <Widget>[
                new PetshopScreen(),
                new KonsultasiScreen(),
                new KawinScreen(),
                new ProfileScreen()
              ],
            ),
            bottomNavigationBar: bottomNavigator(),
          ),
        ),
      ),
    );
  }
}
