import 'package:air_sensor_app/classes/user.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'classes/settingsObject.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  late String _username;
  late String _password;
  late bool _hasCredentials;
  SettingsObject _personalSettings = SettingsObject();

  void _login(String username, String password) {
    debugPrint("logging in");

    User user = User(userId: 0, name: username, password: password);

    login(user).then((result) => {
      debugPrint("logged in user: ${result.userId}")
    });
  }

  Future<SettingsObject> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final SettingsObject settings = SettingsObject();

    settings.sharedPrefs = prefs;

    if (prefs.getInt('tvocsBackwards') == null) {
      debugPrint("created new Settings");
      // no settings created yet, create new
      settings.setTvocsBackwards(10);
      settings.setEco2Backwards(10);
      settings.setUsername('-');
      settings.setPassword('-');


    } else {
      debugPrint("load settings");
      // read settings

      settings.getTvocsBackwards();
      settings.getEco2Backwards();
      settings.getUsername();
      settings.getPassword();
    }

    prefs.clear();

    return settings;

  }

  @override
  void initState() {
    super.initState();
    _loadPrefs().then((value) {
      _personalSettings = value;

      if (!(_personalSettings.username == '-')) {
        _login(_personalSettings.username!, _personalSettings.password!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                onChanged: (String text) {
                  _username = text;
                },
                style: const TextStyle(
                  color: Color(0xffdddddd),
                  fontSize: 20
                ),
                decoration: const InputDecoration(
                  hintStyle: TextStyle(
                    color: Color(0xffdddddd),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xffdddddd))
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff64b5f6))
                  ),
                  hintText: 'Benutzername',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                onChanged: (String text) {
                  _password = text;
                },
                cursorColor: Color(0xffdddddd),
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                style: const TextStyle(
                    color: Color(0xffdddddd),
                    fontSize: 20
                ),
                decoration: const InputDecoration(
                  hintStyle: TextStyle(
                    color: Color(0xffdddddd),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffdddddd))
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff64b5f6))
                  ),
                  hintText: 'Passwort',
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  _login(_username, _password);
                },
                child: const Text('Login'),
            ),
          ],
        )
      ),
    );
  }
}
// https://avioli.github.io/blog/post/catching-failing-futures-in-dart.html
