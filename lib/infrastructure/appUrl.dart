class AppUrl {
  static const String baseUrl = 'http://192.168.178.28:8080/api/v1/';

  static String buildUrl(String resourcePath, String? function) {
    var url = baseUrl + resourcePath;

    if (function != null) {
      url += function;
    }

    return url;
  }

}