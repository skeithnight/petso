import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'detail_hewan_screen.dart';
import 'detail_product_screen.dart';
import 'package:petso/models/product_model.dart';

class ListProductScreen extends StatefulWidget {
  String id;
  String level;
  ListProductScreen(this.id, this.level);
  _ListProductScreenState createState() => _ListProductScreenState();
}

class _ListProductScreenState extends State<ListProductScreen> {
  SharedPreferences prefs;
  List<ProductModel> listProduct;
  final formatCurrency = new NumberFormat.simpleCurrency(locale: "IDR");

  void initState() {
    super.initState();
    print(widget.level);
    print(widget.id);
  }

  Widget listDataProductWidget() {
    return StreamBuilder<Event>(
        stream: FirebaseDatabase.instance
            .reference()
            .child("store")
            .child(widget.id)
            .child("product")
            .onValue,
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return new Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.hasData) {
              listProduct = new List();
              Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
              List<dynamic> list2 = map.keys.toList();
              List<dynamic> list = map.values.toList();
              for (var i = 0; i < list.length; i++) {
                listProduct
                    .add(new ProductModel.fromSnapshot(list[i], list2[i]));
              }
              if (listProduct.length == 0) {
                return new Center(
                  child: Text("kosong"),
                );
              }
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
        itemCount: listProduct.length,
        itemBuilder: (BuildContext context, int index) => Card(
              elevation: 5.0,
              child: ListTile(
                onTap: () {
                  if (widget.level != "store-screen") {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            DetailProductScreen('edit', listProduct[index])));
                  }else{
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            DetailProductScreen('Detail', listProduct[index])));
                  }
                },
                leading: Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    image: new DecorationImage(
                      fit: BoxFit.fill,
                      image: new NetworkImage(
                          'https://shop-cdn-m.shpp.ext.zooplus.io/bilder/royal/canin/maxi/adult/8/400/80729_pla_royalcanin_maxiadult_15kg_hs_01_8.jpg'),
                    ),
                  ),
                ),
                title: Text(listProduct[index].namaProduct.toUpperCase()),
                // subtitle: Text(index.toString())
                subtitle: Text(
                    formatCurrency.format(listProduct[index].hargaProduct)),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    if (widget.level == "store-management") {
      return Scaffold(
        appBar: new AppBar(
          title: new Text("List Product"),
        ),
        body: Center(
            child: Container(
          child: listDataProductWidget(),
        )),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailProductScreen('add', null)));
          },
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ),
      );
    } else {
      // return Center(child: Text(widget.id),);
      return Container(
        height: 300.0,
        child: listDataProductWidget(),
      );
    }
  }
}
