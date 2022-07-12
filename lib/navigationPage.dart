import 'package:air_sensor_app/loginPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'classes/settingsObject.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({Key? key}) : super(key: key);

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<SettingsObject> _settings;


  @override
  void initState() {
    super.initState();
    _settings = _prefs.then((SharedPreferences prefs) {
      final SettingsObject settings = SettingsObject();

      // prefs.clear();


      settings.sharedPrefs = prefs;

      if (prefs.getInt('tvocsBackwards') == null) {
        debugPrint("created new Settings");
        // no settings created yet, create new
        settings.setTvocsBackwards(10);
        settings.setEco2Backwards(10);
        settings.setUsername('');
        settings.setPassword('');


      } else {
        debugPrint("load settings");
        // read settings

        settings.getTvocsBackwards();
        settings.getEco2Backwards();
        settings.getUsername();
        settings.getPassword();
      }

      return settings;
    });
    // FlutterNativeSplash.remove();
  }

  /// Used only to retrieve sharedPreferences;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SettingsObject>(
      future: _settings,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _settings.then((value) {
            // debugPrint(value.username);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage(
                title: "Login",
                personalSettings: value
              ))
            );
          });
          return const LinearProgressIndicator();
        } else {
          return const LinearProgressIndicator();
        }
      }
    );
  }
}
