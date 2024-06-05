import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_training/data/app_exception.dart';
import 'package:flutter_training/data/weather.dart';
import 'package:flutter_training/data/weather_condition.dart';
import 'package:flutter_training/gen/assets.gen.dart';
import 'package:flutter_training/repository/weather_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/weather_screen.g.dart';

@riverpod
class WeatherNotifier extends _$WeatherNotifier {
  @override
  Weather? build() => null;

  void fetchWeather(String area, DateTime date) {
    final weather =
        ref.read(weatherRepositoryProvider).fetchWeather(area, date);
    state = weather;
  }
}

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherRepository _repository = WeatherRepository();
  Weather? _currentWeather;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 0.5,
          child: Column(
            children: [
              const Spacer(),
              _WeatherImage(_currentWeather?.weatherCondition),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: _TemperatureText.min(
                        temperature: _currentWeather?.minTemperature,
                      ),
                    ),
                    Expanded(
                      child: _TemperatureText.max(
                        temperature: _currentWeather?.maxTemperature,
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
                    _Buttons(reloadTapped: _fetchWeather),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _fetchWeather() async {
    try {
      final weather = _repository.fetchWeather('tokyo', DateTime.now());
      setState(() {
        _currentWeather = weather;
      });
    } on AppException catch (e) {
      await _showErrorDialog(e.message);
    }
  }

  Future<void> _showErrorDialog(String message) async {
    if (!mounted) {
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
  const _WeatherImage(WeatherCondition? weatherCondition)
      : _weatherCondition = weatherCondition;

  final WeatherCondition? _weatherCondition;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: _weatherCondition == null
          ? const Placeholder()
          : _convertImage(_weatherCondition),
    );
  }

  SvgPicture _convertImage(WeatherCondition weatherCondition) {
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
  const _Buttons({required VoidCallback reloadTapped})
      : _reloadTapped = reloadTapped;

  final VoidCallback _reloadTapped;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
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
