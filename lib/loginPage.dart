import 'package:air_sensor_app/classes/user.dart';
import 'package:air_sensor_app/myHomePage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'classes/settingsObject.dart';
import 'classes/user.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.title, required this.personalSettings}) : super(key: key);

  final String title;
  final SettingsObject personalSettings;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  late Future<User> _future;

  void _startLogin() {
    _future = login(
      User(
        userId: 0,
        name: widget.personalSettings.username != null ? widget.personalSettings.username! : '',
        password: widget.personalSettings.password != null ? widget.personalSettings.password! : ''
      )
    );
  }

  void _startLoginState() {
    setState(() {
      _future = login(
        User(
          userId: 0,
          name: widget.personalSettings.username != null ? widget.personalSettings.username! : '',
          password: widget.personalSettings.password != null ? widget.personalSettings.password! : ''
        )
      );
    });
  }

  void _startRegisterState() {
    setState(() {
      _future = register(
        User(
          userId: 0,
            name: widget.personalSettings.username != null ? widget.personalSettings.username! : '',
            password: widget.personalSettings.password != null ? widget.personalSettings.password! : ''
        )
      );
    });
  }

  void _removeSplashScreen() async {
    await Future.delayed(const Duration(seconds: 2));
    FlutterNativeSplash.remove();
  }

  @override
  void initState() {
    super.initState();
    _startLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<User>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage(
                    title: 'Luftqualität',
                    personalSettings: widget.personalSettings)
                  )
                );
              });
            } else {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context)
                    .hideCurrentSnackBar();

                _removeSplashScreen();

                if (snapshot.error != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: const Color(0xff64b5f6),
                      content: Text('${snapshot.error}'),
                    ),
                  );
                }
              });

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextField(
                      controller: TextEditingController(
                          text: widget.personalSettings.username
                      ),
                      onChanged: (String text) {
                        widget.personalSettings.setUsername(text);
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
                      controller: TextEditingController(
                          text: widget.personalSettings.password
                      ),
                      onChanged: (String text) {
                        widget.personalSettings.setPassword(text);
                      },
                      cursorColor: const Color(0xffdddddd),
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
                  Center(
                    child: Row(
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              _startLoginState();
                            },
                            child: const Text('Login')
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _startRegisterState();
                          },
                          child: const Text('Registrieren'),
                        )
                      ],
                    ),
                  )
                ],
              );
            }
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xff64b5f6),
              ),
            );
          }
        ),
      ),
    );
  }
}
// https://avioli.github.io/blog/post/catching-failing-futures-in-dart.html
// https://stackoverflow.com/questions/53334608/show-user-friendly-error-page-instead-of-exception-in-flutter
