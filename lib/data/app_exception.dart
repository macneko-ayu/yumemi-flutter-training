sealed class AppException implements Exception {
  const AppException({required this.message});

  final String message;
}

class ResponseFormatException extends AppException {
  const ResponseFormatException()
      : super(message: '想定していないレスポンスを取得しました。時間を置いて再度お試しください。');
}

sealed class WeatherAPIException extends AppException {
  const WeatherAPIException({required super.message});
}

class InvalidParameterException extends WeatherAPIException {
  const InvalidParameterException()
      : super(message: '入力された値に誤りがあります。入力内容をご確認ください。');
}

class UnknownException extends WeatherAPIException {
  const UnknownException() : super(message: '天気情報の取得に失敗しました。時間を置いて再度お試しください。');
}
