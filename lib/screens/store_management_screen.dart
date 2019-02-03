import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'detail_store_screen.dart';
import 'list_product_screen.dart';

class StoreManagementScreen extends StatefulWidget {
  _StoreManagementScreenState createState() => _StoreManagementScreenState();
}

class _StoreManagementScreenState extends State<StoreManagementScreen> {
  bool isLoading = false;
  String id;

  SharedPreferences prefs;
  final mainReference = FirebaseDatabase.instance.reference();

  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getString('id') ?? '';
      isLoading = false;
    });
    mainReference.child("store").child(id).once().then((DataSnapshot snapshot) {
      if (snapshot.value == null) {
        registerDialog();
      }
    });
  }

  void registerDialog() {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Informasi"),
          content: new Text("Apakah anda punya petshop?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailStoreScreen("","Register")));
              },
            ),
          ],
        );
      },
    );
  }

  Widget loadData() {
    return new FutureBuilder(
        future: mainReference.child("store").child(id).once(),
        builder: (BuildContext context, AsyncSnapshot<DataSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return new Scaffold(
                body: Center(
              child: CircularProgressIndicator(),
            ));
          } else {
            if (snapshot.hasData) {
              if (snapshot.data.value != null) {
                // print("Store : " + json.encode(snapshot.data.value));
                return ListProductScreen(snapshot.data.key,"store-management");
              }
            }
            return new Scaffold(
              body: Center(child: Text("kosong")),
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: loadData());
  }
}
