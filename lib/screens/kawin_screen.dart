import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';

import 'tambah_pacak_screen.dart';


class KawinScreen extends StatefulWidget {
  _KawinScreenState createState() => _KawinScreenState();
}

class _KawinScreenState extends State<KawinScreen> {
  Widget listDataPacakWidget() {
    // return Text(id ?? '');
    return StreamBuilder<Event>(
        stream: FirebaseDatabase.instance
            .reference()
            .child("pacaks")
            .onValue,
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return new Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.hasData) {
              // listDetailHewan = new List();
              // Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
              // List<dynamic> list2 = map.keys.toList();
              // List<dynamic> list = map.values.toList();
              // for (var i = 0; i < list.length; i++) {
              //   listDetailHewan
              //       .add(new DetailHewanModel.fromSnapshot(list[i], list2[i]));
              // }
              // print(json.encode(listDetailHewan));
              return Container();
            }
            print("Kosong");
            return new Center(
              child: Text("kosong"),
            );
          }
        });
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
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      TambahPacakScreen()));
        },
        tooltip: 'Add Pacak',
        child: Icon(Icons.add),
      ),
    );
  }
}