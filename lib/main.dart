import 'package:flutter/material.dart';

import 'screens/loading_screen.dart';

// Lab 9: Clima
// Ứng dụng thời tiết: lấy vị trí bằng geolocator, gọi API OpenWeatherMap và hiển thị kết quả.
void main() {
  runApp(const ClimaApp());
}

class ClimaApp extends StatelessWidget {
  const ClimaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clima',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const LoadingScreen(),
    );
  }
}
