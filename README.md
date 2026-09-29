# Lab 9: Clima

Ứng dụng thời tiết lấy dữ liệu trực tiếp từ OpenWeatherMap theo vị trí GPS hoặc tên thành phố.

## Chức năng

- `geolocator` lấy vị trí hiện tại, `http` gọi API và parse JSON.
- Màn hình Loading (`flutter_spinkit`) → Location (nhiệt độ, icon, mô tả, lời khuyên) → City (nhập tên thành phố).
- Biểu tượng thời tiết thay đổi theo mã điều kiện trả về từ API.

## Cấu trúc chính

- `lib/main.dart`
- `lib/services/location.dart`
- `lib/services/networking.dart`
- `lib/services/weather_model.dart`
- `lib/screens/`
- `lib/utilities/constants.dart`

## Chạy ứng dụng

```bash
flutter pub get
flutter run
```

## API key

Ứng dụng dùng [OpenWeatherMap Current Weather API](https://openweathermap.org/current). Truyền API key khi chạy:

```bash
flutter run --dart-define=OWM_API_KEY=<your_api_key>
```

Nếu không truyền key, ứng dụng tự động dùng [Open-Meteo](https://open-meteo.com/) (miễn phí, không cần key) làm nguồn dữ liệu dự phòng để vẫn chạy được.

Trên Android emulator có thể đặt vị trí giả lập: `adb emu geo fix 108.2022 16.0544` (Đà Nẵng).

## Demo

![screenshot](docs/screenshot.png)
