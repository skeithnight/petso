import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:google_places_picker/google_places_picker.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:petso/models/detail_hewan_model.dart';
import 'package:petso/models/detail_pacak_hewan.dart';
import 'widgets/common_divided_widget.dart';
import 'package:petso/data.dart' as data;
import 'main_screen.dart';

class TambahPacakScreen extends StatefulWidget {
  _TambahPacakScreenState createState() => _TambahPacakScreenState();
}

class _TambahPacakScreenState extends State<TambahPacakScreen> {
  String id;
  int pilihan;
  SharedPreferences prefs;
  List<DetailHewanModel> listDetailHewan;
  DetailPacakHewan detailPacakHewan = new DetailPacakHewan();
  bool isLoading = false;
  Place _place;

  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getString('id') ?? '';
    });
    // print("id: $id");
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  _showPlacePicker() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    Place place = await PluginGooglePlacePicker.showPlacePicker();

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _place = place;
    });
  }

  _showAutocomplete() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    Place place = await PluginGooglePlacePicker.showAutocomplete(
        PlaceAutocompleteMode.MODE_OVERLAY);

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _place = place;
    });
  }

  void tampilDialog(String tittle, String message) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(tittle),
          content: new Text(message),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                if (tittle == "Failed") {
                  Navigator.of(context).pop();
                } else if (tittle == "Success") {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => MainScreen()));
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget listDataHewanWidget() {
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
              // print(json.encode(snapshot.data.snapshot.value));
              listDetailHewan = new List();
              Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
              List<dynamic> list2 = map.keys.toList();
              List<dynamic> list = map.values.toList();
              for (var i = 0; i < list.length; i++) {
                listDetailHewan
                    .add(new DetailHewanModel.fromSnapshot(list[i], list2[i]));
              }
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
        itemCount: listDetailHewan.length,
        itemBuilder: (BuildContext context, int index) => Card(
              color: index == pilihan ? Colors.green : Colors.white,
              elevation: 5.0,
              child: ListTile(
                onTap: () {
                  setState(() {
                    pilihan = index;
                    detailPacakHewan.detailHewanModel = listDetailHewan[index];
                  });
                  print(json.encode(detailPacakHewan.detailHewanModel));
                },
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
                title: Text(listDetailHewan[index].petName.toUpperCase()),
                // subtitle: Text(index.toString())
                subtitle: Column(
                  textDirection: TextDirection.ltr,
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      child: Text(
                        listDetailHewan[index].type,
                        textAlign: TextAlign.start,
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      child: Text(
                        listDetailHewan[index].race,
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }

  Widget choicePetCard() => Container(
      width: double.infinity,
      child: Card(
          elevation: 10.0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Choice your pet",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Container(
                  height: 200.0,
                  child: listDataHewanWidget(),
                ),
              ],
            ),
          )));
  Widget lokasiPacak() => Container(
      width: double.infinity,
      child: Card(
          elevation: 10.0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Pick Location",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                CommonDivider(),
                SizedBox(
                  height: 5.0,
                ),
                RaisedButton(
                  child: Text("Pick Location"),
                  onPressed: () {
                    try {
                      _showPlacePicker();
                    } catch (e) {
                      tampilDialog("Alert", "Failed to load location");
                    }
                  },
                ),
                CommonDivider(),
                SizedBox(
                  height: 5.0,
                ),
                Container(
                  height: 200.0,
                  child: _place == null
                      ? Center(child: CircularProgressIndicator())
                      : Text(_place.address),
                ),
              ],
            ),
          )));
  Widget content() => new Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          choicePetCard(),
          CommonDivider(),
          SizedBox(
            height: 5.0,
          ),
          lokasiPacak(),
          CommonDivider(),
          SizedBox(
            height: 20.0,
          ),
        ],
      );
  Widget saveButton() => new Container(
        margin: EdgeInsets.all(10.0),
        child: Align(
          alignment: FractionalOffset.bottomCenter,
          child: SizedBox(
            width: double.infinity,
            height: 50.0,
            child: new RaisedButton(
              color: Colors.lightBlue,
              child: Text(
                "Save",
                style: TextStyle(color: Colors.white),
              ),
              // onPressed: _saveData,
            ),
          ),
        ),
      );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Pacak Hewan"),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            flex: 8,
            child: SingleChildScrollView(
              child: Stack(children: <Widget>[
                content(),
                Positioned(
                  child: isLoading
                      ? Container(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                          color: Colors.white.withOpacity(0.8),
                        )
                      : Container(),
                ),
              ]),
            ),
          ),
          Expanded(
            flex: 1,
            child: saveButton(),
          ),
        ],
      ),
    );
  }
}
