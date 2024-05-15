import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_training/presentation/common/after_layout_mixin.dart';
import 'package:flutter_training/presentation/screen/weather/weather_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with AfterLayoutMixin {
  @override
  void initState() {
    super.initState();
    unawaited(executeAfterLayout(_transitionToWeatherScreen));
  }

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(color: Colors.green);
  }

  Future<void> _transitionToWeatherScreen() async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) {
          return const WeatherScreen();
        },
      ),
    );
    await executeAfterLayout(_transitionToWeatherScreen);
  }
}
