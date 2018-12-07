import 'dart:convert';
import 'detail_hewan_model.dart';
import 'package:google_places_picker/google_places_picker.dart';
class LokasiPacakModel {
  double latitude;
  double longitude;
  String address;

  LokasiPacakModel();
  
  LokasiPacakModel.fromSnapshot(Map<dynamic, dynamic> snapshot)
      : latitude = snapshot["latitude"],
        longitude = snapshot["longitude"],
        address = snapshot["address"];

  toJson() {
    return {
      "latitude": latitude,
      "longitude": longitude,
      "address": address,
    };
  }
}