import 'package:air_sensor_app/loginPage.dart';
import 'package:air_sensor_app/myHomePage.dart';
import 'package:air_sensor_app/navigationPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Luftqualität',
      theme: ThemeData(
        textTheme: const TextTheme(
          bodyText1: TextStyle(),
          bodyText2: TextStyle()
        ).apply(
          bodyColor: const Color(0xffdddddd),
          displayColor: const Color(0xffdddddd),
        ),
        listTileTheme: const ListTileThemeData(
          textColor: Color(0xffdddddd)
        ),
        scaffoldBackgroundColor: const Color(0xff111111),
        drawerTheme: const DrawerThemeData(
          backgroundColor: Color(0xff0a0a0a),
        ),
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          error: Colors.redAccent,
          onError: Colors.redAccent,
          primary: Color(0xff0a0a0a),
          onPrimary: Color(0xffdddddd),
          secondary: Color(0xff000000),
          onSecondary: Color(0xffdddddd),
          background: Color(0xff000000),
          onBackground: Color(0xff000000),
          surface: Color(0xff0a0a0a),
          onSurface: Color(0xffdddddd)
        )

      ),
      home: const NavigationPage(),
    );

  }

}

// TODO: sobald app minimiert wird soll nichts mehr im hintergrund passieren,
// TODO: da der Timer sonst immer weiterläuft und updates holt --> akku