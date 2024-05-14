import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_training/data/weather_condition.dart';
import 'package:flutter_training/gen/assets.gen.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 0.5,
          child: Column(
            children: [
              Spacer(),
              AspectRatio(
                aspectRatio: 1,
                child: Placeholder(),
              ),
              Padding(
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
                    SizedBox(
                      height: 80,
                    ),
                    _Buttons(),
                  ],
                ),
              ),
            ],
          ),
        ),
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
      : _convert(_weatherCondition),
    );
  }

  SvgPicture _convert(WeatherCondition weatherCondition) {
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
  const _Buttons();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        TextButton(
          onPressed: () {},
          child: const Text('Close'),
        ),
        TextButton(
          onPressed: () {},
          child: const Text('Reload'),
        ),
      ],
    );
  }
}
