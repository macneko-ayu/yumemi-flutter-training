import 'package:flutter_training/data/weather_condition.dart';

class WeatherInfo {
  WeatherInfo({
    required this.weatherCondition,
    required this.maxTemperature,
    required this.minTemperature,
    required this.date,
  });

  factory WeatherInfo.fromJson(Map<String, dynamic> json) => WeatherInfo(
        weatherCondition:
            WeatherCondition.from(json['weather_condition'] as String),
        maxTemperature: json['max_temperature'] as int,
        minTemperature: json['min_temperature'] as int,
        date: json['date'] as String,
      );

  WeatherCondition? weatherCondition;
  int maxTemperature;
  int minTemperature;
  String date;
}
