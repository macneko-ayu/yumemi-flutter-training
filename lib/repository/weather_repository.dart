import 'package:flutter_training/data/app_exception.dart';
import 'package:flutter_training/data/weather_condition.dart';
import 'package:yumemi_weather/yumemi_weather.dart';

class WeatherRepository {
  final _client = YumemiWeather();

  WeatherCondition? fetchSimpleWeather() {
    try {
      final response = _client.fetchSimpleWeather();
      return WeatherCondition.from(response);
    } on UndefinedWeatherException {
      rethrow;
    }
  }

  WeatherCondition? fetchThrowsWeather(String area) {
    try {
      final response = _client.fetchThrowsWeather(area);
      return WeatherCondition.from(response);
    } on YumemiWeatherError catch (e) {
      switch (e) {
        case YumemiWeatherError.invalidParameter:
          throw const InvalidParameterException();
        case YumemiWeatherError.unknown:
          throw const UnknownException();
      }
    } on UndefinedWeatherException {
      rethrow;
    }
  }
}
