import 'package:flutter_training/data/app_exception.dart';

enum WeatherCondition {
  sunny,
  cloudy,
  rainy;

  factory WeatherCondition.from(String name) {
    return values.singleWhere(
      (element) => element.name == name,
      orElse: () => throw const UndefinedWeatherException(),
    );
  }
}
