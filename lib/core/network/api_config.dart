abstract class ApiConfig {
  String get baseUrl;
  Duration get connectTimeout;
  Duration get receiveTimeout;
  Map<String, String> get defaultHeaders;
}

class DefaultApiConfig implements ApiConfig {
  @override
  String get baseUrl => "";

  @override
  Duration get connectTimeout => Duration(seconds: 180);

  @override
  Duration get receiveTimeout => Duration(seconds: 180);

  @override
  Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
  };
}
