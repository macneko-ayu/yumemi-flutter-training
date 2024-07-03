import 'package:flutter_training/data/weather.dart';
import 'package:flutter_training/repository/weather_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/weather_notifier.g.dart';

@riverpod
class WeatherNotifier extends _$WeatherNotifier {
  @override
  Future<Weather?> build() async => null;

  Future<void> fetchWeather({
    required String area,
    required DateTime date,
  }) async {
    final repository = ref.read(weatherRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() {
      return repository.fetchWeather(area: area, date: date);
    });
  }
}
