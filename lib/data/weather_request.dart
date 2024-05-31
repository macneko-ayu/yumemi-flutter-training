
import 'package:flutter_training/data/date_time_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/weather_request.freezed.dart';
part 'generated/weather_request.g.dart';

@Freezed(toJson: true, fromJson: false)
class WeatherRequest with _$WeatherRequest {
  factory WeatherRequest({
    required String area,
    @DateTimeConverter() required DateTime date,
  }) = _WeatherRequest;
}
