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
  TextEditingController editingController = TextEditingController();
  final duplicateItems = List<String>.generate(10000, (i) => "Item $i");

  SharedPreferences prefs;
  List<ProductModel> listProductOrigin = new List();
  List<ProductModel> listProduct = new List();
  final formatCurrency = new NumberFormat.simpleCurrency(locale: "IDR");

  void initState() {
    super.initState();
    getData();
  }

  Future<Null> getData() async {
    final response = await FirebaseDatabase.instance
        .reference()
        .child("store")
        .child(widget.id)
        .child("product")
        .once();
    listProductOrigin = new List();
    if (response.value != null) {
      Map<dynamic, dynamic> map = response.value;
      List<dynamic> list2 = map.keys.toList();
      List<dynamic> list = map.values.toList();
      for (var i = 0; i < list.length; i++) {
        listProductOrigin.add(new ProductModel.fromSnapshot(list[i], list2[i]));
      }
    }
    // listProduct = listProductOrigin;
    setState(() {
      listProduct.addAll(listProductOrigin);
    });
    print("bbbbb : ${listProductOrigin.length}");
  }

  Widget contentListData() {
    return Column(
      children: <Widget>[
        TextField(
          onChanged: (value) {
            filterSearchResults(value);
          },
          controller: editingController,
          decoration: InputDecoration(
              labelText: "Search",
              hintText: "Search",
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)))),
        ),
        Expanded(child: showListData()),
      ],
    );
  }

  Widget showListData() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: listProduct.length,
        itemBuilder: (BuildContext context, int index) => Card(
              elevation: 5.0,
              child: ListTile(
                onTap: () {
                  if (widget.level != "store-screen") {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            DetailProductScreen('edit', listProduct[index])));
                  } else {
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
                      image: listProduct[index].photoURLProduct == null
                          ? new NetworkImage(
                              'https://shop-cdn-m.shpp.ext.zooplus.io/bilder/royal/canin/maxi/adult/8/400/80729_pla_royalcanin_maxiadult_15kg_hs_01_8.jpg')
                          : new NetworkImage(
                              listProduct[index].photoURLProduct),
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

  void filterSearchResults(String query) {
    List<ProductModel> dummySearchList = List<ProductModel>();
    dummySearchList.addAll(listProductOrigin);
    if (query.isNotEmpty) {
      List<ProductModel> dummyListData = List<ProductModel>();
      dummySearchList.forEach((item) {
        if (item.namaProduct.toUpperCase().contains(query.toUpperCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        listProduct.clear();
        listProduct.addAll(dummyListData);
      });
      print("aaa: ${listProduct.length} : ${listProductOrigin.length}");
      return;
    } else {
      setState(() {
        listProduct.clear();
        listProduct.addAll(listProductOrigin);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.level == "store-management") {
      return Scaffold(
        appBar: new AppBar(
          title: new Text("Daftar Produk"),
        ),
        body: Center(
            child: Container(
          child: showListData(),
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
      return Container(
        child: contentListData(),
        height: 500.0,
      );
    }
  }
}
