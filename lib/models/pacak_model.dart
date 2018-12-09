import 'dart:convert';
import 'detail_hewan_model.dart';
import 'package:google_places_picker/google_places_picker.dart';
import 'package:petso/models/lokasi_pacak_model.dart';
class PacakModel {
  String idPacak;
  String idUser;
  String phoneNumber;
  DetailHewanModel detailHewanModel;
  LokasiPacakModel lokasiPacak;

  PacakModel();
  
  PacakModel.fromSnapshot(Map<dynamic, dynamic> snapshot,String id)
      : idPacak = id,
        idUser = snapshot['users'],
        phoneNumber = snapshot['phoneNumber'],
        detailHewanModel = DetailHewanModel.fromData(snapshot["detailHewan"]),
        lokasiPacak = LokasiPacakModel.fromSnapshot(snapshot["lokasiPacak"]);

  toJson() {
    return {
      "idPacak": idPacak,
      "users": idUser,
      "phoneNumber": phoneNumber,
      "detailHewanModel": detailHewanModel,
      "lokasiPacak": lokasiPacak,
    };
  }
}