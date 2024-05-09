import 'package:flutter/material.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 0.5,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Placeholder(
                child: AspectRatio(aspectRatio: 1),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  children: [
                    _TemperatureText(
                      text: '** ℃',
                      color: Colors.blue,
                    ),
                    _TemperatureText(
                      text: '** ℃',
                      color: Colors.red,
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
}

class _TemperatureText extends StatelessWidget {
  const _TemperatureText({
    required String text,
    required Color color,
  })  : _text = text,
        _color = color;

  final String _text;
  final Color _color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        _text,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(color: _color),
      ),
    );
  }
}
