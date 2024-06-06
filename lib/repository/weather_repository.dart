import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_training/data/app_exception.dart';
import 'package:flutter_training/data/weather.dart';
import 'package:flutter_training/data/weather_request.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yumemi_weather/yumemi_weather.dart';

part 'generated/weather_repository.g.dart';

@riverpod
YumemiWeather yumemiWeather(YumemiWeatherRef ref) {
  return YumemiWeather();
}

@riverpod
WeatherRepository weatherRepository(WeatherRepositoryRef ref) {
  final client = ref.read(yumemiWeatherProvider);
  return WeatherRepository(client: client);
}

class WeatherRepository {
  const WeatherRepository({required YumemiWeather client}) : _client = client;
  final YumemiWeather _client;

  Weather fetchWeather(String area, DateTime date) {
    final request =
        WeatherRequest(area: area, date: date)
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
    } on CheckedFromJsonException catch (e) {
      if (kDebugMode) {
        // Exceptionの要因となった箇所をデバッグ用に出力する
        debugPrint(e.toString());
      }
      throw const ResponseFormatException();
    }
  }
}
