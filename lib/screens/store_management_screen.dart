import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';

class StoreManagementScreen extends StatefulWidget {
  _StoreManagementScreenState createState() => _StoreManagementScreenState();
}

class _StoreManagementScreenState extends State<StoreManagementScreen> {

  void loadData(){
    new FutureBuilder(
          future: FirebaseDatabase.instance.reference().child("customerList").orderByKey().once(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!=null) {
                return new Column (
                  children: <Widget>[
                    new Expanded(
                        child: new ListView(
                          children: _getData(snapshot),
                        ))
                  ],
                );
              } else {
                return new CircularProgressIndicator();
              }
            }
          }
        )
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: loadData,
      ),
    );
  }
}
