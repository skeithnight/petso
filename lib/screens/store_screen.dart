import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import 'package:petso/screens/widgets/common_divided_widget.dart';

import 'main_screen.dart';
import 'package:petso/models/detail_toko_model.dart';
import 'list_product_screen.dart';
import 'package:petso/models/map/response_map_model.dart';

String tokenMaps =
    "pk.eyJ1Ijoic2tlaXRobmlnaHQiLCJhIjoiY2pvYWw5aGYwMGxnazNybGMxZ3B0ZWc3aiJ9.g5ybUMKi4nGoYGFQdly1-A";

class StoreScreen extends StatefulWidget {
  final DetailTokoModel _detailTokoModel;
  StoreScreen(this._detailTokoModel);
  _StoreScreenState createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  DetailTokoModel detailTokoModel = new DetailTokoModel();
  var points = <LatLng>[
    new LatLng(35.22, -101.83),
    new LatLng(32.77, -96.79),
    new LatLng(29.76, -95.36),
    new LatLng(29.42, -98.49),
    new LatLng(35.22, -101.83),
  ];
  Position _position;
  @override
  void initState() {
    super.initState();
    setState(() {
      detailTokoModel = widget._detailTokoModel;
    });
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
      fetchPost(position.latitude, position.longitude);
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

  Future<ResponseMapModel> fetchPost(double lat, double lon) async {
    final response = await http.get(
        'https://api.mapbox.com/directions/v5/mapbox/driving/' +
            lon.toString() +
            ',' +
            lat.toString() +
            ';' +
            detailTokoModel.lokasiPacakModel.longitude.toString() +
            ',' +
            detailTokoModel.lokasiPacakModel.latitude.toString() +
            '?steps=true&access_token=$tokenMaps');

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON
      Map<String, dynamic> map = json.decode(response.body);
      List<dynamic> map2 = map["routes"][0]['legs'][0]['steps'];
      List<LatLng> jalur = new List();
      for (var i = 0; i < map2.length; i++) {
        List<dynamic> intersection = map2[i]['intersections'];
        for (var j = 0; j < intersection.length; j++) {
          // print(intersection[j]['location'][1]);
          jalur.add(new LatLng(
              intersection[j]['location'][1], intersection[j]['location'][0]));
        }
      }
      // List<Map<String,dynamic>> list = map['routes'][0]['legs'][0]['steps'].values.toList();
      ResponseMapModel mapModel =
          ResponseMapModel.fromSnapshot(json.decode(response.body));
      setState(() {
        points = jalur;
      });
      return mapModel;
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }

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
                'accessToken': tokenMaps,
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
                _position != null
                    ? new Marker(
                        width: 80.0,
                        height: 80.0,
                        point:
                            new LatLng(_position.latitude, _position.longitude),
                        builder: (ctx) => new Container(
                              child: Icon(
                                Icons.place,
                                color: Colors.blue,
                              ),
                            ),
                      )
                    : new Marker(
                        point: new LatLng(0.0, 0.0),
                      ),
              ],
            ),
            new PolylineLayerOptions(polylines: [
              new Polyline(points: points, strokeWidth: 5.0, color: Colors.red)
            ]),
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
                  "List Produk",
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
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[mapsLocation(), content()],
        ),
      ),
    ));
  }
}
