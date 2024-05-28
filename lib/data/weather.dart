import 'package:flutter_training/data/app_exception.dart';
import 'package:flutter_training/data/weather_condition.dart';

class Weather {
  Weather({
    required this.weatherCondition,
    required this.maxTemperature,
    required this.minTemperature,
    required this.date,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    try {
      return Weather(
        weatherCondition:
            WeatherCondition.from(json['weather_condition'].toString()),
        maxTemperature: int.parse(json['max_temperature'].toString()),
        minTemperature: int.parse(json['min_temperature'].toString()),
        date: DateTime.parse(json['date'].toString()),
      );
    } on UndefinedWeatherException {
      rethrow;
    } on FormatException {
      throw const ResponseFormatException();
    }
  }

  final WeatherCondition weatherCondition;
  final int maxTemperature;
  final int minTemperature;
  final DateTime date;
}
