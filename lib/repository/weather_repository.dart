import 'package:flutter_training/data/weather_condition.dart';
import 'package:flutter_training/infra/yumemi_weather_api.dart';

abstract class WeatherRepository {
  WeatherCondition? fetchSimpleWeather();
}

class WeatherRepositoryImpl implements WeatherRepository {
  final _client = YumemiWeatherAPI();

  @override
  WeatherCondition? fetchSimpleWeather() {
    return _client.fetchSimpleWeather();
  }
}
