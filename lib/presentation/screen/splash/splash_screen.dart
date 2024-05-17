import 'package:flutter/material.dart';
import 'package:flutter_training/presentation/screen/weather/weather_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future(() async {
      await WidgetsBinding.instance.endOfFrame.then((_) {
        Future.delayed(
          const Duration(milliseconds: 500),
          _transitionToWeatherScreen,
        );
      });
    });
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
  }
}
