import 'package:shared_preferences/shared_preferences.dart';

class SettingsObject {

  int? tvocsBackwards = 96;
  int? eco2Backwards = 96;

  late SharedPreferences sharedPrefs;

  setTvocsBackwardsSelf() {
    sharedPrefs.setInt('tvocsBackwards', tvocsBackwards!);
  }

  setEco2BackwardsSelf() {
    sharedPrefs.setInt('eco2Backwards', eco2Backwards!);
  }

  setTvocsBackwards(int value) {
    sharedPrefs.setInt('tvocsBackwards', value);
    tvocsBackwards = value;
  }

  setEco2Backwards(int value) {
    sharedPrefs.setInt('eco2Backwards', value);
    eco2Backwards = value;
  }

}