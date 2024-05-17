import 'package:flutter/material.dart';
import 'package:flutter_training/data/weather_condition.dart';
import 'package:yumemi_weather/yumemi_weather.dart';

class WeatherRepository {
  final _client = YumemiWeather();

  @override
  WeatherCondition? fetchSimpleWeather() {
    final response = _client.fetchSimpleWeather();
    try {
      return WeatherCondition.from(response);
    } on Exception catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
