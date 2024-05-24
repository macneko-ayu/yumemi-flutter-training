import 'package:flutter_training/data/app_exception.dart';
import 'package:flutter_training/data/weather_condition.dart';

class WeatherInfo {
  WeatherInfo({
    required this.weatherCondition,
    required this.maxTemperature,
    required this.minTemperature,
    required this.date,
  });

  factory WeatherInfo.fromJson(Map<String, dynamic> json) {
    try {
      return WeatherInfo(
        weatherCondition:
            WeatherCondition.from(json['weather_condition'].toString()),
        maxTemperature: int.parse(json['max_temperature'].toString()),
        minTemperature: int.parse(json['min_temperature'].toString()),
        date: json['date'].toString(),
      );
    } on UndefinedWeatherException {
      rethrow;
    } on FormatException {
      throw const ResponseFormatException();
    }
  }

  WeatherCondition? weatherCondition;
  int maxTemperature;
  int minTemperature;
  String date;
}
