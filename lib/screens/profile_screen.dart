import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';

import 'kelola_hewan_screen.dart';

class ProfileScreen extends StatefulWidget {
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = new GoogleSignIn();
  SharedPreferences prefs;
  String photoUrl = "https://img.icons8.com/metro/1600/gender-neutral-user.png";
  String id, name, email, phoneNumber;

  final mainReference = FirebaseDatabase.instance.reference();

  bool isLoading = true;

  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getString('id') ?? '';
      name = prefs.getString('name') ?? '';
      email = prefs.getString('email') ?? '';
      photoUrl = prefs.getString('photoUrl') ?? '';
      phoneNumber = prefs.getString('phoneNumber') ?? '';
      isLoading = false;
    });
    print(isLoading);
  }

  Future<Null> _signOut() async {
    await FirebaseAuth.instance.signOut();
    await googleSignIn.signOut();
    await prefs.clear();
  }

  pushEditData() {
    // print(name);
    if (email != '' || name != '') {
      if (phoneNumber != '') {
        // print('ada');
        mainReference.child("users").child(id).set({
          'name': name,
          'email': email,
          'phoneNumber': phoneNumber,
        });
        prefs.setString('name', name);
        prefs.setString('email', email);
        prefs.setString('phoneNumber', phoneNumber);
        prefs.commit();
      }
    }
  }

  Widget profileContent() => Container(
        width: double.infinity,
        margin: EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              // Name
              Container(
                width: double.infinity,
                child: Text(
                  'Name',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                margin: EdgeInsets.only(left: 10.0, bottom: 5.0, top: 10.0),
              ),
              Container(
                child: Theme(
                  data: Theme.of(context).copyWith(),
                  child: TextField(
                    onChanged: (text) {
                      setState(() {
                        this.name = text;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: name,
                      contentPadding: new EdgeInsets.all(5.0),
                      hintStyle: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                margin: EdgeInsets.only(left: 30.0, right: 30.0),
              ),
              // Name
              Container(
                width: double.infinity,
                child: Text(
                  'Email',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                margin: EdgeInsets.only(left: 10.0, bottom: 5.0, top: 10.0),
              ),
              Container(
                child: Theme(
                  data: Theme.of(context).copyWith(),
                  child: TextField(
                    onChanged: (text) {
                      setState(() {
                        this.email = text;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: email,
                      contentPadding: new EdgeInsets.all(5.0),
                      hintStyle: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                margin: EdgeInsets.only(left: 30.0, right: 30.0),
              ),
              // phoneNumber
              Container(
                width: double.infinity,
                child: Text(
                  'Phone Number',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                margin: EdgeInsets.only(left: 10.0, bottom: 5.0, top: 10.0),
              ),
              Container(
                child: Theme(
                  data: Theme.of(context).copyWith(),
                  child: TextField(
                    onChanged: (text) {
                      setState(() {
                        this.phoneNumber = text;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: phoneNumber,
                      contentPadding: new EdgeInsets.all(5.0),
                      hintStyle: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                margin: EdgeInsets.only(left: 30.0, right: 30.0),
              ),
              // edit data
              editData(),
              // kelola Toko
              kelolaToko(),
              // kelola hewan peliharaan
              kelolaHewan(),
            ],
          ),
        ),
      );

  Widget editData() => new Container(
        margin: EdgeInsets.all(10.0),
        child: Align(
          alignment: FractionalOffset.bottomCenter,
          child: SizedBox(
            width: double.infinity,
            height: 50.0,
            child: new RaisedButton(
              color: Colors.lightGreen,
              child: Text(
                "Edit Data",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: pushEditData,
            ),
          ),
        ),
      );
  Widget kelolaToko() => new Container(
        margin: EdgeInsets.all(10.0),
        child: Align(
          alignment: FractionalOffset.bottomCenter,
          child: SizedBox(
            width: double.infinity,
            height: 50.0,
            child: new RaisedButton(
              color: Colors.orange,
              child: Text(
                "Store Management",
                style: TextStyle(color: Colors.white),
              ),
              // onPressed: _signOut,
            ),
          ),
        ),
      );
  Widget kelolaHewan() => new Container(
        margin: EdgeInsets.all(10.0),
        child: Align(
          alignment: FractionalOffset.bottomCenter,
          child: SizedBox(
            width: double.infinity,
            height: 50.0,
            child: new RaisedButton(
              color: Colors.orange,
              child: Text(
                "Pet Management",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => KelolaHewanScreen()));
              },
            ),
          ),
        ),
      );

  Widget profile() => new Center(
        child: Container(
          margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
          width: double.infinity,
          child: Center(
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(height: 50.0),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.lightBlue,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10.0,
                              offset: Offset(0.0, 10.0))
                        ],
                      ),
                      child: Container(
                        padding: EdgeInsets.fromLTRB(30.0, 80.0, 30.0, 0.0),
                        width: double.infinity,
                        height: 500.0,
                        child: profileContent(),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Center(
                      child: new Container(
                        width: 100.0,
                        height: 100.0,
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                            fit: BoxFit.fill,
                            image: new NetworkImage(photoUrl),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      );

  Widget logout(context) => new Container(
        margin: EdgeInsets.all(10.0),
        child: Align(
          alignment: FractionalOffset.bottomCenter,
          child: SizedBox(
            width: double.infinity,
            height: 50.0,
            child: new RaisedButton(
              color: Colors.pink,
              child: Text(
                "Logout",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: _signOut,
            ),
          ),
        ),
      );
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Profile"),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            flex: 8,
            // child: Container(),
            child: SingleChildScrollView(
              child: Stack(children: <Widget>[
                profile(),
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
              ]),
            ),
          ),
          Expanded(
            flex: 1,
            child: logout(context),
          ),
        ],
      ),
    );
  }
}
