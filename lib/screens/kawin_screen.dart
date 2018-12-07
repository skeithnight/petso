import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';

import 'tambah_pacak_screen.dart';
import 'package:petso/models/pacak_model.dart';
import 'detail_pacak_screen.dart';

class KawinScreen extends StatefulWidget {
  _KawinScreenState createState() => _KawinScreenState();
}

class _KawinScreenState extends State<KawinScreen> {
  // String id;
  int pilihan;
  List<PacakModel> listPacakModel;

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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              DetailPacakScreen(listPacakModel[index])));
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
              ),
            ));
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
