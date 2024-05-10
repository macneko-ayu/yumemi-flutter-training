import 'package:flutter_training/infra/yumemi_weather_api.dart';

abstract class WeatherRepository {
  String fetchSimpleWeather();
}

class WeatherRepositoryImpl implements WeatherRepository {
  final _client = YumemiWeatherAPI();

  @override
  String fetchSimpleWeather() {
    return _client.fetchSimpleWeather();
  }
}
