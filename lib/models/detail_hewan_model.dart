class DetailHewanModel {
  String idPet;
  String photoUrlPet;
  String petName;
  String identity;
  String gender;
  String age;
  String type;
  String race;
  String furColor;

  DetailHewanModel();

  DetailHewanModel.fromSnapshot(Map<dynamic, dynamic> snapshot,String id)
      : idPet = id,
        photoUrlPet = snapshot["photoUrlPet"],
        petName = snapshot["petName"],
        identity = snapshot["identity"],
        gender = snapshot["gender"],
        age = snapshot["age"],
        type = snapshot["type"],
        race = snapshot["race"],
        furColor = snapshot["furColor"];

  DetailHewanModel.fromData(Map<dynamic, dynamic> snapshot)
      : idPet = snapshot["idPet"],
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
      "idPet": idPet,
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
