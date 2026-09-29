import 'package:flutter/material.dart';

// API key OpenWeatherMap truyền vào lúc build/run:
//   flutter run --dart-define=OWM_API_KEY=<your_key>
// Nếu để trống, ứng dụng tự động dùng Open-Meteo (không cần key) làm nguồn dữ liệu dự phòng.
const String kOpenWeatherApiKey = String.fromEnvironment('OWM_API_KEY');
const String kOpenWeatherMapURL = 'https://api.openweathermap.org/data/2.5/weather';

const kTempTextStyle = TextStyle(fontSize: 100.0, fontWeight: FontWeight.bold, color: Colors.white);

const kMessageTextStyle = TextStyle(fontSize: 34.0, color: Colors.white);

const kButtonTextStyle = TextStyle(fontSize: 26.0, color: Colors.white);

const kConditionTextStyle = TextStyle(fontSize: 100.0);

const kTextFieldInputDecoration = InputDecoration(
  filled: true,
  fillColor: Colors.white,
  icon: Icon(Icons.location_city, color: Colors.white),
  hintText: 'Nhập tên thành phố',
  hintStyle: TextStyle(color: Colors.grey),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
    borderSide: BorderSide.none,
  ),
);
