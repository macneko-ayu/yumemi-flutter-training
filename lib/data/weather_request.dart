class WeatherRequest {
  WeatherRequest({
    required this.area,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'area': area,
      'date': date,
    };
  }

  final String area;
  final String date;
}
