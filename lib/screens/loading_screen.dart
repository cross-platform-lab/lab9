import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../services/weather_model.dart';
import 'location_screen.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    getLocationData();
  }

  Future<void> getLocationData() async {
    WeatherData? weatherData;
    String? error;
    try {
      weatherData = await WeatherModel().getLocationWeather();
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    }
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LocationScreen(locationWeather: weatherData, initialError: error),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF1B2440),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SpinKitDoubleBounce(color: Colors.white, size: 100.0),
            SizedBox(height: 24),
            Text('Đang lấy vị trí và thời tiết...', style: TextStyle(color: Colors.white70, fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
