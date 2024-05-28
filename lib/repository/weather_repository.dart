import 'dart:convert';

import 'package:flutter_training/data/app_exception.dart';
import 'package:flutter_training/data/weather.dart';
import 'package:flutter_training/data/weather_condition.dart';
import 'package:flutter_training/data/weather_request.dart';
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

  Weather fetchWeather(String area, DateTime date) {
    final request =
        WeatherRequest(area: area, date: date.toUtc().toIso8601String())
            .toJson();
    try {
      final response = _client.fetchWeather(jsonEncode(request));
      return Weather.fromJson(jsonDecode(response) as Map<String, dynamic>);
    } on YumemiWeatherError catch (e) {
      switch (e) {
        case YumemiWeatherError.invalidParameter:
          throw const InvalidParameterException();
        case YumemiWeatherError.unknown:
          throw const UnknownException();
      }
    } on UndefinedWeatherException {
      rethrow;
    } on ResponseFormatException {
      rethrow;
    }
  }
}
