import 'detail_hewan_model.dart';
class DetailPacakHewan {
  DetailHewanModel detailHewanModel;
  String photoUrlPet;
  String petName;
  String identity;
  String gender;
  String age;
  String type;
  String race;
  String furColor;

  DetailPacakHewan();

  DetailPacakHewan.fromSnapshot(Map<dynamic, dynamic> snapshot)
      : detailHewanModel = DetailHewanModel.fromSnapshot(snapshot['detailHewanModel'], snapshot['idPet']),
        photoUrlPet = snapshot["photoUrlPet"],
        petName = snapshot["petName"],
        identity = snapshot["identity"],
        gender = snapshot["gender"],
        age = snapshot["age"],
        type = snapshot["type"],
        race = snapshot["race"],
        furColor = snapshot["furColor"];

  toJson() {
    return {
      "detailHewanModel": detailHewanModel,
      "photoUrlPet": photoUrlPet,
      "petName": petName,
      "identity": identity,
      "gender": gender,
      "age": age,
      "type": type,
      "race": race,
      "furColor": furColor,
    };
  }
}
