import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg_test/flutter_svg_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_training/data/app_exception.dart';
import 'package:flutter_training/data/date_time_converter.dart';
import 'package:flutter_training/data/weather_condition.dart';
import 'package:flutter_training/infra/yumemi_weather_provider.dart';
import 'package:flutter_training/presentation/screen/weather/weather_screen.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:yumemi_weather/yumemi_weather.dart';

import 'weather_repository_test.mocks.dart';

@GenerateNiceMocks([MockSpec<YumemiWeather>()])
void main() {
  final mockYumemiWeather = MockYumemiWeather();

  tearDown(
    () => reset(mockYumemiWeather),
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
        final resultJson = '''
            {
              "weather_condition": "${condition.name}",
              "max_temperature": 33,
              "min_temperature": 22,
              "date": "${const DateTimeConverter().toJson(DateTime.now())}"
            }
        ''';

        initializedDeviceSize(tester);
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              yumemiWeatherProvider.overrideWithValue(mockYumemiWeather),
            ],
            child: const MaterialApp(
              home: WeatherScreen(),
            ),
          ),
        );

        // stub
        when(mockYumemiWeather.fetchWeather(any)).thenReturn(resultJson);

        // action
        await tester.tap(find.text('Reload'));
        await tester.pumpAndSettle();

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
      initializedDeviceSize(tester);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            yumemiWeatherProvider.overrideWithValue(mockYumemiWeather),
          ],
          child: const MaterialApp(
            home: WeatherScreen(),
          ),
        ),
      );

      // stub
      const exception = InvalidParameterException();
      when(mockYumemiWeather.fetchWeather(any)).thenThrow(exception);

      // action
      await tester.tap(find.text('Reload'));
      await tester.pumpAndSettle();

      // ダイアログ表示
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Error'), findsOneWidget);
      expect(find.text(exception.message), findsOneWidget);
      expect(find.text('OK'), findsOneWidget);

      // ダイアログを閉じる
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // ダイアログ非表示
      expect(find.byType(AlertDialog), findsNothing);
    });
  });
}
