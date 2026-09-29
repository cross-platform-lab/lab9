import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../services/weather_model.dart';
import '../utilities/constants.dart';
import 'city_screen.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key, this.locationWeather, this.initialError});

  final WeatherData? locationWeather;
  final String? initialError;

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final WeatherModel weather = WeatherModel();
  bool loading = false;
  int temperature = 0;
  String weatherIcon = '';
  String cityName = '';
  String description = '';
  String weatherMessage = '';

  @override
  void initState() {
    super.initState();
    updateUI(widget.locationWeather, error: widget.initialError);
  }

  void updateUI(WeatherData? data, {String? error}) {
    setState(() {
      if (data == null) {
        temperature = 0;
        weatherIcon = 'Lỗi';
        description = '';
        weatherMessage = error ?? 'Không thể lấy dữ liệu thời tiết';
        cityName = '';
        return;
      }
      temperature = data.temperature.round();
      weatherIcon = weather.getWeatherIcon(data.condition);
      description = data.description;
      weatherMessage = weather.getMessage(temperature);
      cityName = data.cityName;
    });
  }

  Future<void> load(Future<WeatherData> Function() fetch) async {
    setState(() => loading = true);
    try {
      updateUI(await fetch());
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.white.withValues(alpha: 0.8), BlendMode.dstATop),
          ),
        ),
        constraints: const BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    tooltip: 'Thời tiết tại vị trí hiện tại',
                    onPressed: () => load(weather.getLocationWeather),
                    icon: const Icon(Icons.near_me, size: 50.0, color: Colors.white),
                  ),
                  if (loading) const SpinKitThreeBounce(color: Colors.white, size: 24),
                  IconButton(
                    tooltip: 'Tìm theo thành phố',
                    onPressed: () async {
                      final typedName = await Navigator.push<String>(
                        context,
                        MaterialPageRoute(builder: (context) => const CityScreen()),
                      );
                      if (typedName != null && typedName.trim().isNotEmpty) {
                        load(() => weather.getCityWeather(typedName.trim()));
                      }
                    },
                    icon: const Icon(Icons.location_city, size: 50.0, color: Colors.white),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('$temperature°', style: kTempTextStyle),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(weatherIcon, style: kConditionTextStyle.copyWith(fontSize: 80)),
                        ),
                      ],
                    ),
                    Text(
                      '$cityName${description.isEmpty ? '' : ' · $description'}',
                      style: const TextStyle(fontSize: 26, color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15.0, bottom: 20),
                child: Text(
                  weatherMessage,
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  weather.usingOpenWeatherMap ? 'Nguồn: OpenWeatherMap' : 'Nguồn: Open-Meteo (chưa cấu hình OWM_API_KEY)',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
