import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'detail_hewan_screen.dart';
import 'detail_product_screen.dart';
import 'package:petso/models/detail_toko_model.dart';
import 'store_screen.dart';

class PetshopScreen extends StatefulWidget {
  _PetshopScreenState createState() => _PetshopScreenState();
}

class _PetshopScreenState extends State<PetshopScreen> {
  List<DetailTokoModel> listToko;

  void initState() {
    super.initState();
  }

  Widget listDataTokoWidget() {
    return StreamBuilder<Event>(
        stream: FirebaseDatabase.instance
            .reference()
            .child("store")
            .onValue,
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
                subtitle: Text(listToko[index].lokasiPacakModel.address), trailing: Text("3.5 KM"),
              ),
            ));
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
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //             builder: (context) => DetailProductScreen('add', null)));
      //   },
      //   tooltip: 'Increment',
      //   child: Icon(Icons.add),
      // ),
    );
  }
}
