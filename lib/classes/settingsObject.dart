import 'package:shared_preferences/shared_preferences.dart';

class SettingsObject {

  int? tvocsBackwards = 96;
  int? eco2Backwards = 96;

  String? username = "-";
  String? password = "-";

  late SharedPreferences sharedPrefs;

  getUsername() {
    username = sharedPrefs.getString('username');
  }

  setUsername(String value) {
    sharedPrefs.setString('username', value);
    username = value;
  }

  getPassword() {
    password = sharedPrefs.getString('password');
  }

  setPassword(String value) {
    sharedPrefs.setString('password', value);
    password = value;
  }

  setTvocsBackwardsSelf() {
    sharedPrefs.setInt('tvocsBackwards', tvocsBackwards!);
  }

  setEco2BackwardsSelf() {
    sharedPrefs.setInt('eco2Backwards', eco2Backwards!);
  }

  getTvocsBackwards() {
    tvocsBackwards = sharedPrefs.getInt('tvocsBackwards');
  }

  setTvocsBackwards(int value) {
    sharedPrefs.setInt('tvocsBackwards', value);
    tvocsBackwards = value;
  }

  getEco2Backwards() {
    eco2Backwards = sharedPrefs.getInt('eco2Backwards');
  }

  setEco2Backwards(int value) {
    sharedPrefs.setInt('eco2Backwards', value);
    eco2Backwards = value;
  }

}