import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'detail_hewan_screen.dart';
import 'package:petso/models/detail_hewan_model.dart';

class KelolaHewanScreen extends StatefulWidget {
  _KelolaHewanScreenState createState() => _KelolaHewanScreenState();
}

class _KelolaHewanScreenState extends State<KelolaHewanScreen> {
  String id;
  SharedPreferences prefs;
  List<DetailHewanModel> listDetailHewan;

  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getString('id') ?? '';
    });
  }

  Widget listDataHewanWidget() {
    // return Text(id ?? '');
    return StreamBuilder<Event>(
        stream: FirebaseDatabase.instance
            .reference()
            .child("users")
            .child(id)
            .child("pets")
            .onValue,
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return new Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.hasData) {
              listDetailHewan = new List();
              Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
              List<dynamic> list2 = map.keys.toList();
              List<dynamic> list = map.values.toList();
              for (var i = 0; i < list.length; i++) {
                listDetailHewan
                    .add(new DetailHewanModel.fromSnapshot(list[i], list2[i]));
              }
              // print(json.encode(listDetailHewan));
              return showListData();
            }
            // print("Kosong");
            return new Center(
              child: Text("kosong"),
            );
          }
        });
  }

  Widget showListData() {
    return ListView.builder(
        itemCount: listDetailHewan.length,
        itemBuilder: (BuildContext context, int index) => Card(
              elevation: 5.0,
              child: ListTile(
                onTap: () {
                  // print(json.encode(listDetailHewan[index]));
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          DetailHewanScreen('Detail', listDetailHewan[index])));
                },
                leading: Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    image: new DecorationImage(
                      fit: BoxFit.fill,
                      image: listDetailHewan[index].photoUrlPet == null
                          ? new NetworkImage(
                              'https://www.akc.org/wp-content/themes/akc/component-library/assets//img/welcome.jpg')
                          : new NetworkImage(
                              listDetailHewan[index].photoUrlPet),
                    ),
                  ),
                ),
                title: Text(listDetailHewan[index].petName.toUpperCase()),
                // subtitle: Text(index.toString())
                subtitle: Text(listDetailHewan[index].identity),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Kelola Hewan Peliharaan"),
      ),
      body: Center(
          child: Container(
        child: listDataHewanWidget(),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailHewanScreen('add', null)));
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
