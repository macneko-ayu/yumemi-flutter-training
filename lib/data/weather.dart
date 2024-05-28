import 'package:flutter_training/data/date_time_converter.dart';
import 'package:flutter_training/data/weather_condition.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'weather.freezed.dart';
part 'weather.g.dart';

@freezed
class Weather with _$Weather {
  const factory Weather({
    required WeatherCondition weatherCondition,
    required int maxTemperature,
    required int minTemperature,
    @DateTimeConverter() required DateTime date,
  }) = _Weather;

  factory Weather.fromJson(Map<String, dynamic> json) =>
      _$WeatherFromJson(json);
}
