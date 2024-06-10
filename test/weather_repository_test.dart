import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_training/data/app_exception.dart';
import 'package:flutter_training/data/weather.dart';
import 'package:flutter_training/data/weather_condition.dart';
import 'package:flutter_training/infra/yumemi_weather_provider.dart';
import 'package:flutter_training/repository/weather_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:yumemi_weather/yumemi_weather.dart';

import 'weather_repository_test.mocks.dart';

@GenerateNiceMocks([MockSpec<YumemiWeather>()])
void main() {
  final mockYumemiWeather = MockYumemiWeather();
  final providerContainer = ProviderContainer(
    overrides: [
      yumemiWeatherProvider.overrideWithValue(mockYumemiWeather),
    ],
  );

  const area = 'tokyo';
  final date = DateTime(2024, 6);

  setUp(() {
    reset(mockYumemiWeather);
  });

  group('レスポンスに関するテスト群', () {
    group('正常なレスポンスが返却された場合', () {
      test('適切な Weather かつ WeatherCondition.sunny に変換されること', () {
        // dummy response
        const resultJson = '''
            {
              "weather_condition": "sunny",
              "max_temperature": 33,
              "min_temperature": 11,
              "date": "2024-06-01T00:00:00+09:00"
            }
          ''';

        // stub
        when(mockYumemiWeather.fetchWeather(any)).thenReturn(resultJson);

        // actual
        final actual = providerContainer
            .read(weatherRepositoryProvider)
            .fetchWeather(area: area, date: date);

        // expect value
        final expectWeather = Weather(
          weatherCondition: WeatherCondition.sunny,
          maxTemperature: 33,
          minTemperature: 11,
          date: date,
        );

        // assert
        verify(mockYumemiWeather.fetchWeather(any)).called(1);
        expect(actual, expectWeather);
      });
      test('適切な Weather かつ WeatherCondition.cloudy に変換されること', () {
        // dummy response
        const resultJson = '''
            {
              "weather_condition": "cloudy",
              "max_temperature": 33,
              "min_temperature": 11,
              "date": "2024-06-01T00:00:00+09:00"
            }
          ''';

        // stub
        when(mockYumemiWeather.fetchWeather(any)).thenReturn(resultJson);

        // actual
        final actual = providerContainer
            .read(weatherRepositoryProvider)
            .fetchWeather(area: area, date: date);

        // expect value
        final expectWeather = Weather(
          weatherCondition: WeatherCondition.cloudy,
          maxTemperature: 33,
          minTemperature: 11,
          date: date,
        );

        // assert
        verify(mockYumemiWeather.fetchWeather(any)).called(1);
        expect(actual, expectWeather);
      });
      test('適切な Weather かつ WeatherCondition.rainy に変換されること', () {
        // dummy response
        const resultJson = '''
            {
              "weather_condition": "rainy",
              "max_temperature": 33,
              "min_temperature": 11,
              "date": "2024-06-01T00:00:00+09:00"
            }
          ''';

        // stub
        when(mockYumemiWeather.fetchWeather(any)).thenReturn(resultJson);

        // actual
        final actual = providerContainer
            .read(weatherRepositoryProvider)
            .fetchWeather(area: area, date: date);

        // expect value
        final expectWeather = Weather(
          weatherCondition: WeatherCondition.rainy,
          maxTemperature: 33,
          minTemperature: 11,
          date: date,
        );

        // assert
        verify(mockYumemiWeather.fetchWeather(any)).called(1);
        expect(actual, expectWeather);
      });
    });

    group('想定しないレスポンスが返却された場合', () {
      test(
          'WeatherCondition で定義されていない天気が返却された場合、ResponseFormatException が発生すること',
          () {
        // dummy response
        const resultJson = '''
            {
              "weather_condition": "dummy",
              "max_temperature": 33,
              "min_temperature": 11,
              "date": "2024-06-01T00:00:00+09:00"
            }
          ''';

        // stub
        when(mockYumemiWeather.fetchWeather(any)).thenReturn(resultJson);

        // expect value
        final expectException = throwsA(isA<ResponseFormatException>());

        // assert
        expect(
          () => providerContainer
              .read(weatherRepositoryProvider)
              .fetchWeather(area: area, date: date),
          expectException,
        );
      });

      test('返却された気温が num 型ではなかった場合、ResponseFormatException が発生すること', () {
        // dummy response
        const resultJson = '''
            {
              "weather_condition": "sunny",
              "max_temperature": "33",
              "min_temperature": 11,
              "date": "2024-06-01T00:00:00+09:00"
            }
          ''';

        // stub
        when(mockYumemiWeather.fetchWeather(any)).thenReturn(resultJson);

        // expect value
        final expectException = throwsA(isA<ResponseFormatException>());

        // assert
        expect(
          () => providerContainer
              .read(weatherRepositoryProvider)
              .fetchWeather(area: area, date: date),
          expectException,
        );
      });

      test('返却された日付形式が想定した形式ではなかった場合、ResponseFormatException が発生すること', () {
        // dummy response
        const resultJson = '''
            {
              "weather_condition": "sunny",
              "max_temperature": 33,
              "min_temperature": 11,
              "date": "2024/06/01"
            }
          ''';

        // stub
        when(mockYumemiWeather.fetchWeather(any)).thenReturn(resultJson);

        // expect value
        final expectException = throwsA(isA<ResponseFormatException>());

        // assert
        expect(
          () => providerContainer
              .read(weatherRepositoryProvider)
              .fetchWeather(area: area, date: date),
          expectException,
        );
      });
    });

    group('API から YumemiWeatherError が Throw された場合', () {
      test('''
        YumemiWeatherError.invalidParameter が Throw された場合、
        InvalidParameterException が発生すること
        ''', () {
        // stub
        when(mockYumemiWeather.fetchWeather(any))
            .thenThrow(YumemiWeatherError.invalidParameter);

        // expect value
        final expectException = throwsA(isA<InvalidParameterException>());

        // assert
        expect(
          () => providerContainer
              .read(weatherRepositoryProvider)
              .fetchWeather(area: area, date: date),
          expectException,
        );
      });

      test('''
        YumemiWeatherError.unknown が Throw された場合、
        InvalidParameterException が発生すること
        ''', () {
        // stub
        when(mockYumemiWeather.fetchWeather(any))
            .thenThrow(YumemiWeatherError.unknown);

        // expect value
        final expectException = throwsA(isA<UnknownException>());

        // assert
        expect(
          () => providerContainer
              .read(weatherRepositoryProvider)
              .fetchWeather(area: area, date: date),
          expectException,
        );
      });
    });
  });
}
