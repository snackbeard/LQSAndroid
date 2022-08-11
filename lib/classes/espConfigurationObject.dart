class ControllerConfiguration {
  String ssid = '';
  String password = '';
  String serverIp = '';
  String port = '';
  String controllerName = '';

  String toBtString() {
    return '$ssid?$password?$serverIp?$port?$controllerName';
  }

  bool checkValues() {

    final alphanumeric = RegExp(r'^(([1-9]?\d|1\d\d|2[0-4]\d|25[0-5])(\.(?!$)|(?=$))){4}$');

    if (ssid == '' || ssid == ' ') {
      throw ('WiFi Name darf nicht leer sein!');
    }

    if (password == '' || password == ' ') {
      throw ('Passwort darf nicht leer sein!');
    }

    if (!alphanumeric.hasMatch(serverIp)) {
      throw ('IP hat falsches Format: 255.255.255.255');
    }

    if (port == '' || port == ' ' || port.contains(' ')) {
      throw ('Port darf weder leer sein noch Leerzeichen enthalten!');
    }

    if (controllerName == '' || controllerName == ' ' || controllerName.contains(' ')) {
      throw ('Name darf weder leer sein noch Leerzeichen enthalten!');
    }

    return true;
  }

}