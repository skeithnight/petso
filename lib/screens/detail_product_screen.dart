import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:petso/models/product_model.dart';
import 'kelola_hewan_screen.dart';

class DetailProductScreen extends StatefulWidget {
  ProductModel _productModel;
  final String level;
  DetailProductScreen(this.level, this._productModel);
  _DetailProductScreenState createState() => _DetailProductScreenState();
}

class _DetailProductScreenState extends State<DetailProductScreen> {
  ProductModel productModel = new ProductModel();
  bool isLoading = false;
  File _image;
  String id;

  SharedPreferences prefs;
  final mainReference = FirebaseDatabase.instance.reference();

  void initState() {
    super.initState();
    getData();
    if (widget.level != 'add') {
      this.productModel = widget._productModel;
    }
  }

  void getData() async {
    print(widget.level);
    prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getString('id') ?? '';
      isLoading = false;
    });
    // print(isLoading);
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  _saveData() {
    if (productModel.namaProduct == null ||
        productModel.typeProduct == null ||
        productModel.descriptionProduct == null ||
        productModel.hargaProduct == null) {
      // print(json.encode(_detailHewanModel));
      tampilDialog("Failed", "Please complete all fill!");
    } else {
      // print(json.encode(_detailHewanModel));
      if (widget.level == 'add') {
        // print('addd');
        mainReference
            .child("store")
            .child(id)
            .child("product")
            .push()
            .set(productModel.toJson())
            .then((response) {
          tampilDialog("Success", "Your data has been save");
        });
      } else {
        if (productModel.idProduct != null) {
          // print('edit');
          mainReference
              .child("store")
              .child(id)
              .child("product")
              .child(productModel.idProduct)
              .set(productModel.toJson())
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
                  // Navigator.pushReplacement(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => List()));
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
        title: new Text("Add Product"),
      );
    } else {
      return new AppBar(
        title: new Text("Detail Product"),
      );
    }
  }

  Widget inputContent() =>
      Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
        // image
        new Center(
            child: _image == null
                ? widget.level == "Detail"
                    ? new Container(
                        height: 100.0,
                        child: RaisedButton(
                          onPressed: getImage,
                          child: Text('Pick Image'),
                        ))
                    : new Container(
                        height: 100.0,
                        child: Image.network(
                            "https://shop-cdn-m.shpp.ext.zooplus.io/bilder/royal/canin/maxi/adult/8/400/80729_pla_royalcanin_maxiadult_15kg_hs_01_8.jpg"),
                      )
                : new Container(
                    height: 100.0,
                    child: InkWell(
                      child: Image.file(_image),
                      onTap: getImage,
                    ))),
        // name
        Container(
          width: double.infinity,
          child: Text(
            'Product Name',
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
              enabled: widget.level == "Detail" ? true : false,
              onChanged: (text) {
                setState(() {
                  this.productModel.namaProduct = text;
                });
              },
              decoration: InputDecoration(
                hintText: this.productModel.namaProduct == null
                    ? ""
                    : this.productModel.namaProduct,
                contentPadding: new EdgeInsets.all(5.0),
                hintStyle: TextStyle(color: Colors.black),
              ),
            ),
          ),
          margin: EdgeInsets.only(left: 30.0, right: 30.0),
        ),
        // type
        Container(
          width: double.infinity,
          child: Text(
            'Product Type',
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
              child: widget.level == "Detail"
                  ? new DropdownButton<String>(
                      value: this.productModel.typeProduct == null
                          ? 'Select product type'
                          : this.productModel.typeProduct,
                      items: <String>[
                        'Select product type',
                        'Pet Food',
                        'Accessories',
                        'Medicine'
                      ].map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                      onChanged: (text) {
                        setState(() {
                          this.productModel.typeProduct = text;
                        });
                      },
                    )
                  : new TextField(
                      enabled: false,
                      decoration: InputDecoration(
                        hintText: this.productModel.typeProduct == null
                            ? ""
                            : this.productModel.typeProduct,
                        contentPadding: new EdgeInsets.all(5.0),
                        hintStyle: TextStyle(color: Colors.black),
                      ),
                    )),
          margin: EdgeInsets.only(left: 30.0, right: 30.0),
        ),
        // Desripction
        Container(
          width: double.infinity,
          child: Text(
            'Description',
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
            child: TextField(
              enabled: widget.level == "Detail" ? true : false,
              maxLines: 5,
              keyboardType: TextInputType.multiline,
              onChanged: (text) {
                setState(() {
                  this.productModel.descriptionProduct = text;
                });
              },
              decoration: InputDecoration(
                hintText: this.productModel.descriptionProduct == null
                    ? ""
                    : this.productModel.descriptionProduct,
                contentPadding: new EdgeInsets.all(5.0),
                hintStyle: TextStyle(color: Colors.black),
              ),
            ),
          ),
          margin: EdgeInsets.only(left: 30.0, right: 30.0),
        ),
        // Price
        Container(
          width: double.infinity,
          child: Text(
            'Price',
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
              enabled: widget.level == "Detail" ? true : false,
              keyboardType: TextInputType.number,
              onChanged: (text) {
                setState(() {
                  this.productModel.hargaProduct = int.parse(text);
                });
              },
              decoration: InputDecoration(
                prefix: Text("Rp. "),
                hintText: this.productModel.hargaProduct == null
                    ? ""
                    : this.productModel.hargaProduct.toString(),
                contentPadding: new EdgeInsets.all(5.0),
                hintStyle: TextStyle(color: Colors.black),
              ),
            ),
          ),
          margin: EdgeInsets.only(left: 30.0, right: 30.0),
        ),
      ]);

  Widget detailProductContent() => Container(
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
                detailProductContent(),
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
            child: widget.level == "Detail" ? saveButton() : Container(),
          ),
        ],
      ),
    );
  }
}
