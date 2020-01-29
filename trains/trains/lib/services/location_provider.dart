import 'package:flutter/services.dart';
import 'package:location/location.dart';

class LocationProvider {
  final Location provider = new Location();

  LocationProvider() {
    provider.changeSettings(accuracy: LocationAccuracy.BALANCED);
  }

  Future<LocationData> fetchLocation() async {
    try {
      return await provider.getLocation();
    } on PlatformException catch (e) {
      if (e.code == "PERMISSION_DENIED") {
        return fetchLocation();
      }
    }
  }
}
