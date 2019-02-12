import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

import 'package:petso/logic/perhitungan.dart';

import 'tambah_pacak_screen.dart';
import 'package:petso/models/pacak_model.dart';
import 'detail_pacak_screen.dart';
import 'widgets/maps_widget.dart';
import 'main_screen.dart';

class KawinScreen extends StatefulWidget {
  _KawinScreenState createState() => _KawinScreenState();
}

class _KawinScreenState extends State<KawinScreen> {
  String id;
  int pilihan;
  List<PacakModel> listPacakModel;

  Position _position = null;

  SharedPreferences prefs;
  final mainReference = FirebaseDatabase.instance.reference();

  void initState() {
    super.initState();
    getData();
    _initPlatformState();
  }

  void getData() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getString('id') ?? '';
    });
    // print(isLoading);
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

  Widget listDataPacakWidget() {
    // return Text(id ?? '');
    return StreamBuilder<Event>(
        stream: FirebaseDatabase.instance.reference().child("pacak").onValue,
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return new Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.hasData) {
              listPacakModel = new List();
              Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
              List<dynamic> list2 = map.keys.toList();
              List<dynamic> list = map.values.toList();
              for (var i = 0; i < list.length; i++) {
                listPacakModel
                    .add(new PacakModel.fromSnapshot(list[i], list2[i]));
              }
              print(json.encode(listPacakModel));
              // return Container();
              return showListData();
            }
            print("Kosong");
            return new Center(
              child: Text("kosong"),
            );
          }
        });
  }

  Widget showListData() {
    return ListView.builder(
        itemCount: listPacakModel.length,
        itemBuilder: (BuildContext context, int index) => Card(
              color: index == pilihan ? Colors.green : Colors.white,
              elevation: 5.0,
              child: ListTile(
                  onTap: () {
                    print(id + " : " + listPacakModel[index].idPacak);
                    _modalBottomSheet(listPacakModel[index]);
                  },
                  leading: Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                        fit: BoxFit.fill,
                        image: listPacakModel[index]
                                    .detailHewanModel
                                    .photoUrlPet ==
                                null
                            ? new NetworkImage(
                                'https://www.akc.org/wp-content/themes/akc/component-library/assets//img/welcome.jpg')
                            : new NetworkImage(listPacakModel[index]
                                .detailHewanModel
                                .photoUrlPet),
                      ),
                    ),
                  ),
                  title: Text(listPacakModel[index]
                      .detailHewanModel
                      .petName
                      .toUpperCase()),
                  // subtitle: Text(index.toString())
                  subtitle: Column(
                    textDirection: TextDirection.ltr,
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        child: Text(
                          listPacakModel[index].detailHewanModel.type,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        child: Text(
                          listPacakModel[index].detailHewanModel.race,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        child: Text(
                          listPacakModel[index].lokasiPacak.address,
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  ),
                  trailing: _position == null
                      ? CircularProgressIndicator()
                      : Text(Perhitungan()
                              .hitungJarak(
                                  listPacakModel[index].lokasiPacak.latitude,
                                  listPacakModel[index].lokasiPacak.longitude,
                                  _position.latitude,
                                  _position.longitude)
                              .toString() +
                          " Km")),
            ));
  }

  void _modalBottomSheet(PacakModel pacakmodel) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return new Container(
            child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
              Expanded(
                  flex: 2,
                  child: Container(
                    height: 100.0,
                    child: MapsWidget(
                      lon: pacakmodel.lokasiPacak.longitude,
                      lat: pacakmodel.lokasiPacak.latitude,
                      listMarker: [
                        new Marker(
                          width: 80.0,
                          height: 80.0,
                          point: new LatLng(pacakmodel.lokasiPacak.latitude,
                              pacakmodel.lokasiPacak.longitude),
                          builder: (ctx) => new Container(
                                child: Icon(Icons.place),
                              ),
                        ),
                      ],
                    ),
                  )),
              Expanded(
                flex: 2,
                child: Container(
                  child: ListTile(
                      leading: Container(
                        width: 50.0,
                        height: 50.0,
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                            fit: BoxFit.fill,
                            image: new NetworkImage(
                                'https://www.akc.org/wp-content/themes/akc/component-library/assets//img/welcome.jpg'),
                          ),
                        ),
                      ),
                      title: Text(
                          pacakmodel.detailHewanModel.petName.toUpperCase()),
                      // subtitle: Text(index.toString())
                      subtitle: Column(
                        textDirection: TextDirection.ltr,
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            child: Text(
                              pacakmodel.detailHewanModel.type,
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            child: Text(
                              pacakmodel.detailHewanModel.race,
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            child: Text(
                              pacakmodel.lokasiPacak.address,
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ],
                      ),
                      trailing: _position == null
                          ? CircularProgressIndicator()
                          : Text(Perhitungan()
                                  .hitungJarak(
                                      pacakmodel.lokasiPacak.latitude,
                                      pacakmodel.lokasiPacak.longitude,
                                      _position.latitude,
                                      _position.longitude)
                                  .toString() +
                              " Km")),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: new Center(
                    child: new RaisedButton(
                        onPressed: () {
                          _launchURL(pacakmodel.phoneNumber);
                        },
                        child: new Text("Telpon saya")),
                  )),
              pacakmodel.idUser == id
                  ? Expanded(
                      flex: 1,
                      child: new Center(
                        child: new RaisedButton(
                            onPressed: () {
                              removeDialog(pacakmodel.idPacak);
                            },
                            child: new Text("Hapus")),
                      ))
                  : Container(),
            ]),
          );
        });
  }

  _launchURL(String phoneNumber) async {
    String url = 'tel://$phoneNumber';
    if (await UrlLauncher.canLaunch(url)) {
      await UrlLauncher.launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void removeDialog(String idPacak) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(idPacak),
          content: new Text("Yakin mau hapus data ini?"),
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
                mainReference
                    .child("pacak")
                    .child(idPacak)
                    .remove()
                    .then((onValue) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => MainScreen()));
                }).catchError((onError) {
                  throw (onError);
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Pacak Hewan Peliharaan"),
      ),
      body: Center(
          child: Container(
        child: listDataPacakWidget(),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => TambahPacakScreen()));
        },
        tooltip: 'Add Pacak',
        child: Icon(Icons.add),
      ),
    );
  }
}
