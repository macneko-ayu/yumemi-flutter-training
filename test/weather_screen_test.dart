import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg_test/flutter_svg_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_training/data/app_exception.dart';
import 'package:flutter_training/data/weather.dart';
import 'package:flutter_training/data/weather_condition.dart';
import 'package:flutter_training/presentation/screen/weather/weather_screen.dart';
import 'package:flutter_training/repository/weather_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'weather_screen_test.mocks.dart';

@GenerateNiceMocks([MockSpec<WeatherRepository>()])
void main() {
  final mockWeatherRepository = MockWeatherRepository();

  tearDown(
    () => reset(mockWeatherRepository),
  );

  // 端末サイズを指定しないとレンダリングエラーが発生するため、iPhoneSE3相当のサイズに変更する
  void initializedDeviceSize(WidgetTester tester) {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(750, 1334);
  }

  group('天気予報画面の画像表示と気温表示のテスト群', () {
    testWidgets('天気予報画面で天気情報が未取得の場合は、天気情報が Placeholder、気温が ** ℃ と表示されること',
        (tester) async {
      initializedDeviceSize(tester);

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: WeatherScreen(),
          ),
        ),
      );

      expect(find.byType(Placeholder), findsOneWidget);
      expect(find.text('** ℃'), findsNWidgets(2));
    });

    final cases = [
      (WeatherCondition.sunny, 'assets/sunny.svg'),
      (WeatherCondition.cloudy, 'assets/cloudy.svg'),
      (WeatherCondition.rainy, 'assets/rainy.svg'),
    ];

    for (final (condition, svg) in cases) {
      testWidgets('''
                  $condition のときは、$svg が表示され、
                  最高気温が 33 ℃、最低気温が 22 ℃ と表示されること''', (tester) async {
        // dummy response
        final resultWeather = Weather(
          weatherCondition: condition,
          maxTemperature: 33,
          minTemperature: 22,
          date: DateTime.now(),
        );

        // Completerで非同期処理を模倣する
        final completer = Completer<Weather>();

        initializedDeviceSize(tester);
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              weatherRepositoryProvider
                  .overrideWithValue(mockWeatherRepository),
            ],
            child: const MaterialApp(
              home: WeatherScreen(),
            ),
          ),
        );

        // stub
        when(
          mockWeatherRepository.fetchWeather(
            area: anyNamed('area'),
            date: anyNamed('date'),
          ),
        ).thenAnswer((_) async => completer.future);

        // Reload タップ前はインジケータは非表示
        expect(find.byType(CircularProgressIndicator), findsNothing);

        // action
        await tester.tap(find.text('Reload'));
        await tester.pump();

        // expect: Reload タップ後はインジケータは表示
        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        // データ取得を完了させる
        completer.complete(resultWeather);
        await tester.pump();

        // expect: データ取得後はインジケータは非表示
        expect(find.byType(CircularProgressIndicator), findsNothing);

        // expect: 期待する値が表示される
        expect(find.svgAssetWithPath(svg), findsOneWidget);
        expect(find.text('33 ℃'), findsOneWidget);
        expect(find.text('22 ℃'), findsOneWidget);
      });
    }
  });

  group('ダイアログ表示のテスト群', () {
    testWidgets('''
                InvalidParameterException が throw されたときにダイアログが表示され、
                ${const InvalidParameterException().message} が表示されること
                ''', (tester) async {
      // Completerで非同期処理を模倣する
      final completer = Completer<Weather>();

      initializedDeviceSize(tester);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            weatherRepositoryProvider.overrideWithValue(mockWeatherRepository),
          ],
          child: const MaterialApp(
            home: WeatherScreen(),
          ),
        ),
      );

      // stub
      when(
        mockWeatherRepository.fetchWeather(
          area: anyNamed('area'),
          date: anyNamed('date'),
        ),
      ).thenAnswer((_) async => completer.future);

      // action
      await tester.tap(find.text('Reload'));
      await tester.pump();

      // expect: Reload タップ後はインジケータは表示
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // データ取得時にエラーを発生させる
      const exception = InvalidParameterException();
      completer.completeError(exception);
      await tester.pump();

      // expect: エラー発生時はインジケータは非表示
      expect(find.byType(CircularProgressIndicator), findsNothing);

      // ダイアログ表示
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Error'), findsOneWidget);
      expect(find.text(exception.message), findsOneWidget);
      expect(find.text('OK'), findsOneWidget);

      // ダイアログを閉じる
      await tester.tap(find.text('OK'));
      await tester.pump();

      // ダイアログ非表示
      expect(find.byType(AlertDialog), findsNothing);
    });
  });
}
