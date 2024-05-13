import 'package:flutter/material.dart';
import 'package:flutter_training/data/weather_condition.dart';
import 'package:yumemi_weather/yumemi_weather.dart';

class YumemiWeatherAPI {
  final _yumemiWeather = YumemiWeather();

  WeatherCondition? fetchSimpleWeather() {
    final response = _yumemiWeather.fetchSimpleWeather();
    try {
      return WeatherCondition.from(response);
    } on Exception catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
