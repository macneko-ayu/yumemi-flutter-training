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

  String area;
  String date;
}
