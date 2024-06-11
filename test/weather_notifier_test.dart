import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_training/data/app_exception.dart';
import 'package:flutter_training/data/weather.dart';
import 'package:flutter_training/data/weather_condition.dart';
import 'package:flutter_training/presentation/screen/weather/weather_notifier.dart';
import 'package:flutter_training/repository/weather_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'test_utils.dart';
import 'weather_notifier_test.mocks.dart';

@GenerateNiceMocks([MockSpec<WeatherRepository>()])
void main() {
  final mockWeatherRepository = MockWeatherRepository();
  late ProviderContainer providerContainer;

  const area = 'tokyo';
  final date = DateTime(2024, 6);

  setUp(() {
    reset(mockWeatherRepository);
    providerContainer = createContainer(
      overrides: [
        weatherRepositoryProvider.overrideWithValue(mockWeatherRepository),
      ],
    );
  });

  group('weatherNotifierProviderのテスト群', () {
    group('意図した値が取得できた場合', () {
      test('初めて取得する値が null であること', () {
        // actual
        final actual = providerContainer.read(weatherNotifierProvider);

        // assert
        expect(actual, null);
      });

      test('更新を行った際に正常にレスポンスが返却され意図した Weather が取得できること', () {
        // dummy response
        final resultWeather = Weather(
          weatherCondition: WeatherCondition.sunny,
          maxTemperature: 33,
          minTemperature: 22,
          date: date,
        );

        // stub
        when(mockWeatherRepository.fetchWeather(area: area, date: date))
            .thenReturn(resultWeather);
        providerContainer
            .read(weatherNotifierProvider.notifier)
            .fetchWeather(area: area, date: date);

        // actual
        final actual = providerContainer.read(weatherNotifierProvider);

        // assert
        expect(actual, resultWeather);
      });
    });

    group('Exception が throw された場合', () {
      test('''
        更新を行った際に InvalidParameterException が throw された場合、
        InvalidParameterException が throw され、
        State の値が変更されないこと
        ''', () {
        // dummy response
        final resultWeather = Weather(
          weatherCondition: WeatherCondition.sunny,
          maxTemperature: 33,
          minTemperature: 22,
          date: date,
        );

        // stub for valid response
        when(mockWeatherRepository.fetchWeather(area: area, date: date))
            .thenReturn(resultWeather);
        providerContainer
            .read(weatherNotifierProvider.notifier)
            .fetchWeather(area: area, date: date);

        // assert for state
        expect(
          providerContainer.read(weatherNotifierProvider),
          resultWeather,
        );

        // stub for throw exception
        when(mockWeatherRepository.fetchWeather(area: area, date: date))
            .thenThrow(const InvalidParameterException());

        // expect exception value
        final expectException = throwsA(isA<InvalidParameterException>());

        // assert for exception
        expect(
          () => providerContainer
              .read(weatherNotifierProvider.notifier)
              .fetchWeather(area: area, date: date),
          expectException,
        );

        // assert for state
        expect(
          providerContainer.read(weatherNotifierProvider),
          resultWeather,
        );
      });
    });
  });
}
