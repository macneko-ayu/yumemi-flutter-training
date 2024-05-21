import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_training/data/app_exception.dart';
import 'package:flutter_training/data/weather_condition.dart';
import 'package:flutter_training/data/weather_info.dart';
import 'package:flutter_training/gen/assets.gen.dart';
import 'package:flutter_training/repository/weather_repository.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherRepository _repository = WeatherRepository();
  WeatherInfo? _info;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 0.5,
          child: Column(
            children: [
              const Spacer(),
              _WeatherImage(_info?.weatherCondition),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: _TemperatureText.min(
                        text: '** ℃',
                      ),
                    ),
                    Expanded(
                      child: _TemperatureText.max(
                        text: '** ℃',
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
      final info = _repository.fetchWeather('tokyo', DateTime.now());
      // TODO: レスポンスが変換できているか確認するための仮処理
      if (kDebugMode) {
        debugPrint(info.maxTemperature.toString());
      }
      setState(() {
        _info = info;
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
    required String text,
  })  : _text = text,
        _color = Colors.red;

  const _TemperatureText.min({
    required String text,
  })  : _text = text,
        _color = Colors.blue;

  final String _text;
  final Color _color;

  @override
  Widget build(BuildContext context) {
    return Text(
      _text,
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
