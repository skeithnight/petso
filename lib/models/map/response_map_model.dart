import 'dart:convert';
class ResponseMapModel {
  String routes;
  double duration;
  double distance;
  String code;
  

  ResponseMapModel();
  

  ResponseMapModel.fromSnapshot(Map<String, dynamic> snapshot)
      : routes = json.encode(snapshot["routes"][0]['legs'][0]['steps']),
        duration = snapshot["routes"][0]['legs'][0]['duration'],
        distance = snapshot["routes"][0]['legs'][0]['distance'],
        code = snapshot["code"];

  toJson() {
    return {
      "routes": routes,
      "code": code,
    };
  }
}