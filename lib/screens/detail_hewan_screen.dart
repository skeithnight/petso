import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:petso/models/detail_hewan_model.dart';
import 'kelola_hewan_screen.dart';

class DetailHewanScreen extends StatefulWidget {
  DetailHewanModel detailHewanModel;
  final String level;
  DetailHewanScreen(this.level, this.detailHewanModel);
  _DetailHewanScreenState createState() => _DetailHewanScreenState();
}

class _DetailHewanScreenState extends State<DetailHewanScreen> {
  DetailHewanModel _detailHewanModel = new DetailHewanModel();
  bool isLoading = false;
  File _image;
  String id;

  SharedPreferences prefs;
  final mainReference = FirebaseDatabase.instance.reference();

  void initState() {
    super.initState();
    getData();
    if (widget.level != 'add') {
      this._detailHewanModel = widget.detailHewanModel;
    }
  }

  void getData() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getString('id') ?? '';
      isLoading = false;
    });
    print(isLoading);
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  _saveData() {
    if (_detailHewanModel.petName == null ||
        _detailHewanModel.identity == null ||
        _detailHewanModel.age == null ||
        _detailHewanModel.gender == null ||
        _detailHewanModel.type == null ||
        _detailHewanModel.race == null ||
        _detailHewanModel.furColor == null) {
      print(json.encode(_detailHewanModel));
      tampilDialog("Failed", "Please complete all fill!");
    } else {
      print(json.encode(_detailHewanModel));
      if (widget.level == 'add') {
        // print('addd');
        mainReference
            .child("users")
            .child(id)
            .child("pets")
            .push()
            .set(_detailHewanModel.toJson())
            .then((response) {
          tampilDialog("Success", "Your data has been save");
        });
      } else {
        if (_detailHewanModel.idPet != null) {
          print('edit');
          mainReference
              .child("users")
              .child(id)
              .child("pets")
              .child(_detailHewanModel.idPet)
              .set(_detailHewanModel.toJson())
              .then((response) {
            tampilDialog("Success", "Your data has been save");
          });
        }
      }
    }
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
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => KelolaHewanScreen()));
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget appbar() {
    if (widget.level == "add") {
      return new AppBar(
        title: new Text("Tambah Hewan Peliharaan"),
      );
    } else {
      return new AppBar(
        title: new Text("Detail Hewan Peliharaan"),
      );
    }
  }

  Widget inputContent() =>
      Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
        // image
        new Center(
          child: _image == null
              ? new Container(
                  height: 100.0,
                  child: RaisedButton(
                    onPressed: getImage,
                    child: Text('Pick Image'),
                  ))
              : new Container(
                  height: 100.0,
                  child: InkWell(
                    child: Image.file(_image),
                    onTap: getImage,
                  )),
        ),
        // pet name
        Container(
          width: double.infinity,
          child: Text(
            'Pet Name',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
            ),
          ),
          margin: EdgeInsets.only(left: 10.0, bottom: 5.0, top: 10.0),
        ),
        Container(
          child: Theme(
            data: Theme.of(context).copyWith(),
            child: TextField(
              onChanged: (text) {
                setState(() {
                  this._detailHewanModel.petName = text;
                });
              },
              decoration: InputDecoration(
                hintText: this._detailHewanModel.petName == null
                    ? ""
                    : this._detailHewanModel.petName,
                contentPadding: new EdgeInsets.all(5.0),
                hintStyle: TextStyle(color: Colors.black),
              ),
            ),
          ),
          margin: EdgeInsets.only(left: 30.0, right: 30.0),
        ),
        // pet Identity
        Container(
          width: double.infinity,
          child: Text(
            'Pet Identity',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
            ),
          ),
          margin: EdgeInsets.only(left: 10.0, bottom: 5.0, top: 10.0),
        ),
        Container(
          child: Theme(
            data: Theme.of(context).copyWith(),
            child: TextField(
              onChanged: (text) {
                setState(() {
                  this._detailHewanModel.identity = text;
                });
              },
              decoration: InputDecoration(
                hintText: this._detailHewanModel.identity == null
                    ? ""
                    : this._detailHewanModel.identity,
                contentPadding: new EdgeInsets.all(5.0),
                hintStyle: TextStyle(color: Colors.black),
              ),
            ),
          ),
          margin: EdgeInsets.only(left: 30.0, right: 30.0),
        ),
        // pet gender
        Container(
          width: double.infinity,
          child: Text(
            'Pet Gender',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
            ),
          ),
          margin: EdgeInsets.only(left: 10.0, bottom: 5.0, top: 10.0),
        ),
        Container(
          width: double.infinity,
          child: Theme(
              data: Theme.of(context).copyWith(),
              child: new DropdownButton<String>(
                value: this._detailHewanModel.gender == null
                    ? 'Select your pet gender'
                    : this._detailHewanModel.gender,
                items: <String>['Select your pet gender', 'Male', 'Female']
                    .map((String value) {
                  return new DropdownMenuItem<String>(
                    value: value,
                    child: new Text(value),
                  );
                }).toList(),
                onChanged: (text) {
                  setState(() {
                    this._detailHewanModel.gender = text;
                  });
                },
              )),
          margin: EdgeInsets.only(left: 30.0, right: 30.0),
        ),
        // pet age
        Container(
          width: double.infinity,
          child: Text(
            'Pet Age',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
            ),
          ),
          margin: EdgeInsets.only(left: 10.0, bottom: 5.0, top: 10.0),
        ),
        Container(
          width: double.infinity,
          child: Theme(
              data: Theme.of(context).copyWith(),
              child: new DropdownButton<String>(
                value: this._detailHewanModel.age == null
                    ? 'Select your pet age'
                    : this._detailHewanModel.age,
                items: <String>[
                  'Select your pet age',
                  '< 1 years',
                  '1 - 2 years',
                  '2 - 5 years',
                  '> 5 years'
                ].map((String value) {
                  return new DropdownMenuItem<String>(
                    value: value,
                    child: new Text(value),
                  );
                }).toList(),
                onChanged: (text) {
                  setState(() {
                    this._detailHewanModel.age = text;
                  });
                },
              )),
          margin: EdgeInsets.only(left: 30.0, right: 30.0),
        ),
        // pet type
        Container(
          width: double.infinity,
          child: Text(
            'Pet Type',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
            ),
          ),
          margin: EdgeInsets.only(left: 10.0, bottom: 5.0, top: 10.0),
        ),
        Container(
          width: double.infinity,
          child: Theme(
              data: Theme.of(context).copyWith(),
              child: new DropdownButton<String>(
                value: this._detailHewanModel.type == null
                    ? 'Select your pet type'
                    : this._detailHewanModel.type,
                items: <String>['Select your pet type', 'Dog', 'Cat']
                    .map((String value) {
                  return new DropdownMenuItem<String>(
                    value: value,
                    child: new Text(value),
                  );
                }).toList(),
                onChanged: (text) {
                  setState(() {
                    this._detailHewanModel.type = text;
                  });
                },
              )),
          margin: EdgeInsets.only(left: 30.0, right: 30.0),
        ),
        // pet race
        Container(
          width: double.infinity,
          child: Text(
            'Pet Race',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
            ),
          ),
          margin: EdgeInsets.only(left: 10.0, bottom: 5.0, top: 10.0),
        ),
        Container(
          child: Theme(
            data: Theme.of(context).copyWith(),
            child: TextField(
              onChanged: (text) {
                setState(() {
                  this._detailHewanModel.race = text;
                });
              },
              decoration: InputDecoration(
                hintText: this._detailHewanModel.race == null
                    ? ""
                    : this._detailHewanModel.race,
                contentPadding: new EdgeInsets.all(5.0),
                hintStyle: TextStyle(color: Colors.black),
              ),
            ),
          ),
          margin: EdgeInsets.only(left: 30.0, right: 30.0),
        ),
        // pet fur
        Container(
          width: double.infinity,
          child: Text(
            'Fur Color',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
            ),
          ),
          margin: EdgeInsets.only(left: 10.0, bottom: 5.0, top: 10.0),
        ),
        Container(
          child: Theme(
            data: Theme.of(context).copyWith(),
            child: TextField(
              onChanged: (text) {
                setState(() {
                  this._detailHewanModel.furColor = text;
                });
              },
              decoration: InputDecoration(
                hintText: this._detailHewanModel.furColor == null
                    ? ""
                    : this._detailHewanModel.furColor,
                contentPadding: new EdgeInsets.all(5.0),
                hintStyle: TextStyle(color: Colors.black),
              ),
            ),
          ),
          margin: EdgeInsets.only(left: 30.0, right: 30.0),
        ),
      ]);

  Widget detailHewanContent() => Container(
      margin: EdgeInsets.all(10.0),
      child: Center(
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Colors.white,
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10.0,
                  offset: Offset(0.0, 10.0))
            ],
          ),
          child: Container(
            padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
            width: double.infinity,
            height: 600.0,
            child: inputContent(),
          ),
        ),
      ));

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
              onPressed: _saveData,
            ),
          ),
        ),
      );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            flex: 8,
            // child: Container(),
            child: SingleChildScrollView(
              child: Stack(children: <Widget>[
                detailHewanContent(),
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
