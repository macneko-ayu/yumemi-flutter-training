import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_training/data/app_exception.dart';
import 'package:flutter_training/data/weather_condition.dart';
import 'package:flutter_training/gen/assets.gen.dart';
import 'package:flutter_training/presentation/screen/weather/weather_notifier.dart';

class WeatherScreen extends ConsumerWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(weatherNotifierProvider, (previous, next) async {
      if (!context.mounted) {
        return;
      }
      await next.when(
        loading: () {
          // ローディング中はインジケータを表示する
          showDialog<void>(
            barrierDismissible: false,
            context: context,
            builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
        error: (error, _) async {
          // インジケータを閉じる
          Navigator.of(context).pop();
          final String message;
          if (error is AppException) {
            message = error.message;
          } else {
            message = error.toString();
          }
          // エラーダイアログを表示する
          await _showErrorDialog(context, message);
        },
        data: (data) async {
          if (data != null) {
            // データが取得できたらインジケータを閉じる
            Navigator.of(context).pop();
          }
        },
      );
    });
    final currentWeather =
        ref.watch(weatherNotifierProvider.select((value) => value.valueOrNull));
    return Scaffold(
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 0.5,
          child: Column(
            children: [
              const Spacer(),
              _WeatherImage(weatherCondition: currentWeather?.weatherCondition),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: _TemperatureText.min(
                        temperature: currentWeather?.minTemperature,
                      ),
                    ),
                    Expanded(
                      child: _TemperatureText.max(
                        temperature: currentWeather?.maxTemperature,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 80,
                    ),
                    _Buttons(
                      closeTapped: () => Navigator.of(context).pop(),
                      reloadTapped: () async => _fetchWeather(context, ref),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _fetchWeather(BuildContext context, WidgetRef ref) async {
    await ref
        .read(weatherNotifierProvider.notifier)
        .fetchWeather(area: 'tokyo', date: DateTime.now());
  }

  Future<void> _showErrorDialog(BuildContext context, String message) async {
    if (!context.mounted) {
      return;
    }
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class _WeatherImage extends StatelessWidget {
  const _WeatherImage({required WeatherCondition? weatherCondition})
      : _weatherCondition = weatherCondition;

  final WeatherCondition? _weatherCondition;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: _weatherCondition == null
          ? const Placeholder()
          : _convertImage(weatherCondition: _weatherCondition),
    );
  }

  SvgPicture _convertImage({required WeatherCondition weatherCondition}) {
    return switch (weatherCondition) {
      WeatherCondition.sunny => Assets.sunny.svg(),
      WeatherCondition.cloudy => Assets.cloudy.svg(),
      WeatherCondition.rainy => Assets.rainy.svg(),
    };
  }
}

class _TemperatureText extends StatelessWidget {
  const _TemperatureText.max({
    required int? temperature,
  })  : _temperature = temperature,
        _color = Colors.red;

  const _TemperatureText.min({
    required int? temperature,
  })  : _temperature = temperature,
        _color = Colors.blue;

  final int? _temperature;
  final Color _color;

  @override
  Widget build(BuildContext context) {
    return Text(
      '${_temperature?.toString() ?? '**'} ℃',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(color: _color),
    );
  }
}

class _Buttons extends StatelessWidget {
  const _Buttons({
    required VoidCallback closeTapped,
    required VoidCallback reloadTapped,
  })  : _closeTapped = closeTapped,
        _reloadTapped = reloadTapped;

  final VoidCallback _closeTapped;
  final VoidCallback _reloadTapped;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        TextButton(
          onPressed: _closeTapped,
          child: const Text('Close'),
        ),
        TextButton(
          onPressed: _reloadTapped,
          child: const Text('Reload'),
        ),
      ],
    );
  }
}
