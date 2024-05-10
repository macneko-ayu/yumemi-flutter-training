import 'package:yumemi_weather/yumemi_weather.dart';

class YumemiWeatherAPI {
  final _yumemiWeather = YumemiWeather();

  String fetchSimpleWeather() {
    return _yumemiWeather.fetchSimpleWeather();
  }
}
