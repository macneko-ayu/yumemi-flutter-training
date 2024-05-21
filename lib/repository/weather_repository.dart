import 'dart:convert';

import 'package:flutter_training/data/app_exception.dart';
import 'package:flutter_training/data/weather_condition.dart';
import 'package:flutter_training/data/weather_info.dart';
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

  WeatherInfo fetchWeather(String area, DateTime date) {
    final jsonString = '''
      {
          "area": "$area",
          "date": "${date.toUtc().toIso8601String()}"
      }''';
    try {
      final response = _client.fetchWeather(jsonString);
      return WeatherInfo.fromJson(jsonDecode(response) as Map<String, dynamic>);
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
