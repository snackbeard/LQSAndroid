class AppUrl {
  static const String baseUrl = 'http://192.168.178.28:8080/api/v1/';
  // static const String baseUrl = 'http://192.168.178.99:8080/api/v1/';

  // post
  static const String userRegistration = 'user';
  // post
  static const String userLogin = 'user.login';
  // get
  static const String getAllControllers = 'controller';

  static const String userPath = 'user';


  static String buildUrl(String resourcePath, String? function) {
    var url = baseUrl + resourcePath;

    if (function != null) {
      url += function;
    }

    return url;
  }

}