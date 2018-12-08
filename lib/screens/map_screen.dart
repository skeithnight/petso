import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:geolocator/geolocator.dart';

import 'package:petso/models/detail_toko_model.dart';

String tokenMaps =
    "pk.eyJ1Ijoic2tlaXRobmlnaHQiLCJhIjoiY2pvYWw5aGYwMGxnazNybGMxZ3B0ZWc3aiJ9.g5ybUMKi4nGoYGFQdly1-A";

class MapsScreen extends StatefulWidget {
  List<DetailTokoModel> _listtoko = new List();
  MapsScreen(this._listtoko);
  _MapsScreenState createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  List<Marker> listMarker = new List<Marker>();
  List<DetailTokoModel> listtoko = new List();
  Position _position;
  @override
  void initState() {
    super.initState();
    setState(() {
      listtoko = widget._listtoko;
    });
    _initPlatformState();
    setMarker();
  }

  setMarker() {
    for (DetailTokoModel item in listtoko) {
      listMarker.add(
        new Marker(
          width: 80.0,
          height: 80.0,
          point: new LatLng(
              item.lokasiPacakModel.latitude, item.lokasiPacakModel.longitude),
          builder: (ctx) => new Container(
                child: Icon(Icons.pets),
              ),
        ),
      );
    }
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
    listMarker.add(new Marker(
      width: 80.0,
      height: 80.0,
      point: new LatLng(position.latitude, position.longitude),
      builder: (ctx) => new Container(
            child: Icon(
              Icons.place,
              color: Colors.blue,
            ),
          ),
    ));
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    setState(() {
      _position = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new FlutterMap(
        options: new MapOptions(
          center: _position != null
              ? new LatLng(_position.latitude, _position.longitude)
              : new LatLng(-6.922180, 107.606830),
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
          new MarkerLayerOptions(markers: listMarker),
        ],
      ),
    );
  }
}
