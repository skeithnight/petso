import 'dart:convert';
import 'detail_hewan_model.dart';
import 'package:google_places_picker/google_places_picker.dart';
import 'lokasi_pacak_model.dart';
import 'product_model.dart';
class DetailTokoModel {
  String idToko;
  String namaToko;
  String siup;
  LokasiPacakModel lokasiPacakModel;
  

  DetailTokoModel();
  

  DetailTokoModel.fromSnapshot(Map<dynamic, dynamic> snapshot,String id)
      : idToko = id,
        namaToko = snapshot["namaToko"],
        siup = snapshot["siup"],
        lokasiPacakModel = LokasiPacakModel.fromSnapshot(snapshot["lokasiPacak"]);

  toJson() {
    return {
      "id": idToko,
      "namaToko": namaToko,
      "siup": siup,
      "lokasiPacak": lokasiPacakModel,
    };
  }
}