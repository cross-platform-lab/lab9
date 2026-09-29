import '../utilities/constants.dart';
import 'location.dart';
import 'networking.dart';

// Dữ liệu thời tiết đã chuẩn hoá theo định dạng của OpenWeatherMap.
class WeatherData {
  WeatherData({required this.temperature, required this.condition, required this.cityName, required this.description});

  final double temperature;
  final int condition; // mã điều kiện thời tiết theo chuẩn OpenWeatherMap
  final String cityName;
  final String description;

  factory WeatherData.fromOpenWeatherJson(dynamic json) {
    return WeatherData(
      temperature: (json['main']['temp'] as num).toDouble(),
      condition: json['weather'][0]['id'] as int,
      cityName: json['name'] as String,
      description: json['weather'][0]['description'] as String,
    );
  }
}

class WeatherModel {
  bool get usingOpenWeatherMap => kOpenWeatherApiKey.isNotEmpty;

  Future<WeatherData> getCityWeather(String cityName) async {
    if (usingOpenWeatherMap) {
      final url = '$kOpenWeatherMapURL?q=${Uri.encodeComponent(cityName)}'
          '&appid=$kOpenWeatherApiKey&units=metric&lang=vi';
      return WeatherData.fromOpenWeatherJson(await NetworkHelper(url).getData());
    }

    // Dự phòng: tìm toạ độ thành phố bằng Open-Meteo Geocoding.
    final geo = await NetworkHelper(
      'https://geocoding-api.open-meteo.com/v1/search?name=${Uri.encodeComponent(cityName)}&count=1&language=vi',
    ).getData();
    final results = geo['results'] as List?;
    if (results == null || results.isEmpty) {
      throw Exception('Không tìm thấy thành phố "$cityName".');
    }
    final place = results.first;
    return _openMeteoWeather(
      (place['latitude'] as num).toDouble(),
      (place['longitude'] as num).toDouble(),
      place['name'] as String,
    );
  }

  Future<WeatherData> getLocationWeather() async {
    final location = Location();
    await location.getCurrentLocation();
    final lat = location.latitude!;
    final lon = location.longitude!;

    if (usingOpenWeatherMap) {
      final url = '$kOpenWeatherMapURL?lat=$lat&lon=$lon'
          '&appid=$kOpenWeatherApiKey&units=metric&lang=vi';
      return WeatherData.fromOpenWeatherJson(await NetworkHelper(url).getData());
    }

    String cityName = 'Vị trí của bạn';
    try {
      final rev = await NetworkHelper(
        'https://api.bigdatacloud.net/data/reverse-geocode-client?latitude=$lat&longitude=$lon&localityLanguage=vi',
      ).getData();
      final city = (rev['city'] as String?)?.trim();
      final locality = (rev['locality'] as String?)?.trim();
      if (city != null && city.isNotEmpty) {
        cityName = city;
      } else if (locality != null && locality.isNotEmpty) {
        cityName = locality;
      }
    } catch (_) {}
    return _openMeteoWeather(lat, lon, cityName);
  }

  Future<WeatherData> _openMeteoWeather(double lat, double lon, String cityName) async {
    final json = await NetworkHelper(
      'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current=temperature_2m,weather_code',
    ).getData();
    final code = json['current']['weather_code'] as int;
    return WeatherData(
      temperature: (json['current']['temperature_2m'] as num).toDouble(),
      condition: _wmoToOpenWeatherId(code),
      cityName: cityName,
      description: _wmoDescription(code),
    );
  }

  // Chuyển mã WMO (Open-Meteo) sang mã điều kiện OpenWeatherMap tương đương.
  int _wmoToOpenWeatherId(int code) {
    if (code >= 95) return 211; // dông
    if (code >= 71 && code <= 86 && code != 80 && code != 81 && code != 82) return 601; // tuyết
    if (code >= 80) return 521; // mưa rào
    if (code >= 61) return 501; // mưa
    if (code >= 51) return 301; // mưa phùn
    if (code >= 45) return 741; // sương mù
    if (code >= 1) return 802; // có mây
    return 800; // trời quang
  }

  String _wmoDescription(int code) {
    if (code >= 95) return 'dông';
    if (code >= 80) return 'mưa rào';
    if (code >= 71) return 'tuyết';
    if (code >= 61) return 'mưa';
    if (code >= 51) return 'mưa phùn';
    if (code >= 45) return 'sương mù';
    if (code == 3) return 'nhiều mây';
    if (code >= 1) return 'mây rải rác';
    return 'trời quang';
  }

  String getWeatherIcon(int condition) {
    if (condition < 300) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  String getMessage(int temp) {
    if (temp > 30) {
      return 'Trời nóng, nhớ mang theo nước và kem 🍦';
    } else if (temp > 22) {
      return 'Thời tiết đẹp, mặc áo thun 👕 là hợp lý';
    } else if (temp < 12) {
      return 'Trời lạnh, đừng quên khăn 🧣 và găng tay 🧤';
    } else {
      return 'Mang theo áo khoác 🧥 phòng khi trở lạnh';
    }
  }
}
