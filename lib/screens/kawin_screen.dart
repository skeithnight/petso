import 'package:flutter/material.dart';

import 'tambah_pacak_screen.dart';

class KawinScreen extends StatefulWidget {
  _KawinScreenState createState() => _KawinScreenState();
}

class _KawinScreenState extends State<KawinScreen> {
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
                      TambahPacakScreen());
        },
        tooltip: 'Add Pacak',
        child: Icon(Icons.add),
      ),
    );
  }
}