enum WeatherCondition {
  sunny,
  cloudy,
  rainy;

  factory WeatherCondition.from(String name) {
    return values.singleWhere(
      (element) => element.name == name,
      orElse: () => throw Exception('$name is unexpected value.'),
    );
  }
}
