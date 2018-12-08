import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:petso/screens/widgets/common_divided_widget.dart';

import 'main_screen.dart';
import 'package:petso/models/detail_toko_model.dart';
import 'list_product_screen.dart';

class StoreScreen extends StatelessWidget {
  final DetailTokoModel detailTokoModel;
  StoreScreen(this.detailTokoModel);
  List<String> listDarah = ["A+", "A-", "B+", "B-", "0+", "0-", "AB+", "AB-"];

  Widget mapsLocation() => Container(
        width: double.infinity,
        height: 300.0,
        child: new FlutterMap(
          options: new MapOptions(
            center: new LatLng(detailTokoModel.lokasiPacakModel.latitude,
                detailTokoModel.lokasiPacakModel.longitude),
            zoom: 13.0,
          ),
          layers: [
            new TileLayerOptions(
              urlTemplate: "https://api.tiles.mapbox.com/v4/"
                  "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
              additionalOptions: {
                'accessToken':
                    'pk.eyJ1Ijoic2tlaXRobmlnaHQiLCJhIjoiY2pvYWw5aGYwMGxnazNybGMxZ3B0ZWc3aiJ9.g5ybUMKi4nGoYGFQdly1-A',
                'id': 'mapbox.streets',
              },
            ),
            new MarkerLayerOptions(
              markers: [
                new Marker(
                  width: 80.0,
                  height: 80.0,
                  point: new LatLng(detailTokoModel.lokasiPacakModel.latitude,
                      detailTokoModel.lokasiPacakModel.longitude),
                  builder: (ctx) => new Container(
                        child: Icon(Icons.place),
                      ),
                ),
              ],
            ),
          ],
        ),
      );

  Widget storeName() => Container(
      width: double.infinity,
      child: Card(
          elevation: 10.0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  detailTokoModel.namaToko,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
              ],
            ),
          )));

  Widget listProduct() => Container(
      width: double.infinity,
      child: Card(
          elevation: 10.0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Product list",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                CommonDivider(),
                SizedBox(
                  height: 5.0,
                ),
                ListProductScreen(detailTokoModel.idToko, "store-screen"),
                CommonDivider(),
                SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          )));
  Widget content() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          storeName(),
          CommonDivider(),
          SizedBox(
            height: 5.0,
          ),
          listProduct(),
          CommonDivider(),
          SizedBox(
            height: 20.0,
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[mapsLocation(), content()],
      ),
    ));
  }
}
