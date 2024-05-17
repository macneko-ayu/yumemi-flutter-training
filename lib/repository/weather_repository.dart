import 'package:flutter/foundation.dart';
import 'package:flutter_training/data/weather_condition.dart';
import 'package:yumemi_weather/yumemi_weather.dart';

class WeatherRepository {
  final _client = YumemiWeather();

  WeatherCondition? fetchSimpleWeather() {
    final response = _client.fetchSimpleWeather();
    try {
      return WeatherCondition.from(response);
    } on Exception catch (e) {
      if (kDebugMode) {
        debugPrint(e.toString());
      }
      return null;
    }
  }
}
