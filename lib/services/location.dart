import 'dart:io' show Platform;

import 'package:geolocator/geolocator.dart';

// Lấy vị trí GPS hiện tại của thiết bị bằng geolocator.
class Location {
  double? latitude;
  double? longitude;

  Future<void> getCurrentLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Dịch vụ vị trí đang tắt.');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      throw Exception('Không có quyền truy cập vị trí.');
    }

    Position? position;
    try {
      // Trên Android dùng LocationManager trực tiếp để không phụ thuộc hộp thoại của Google Play Services.
      final LocationSettings settings = Platform.isAndroid
          ? AndroidSettings(
              accuracy: LocationAccuracy.low,
              forceLocationManager: true,
              timeLimit: const Duration(seconds: 10),
            )
          : const LocationSettings(
              accuracy: LocationAccuracy.low,
              timeLimit: Duration(seconds: 10),
            );
      position = await Geolocator.getCurrentPosition(locationSettings: settings);
    } catch (_) {
      position = await Geolocator.getLastKnownPosition(forceAndroidLocationManager: Platform.isAndroid);
    }
    if (position == null) {
      throw Exception('Không xác định được vị trí.');
    }
    latitude = position.latitude;
    longitude = position.longitude;
  }
}
