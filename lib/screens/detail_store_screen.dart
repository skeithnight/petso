import 'package:flutter/material.dart';

import 'package:google_places_picker/google_places_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'widgets/common_divided_widget.dart';
import 'store_management_screen.dart';

class DetailStoreScreen extends StatefulWidget {
  String level = null;
  String idToko = null;
  DetailStoreScreen(this.idToko,this.level);
  _DetailStoreScreenState createState() => _DetailStoreScreenState();
}

class _DetailStoreScreenState extends State<DetailStoreScreen> {
  bool isLoading = false;
  bool isLoadingSubmitData = false;
  Place _place;
  String id;
  String storeName, siup, address;

  SharedPreferences prefs;
  final mainReference = FirebaseDatabase.instance.reference();

  var namaTokoController = new TextEditingController();
  var siupTokoController = new TextEditingController();
  var addressTokoController = new TextEditingController();

  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getString('id') ?? '';
      isLoading = false;
    });
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
      addressTokoController.text = place.address;
      // this.address = place.address;
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
              child: new Text("Tutup"),
              onPressed: () {
                if (tittle == "Gagal") {
                  Navigator.of(context).pop();
                } else if (tittle == "Sukses") {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StoreManagementScreen()));
                }
              },
            ),
          ],
        );
      },
    );
  }

  // register store
  Widget content() => new Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          identityStore(),
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

  Widget identityStore() => Container(
      width: double.infinity,
      child: Card(
          elevation: 10.0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Identitas toko",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Container(height: 150.0, child: contentStoreIdentity()),
              ],
            ),
          )));
  Widget contentStoreIdentity() => new Column(
        children: <Widget>[
          TextField(
            onChanged: (text) {
              setState(() {
                this.storeName = text;
              });
            },
            decoration: InputDecoration(hintText: "Nama toko"),
          ),
          CommonDivider(),
          SizedBox(
            height: 5.0,
          ),
          TextField(
            onChanged: (text) {
              setState(() {
                this.siup = text;
              });
            },
            decoration: InputDecoration(hintText: "Nomor SIUP"),
          ),
          CommonDivider(),
          SizedBox(
            height: 5.0,
          ),
        ],
      );

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
                  "Ambil lokasi",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                CommonDivider(),
                SizedBox(
                  height: 5.0,
                ),
                Container(
                  width: double.infinity,
                  child: RaisedButton(
                    color: Colors.green,
                    child: Text(
                      "Ambil lokasi",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      try {
                        _showPlacePicker();
                      } catch (e) {
                        tampilDialog("Alert", "Gagal ambil lokasi");
                      }
                    },
                  ),
                ),
                CommonDivider(),
                SizedBox(
                  height: 5.0,
                ),
                Container(
                  height: 100.0,
                  child: _place == null
                      ? Center(child: CircularProgressIndicator())
                      : TextField(
                          controller: addressTokoController,
                          keyboardType: TextInputType.multiline,
                          maxLines: 5,
                          decoration: InputDecoration(hintText: 'Alamat'),
                        ),
                ),
              ],
            ),
          )));

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
                "Simpan",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: _saveData,
            ),
          ),
        ),
      );

  void _saveData() {
    setState(() {
      isLoadingSubmitData = true;
    });
    print("$address : $storeName : $siup");
    if (_place == null || storeName == null || siup == null) {
      setState(() {
        isLoadingSubmitData = false;
      });
      tampilDialog("Gagal", "Data tidak boleh ada yang kosong!");
    } else {
      mainReference.child("store").child(id).set({
        "namaToko":storeName,
        "siup": siup,
        "lokasiToko": {
          "latitude": _place.latitude,
          "longitude": _place.longitude,
          "address": _place.address
        }
      }).then((response) {
        tampilDialog("Sukses", "Data berhasil di simpan...");
      }).catchError((onError) {
        tampilDialog("Gagal", onError.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: new AppBar(
          title: new Text(widget.level + " Toko"),
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
              child: isLoadingSubmitData
                  ? Center(child: CircularProgressIndicator())
                  : saveButton(),
            ),
          ],
        ),
      ),
    );
  }
}
