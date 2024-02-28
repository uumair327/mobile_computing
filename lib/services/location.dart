import 'dart:async';
import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:nominatim_geocoding/nominatim_geocoding.dart';

class LocationService {
  Future<bool> permissionStatus() async {
    await Geolocator.requestPermission();

    if (Geolocator.checkPermission() == LocationPermission.deniedForever ||
        Geolocator.checkPermission() == LocationPermission.denied ||
        Geolocator.checkPermission() == LocationPermission.unableToDetermine) {
      if (Geolocator.checkPermission() == LocationPermission.deniedForever ||
          Geolocator.checkPermission() == LocationPermission.denied) {
        return false;
      }
    }
    return true;
  }

  Future getCurrentLocation() async {
    if (await permissionStatus()) {
      Position location = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
      return location;
    } else {
      exit(0);
    }
  }

  Future getLocation() async {
    await NominatimGeocoding.init(reqCacheNum: 20);
    Geocoding geocoding = await NominatimGeocoding.to.forwardGeoCoding(
      const Address(
        city: 'bhiwandi',
        postalCode: 421302,
      ),
    );
    print(geocoding);
  }
}
