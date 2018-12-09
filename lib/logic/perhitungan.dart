import 'package:latlong/latlong.dart';
class Perhitungan {
  int hitungJarak(lat, lon, lat2, lon2) {
    final harvesine = new Haversine();
    int result =
        (harvesine.distance(new LatLng(lat, lon), new LatLng(lat2, lon2)) /
                1000)
            .floor();
    return result;
  }
}
