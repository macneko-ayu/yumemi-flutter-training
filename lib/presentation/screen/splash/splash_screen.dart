import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_training/presentation/common/after_layout_mixin.dart';
import 'package:flutter_training/presentation/screen/weather/weather_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with AfterLayoutMixin {
  @override
  Widget build(BuildContext context) {
    return const ColoredBox(color: Colors.green);
  }

  @override
  void didAfterLayout() {
    unawaited(_transitionToWeatherScreen());
  }

  Future<void> _transitionToWeatherScreen() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (!mounted) {
      return;
    }
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) {
          return const WeatherScreen();
        },
      ),
    );
    await _transitionToWeatherScreen();
  }
}
