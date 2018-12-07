import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:petso/models/pacak_model.dart';

class DetailPacakScreen extends StatefulWidget {
  PacakModel pacakModel = new PacakModel();
  DetailPacakScreen(this.pacakModel);
  @override
  _DetailPacakScreenState createState() => _DetailPacakScreenState();
}

class _DetailPacakScreenState extends State<DetailPacakScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Container(
            child: Text(json.encode(widget.pacakModel)),
          ),
        ),
      ),
    );
  }
}
