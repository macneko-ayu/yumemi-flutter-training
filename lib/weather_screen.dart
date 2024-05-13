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

class _TemperatureText extends StatelessWidget {
  // const _TemperatureText({
  //   required String text,
  //   required Color color,
  // })  : _text = text,
  //       _color = color;

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
