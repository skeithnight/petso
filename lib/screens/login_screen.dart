import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  LoginScreenState createState() => new LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final GoogleSignIn googleSignIn = new GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  final mainReference = FirebaseDatabase.instance.reference();

  bool isLoading = false;
  bool isLoggedIn = false;
  FirebaseUser currentUser;

  @override
  void initState() {
    super.initState();
    isSignedIn();
  }

  void isSignedIn() async {
    this.setState(() {
      isLoading = true;
    });
    // prefs = await SharedPreferences.getInstance();

    isLoggedIn = await googleSignIn.isSignedIn();
    if (isLoggedIn) {
      print("done");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    }

    this.setState(() {
      isLoading = false;
    });
  }

  Future<Null> handleSignIn() async {
    // prefs = await SharedPreferences.getInstance();

    this.setState(() {
      isLoading = true;
    });
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    GoogleSignInAccount googleUser = await googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    FirebaseUser firebaseUser = await firebaseAuth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    if (firebaseUser != null) {
      // print('not null');
      // Check is already sign up

      DataSnapshot dataSnapshot =
          await mainReference.child("users").child(firebaseUser.uid).once();
      if (dataSnapshot.value == null) {
        // print("ada");
        mainReference.child("users").child(firebaseUser.uid).set({
          'name': firebaseUser.displayName,
          'photoUrl': firebaseUser.photoUrl,
          'email': firebaseUser.email,
          'phoneNumber': firebaseUser.phoneNumber,
        });
        _prefs.setString('id', firebaseUser.uid);
        _prefs.setString('name', firebaseUser.displayName);
        _prefs.setString('photoUrl', firebaseUser.photoUrl);
        _prefs.setString('email', firebaseUser.email);
        _prefs.setString('phoneNumber', firebaseUser.phoneNumber);
        _prefs.commit();
      } else {
        // print('kosong');
        _prefs.setString('id', dataSnapshot.key);
        _prefs.setString('name', dataSnapshot.value['name']);
        _prefs.setString('photoUrl', dataSnapshot.value['photoUrl']);
        _prefs.setString('email', dataSnapshot.value['email']);
        _prefs.setString('phoneNumber', dataSnapshot.value['phoneNumber']);

        _prefs.commit();
      }
      Fluttertoast.showToast(msg: "Sign in success");
      this.setState(() {
        isLoading = false;
      });
      print("Login");
    } else {
      Fluttertoast.showToast(msg: "Sign in fail");
      this.setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Center(
          child: FlatButton(
              onPressed: handleSignIn,
              child: Text(
                'SIGN IN WITH GOOGLE',
                style: TextStyle(fontSize: 16.0),
              ),
              color: Color(0xffdd4b39),
              highlightColor: Color(0xffff7f7f),
              splashColor: Colors.transparent,
              textColor: Colors.white,
              padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0)),
        ),

        // Loading
        Positioned(
          child: isLoading
              ? Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                  color: Colors.white.withOpacity(0.8),
                )
              : Container(),
        ),
      ],
    ));
  }
}
