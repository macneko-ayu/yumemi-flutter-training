
import 'package:flutter_training/data/weather.dart';
import 'package:flutter_training/repository/weather_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/weather_notifier.g.dart';

@riverpod
class WeatherNotifier extends _$WeatherNotifier {
  @override
  Weather? build() => null;

  void fetchWeather({required String area, required DateTime date}) {
    final weather = ref
        .read(weatherRepositoryProvider)
        .fetchWeather(area: area, date: date);
    state = weather;
  }
}
