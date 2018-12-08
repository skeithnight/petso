import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:geolocator/geolocator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:haversine/haversine.dart';

import 'detail_hewan_screen.dart';
import 'detail_product_screen.dart';
import 'package:petso/models/detail_toko_model.dart';
import 'map_screen.dart';
import 'store_screen.dart';

class PetshopScreen extends StatefulWidget {
  _PetshopScreenState createState() => _PetshopScreenState();
}

class _PetshopScreenState extends State<PetshopScreen> {
  List<DetailTokoModel> listToko;
  Position _position = null;

  void initState() {
    super.initState();

    _initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void _initPlatformState() async {
    Position position;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      // Geolocator geolocator = Geolocator()..forceAndroidLocationManager = true;
      position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      // print(json.encode(fetchPost()));
    } on Exception {
      print("object");
      position = null;
    }
    // print(position.latitude.toString() + " : " + position.longitude.toString());
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    setState(() {
      _position = position;
    });
  }

  Widget listDataTokoWidget() {
    return StreamBuilder<Event>(
        stream: FirebaseDatabase.instance.reference().child("store").onValue,
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return new Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.hasData) {
              listToko = new List();
              Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
              List<dynamic> list2 = map.keys.toList();
              List<dynamic> list = map.values.toList();
              for (var i = 0; i < list.length; i++) {
                listToko
                    .add(new DetailTokoModel.fromSnapshot(list[i], list2[i]));
              }
              print(json.encode(listToko));
              if (listToko.length == 0) {
                return new Center(
                  child: Text("kosong"),
                );
              }
              // return Container();
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
        itemCount: listToko.length,
        itemBuilder: (BuildContext context, int index) => Card(
              elevation: 5.0,
              child: ListTile(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => StoreScreen(listToko[index])));
                },
                title: Text(listToko[index].namaToko.toUpperCase()),
                // subtitle: Text(index.toString())
                subtitle: Text(listToko[index].lokasiPacakModel.address),
                trailing: _position == null
                    ? CircularProgressIndicator()
                    : tampilJarak(listToko[index].lokasiPacakModel.latitude, listToko[index].lokasiPacakModel.longitude),
              ),
            ));
  }

  Widget tampilJarak(lat,lon) {
    if(_position !=null){
    final harvesine = new Haversine.fromDegrees(
        latitude1: lat, longitude1: lon, latitude2: _position.latitude, longitude2: _position.longitude);
        int result = (harvesine.distance()/1000).floor();
        return Text(result.toString()+" Km");
    }
    return Text("-");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("List Toko"),
      ),
      body: Center(
          child: Container(
        child: listDataTokoWidget(),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MapsScreen(listToko)));
        },
        tooltip: 'Lokasi Toko',
        child: Icon(Icons.map),
      ),
    );
  }
}
