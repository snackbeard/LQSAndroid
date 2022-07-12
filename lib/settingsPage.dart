import 'package:air_sensor_app/classes/settingsObject.dart';
import 'package:air_sensor_app/diagramSettingsPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key, required this.settingsObject}) : super(key: key);

  final SettingsObject settingsObject;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  final String _kontoeinstellungen = "Kontoeinstellungen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diagrammeinstellungen'),
      ),
      body: Center(
        child: ListView(
          children: [
            ListTile(
              title: const Text(
                "Kontoeinstellungen",
                style: TextStyle(
                    fontSize: 20
                ),
              ),
              onTap: () {
                debugPrint("tapped Kontoeinstellungen");
              },
            ),
            const Divider(
              height: 2,
              thickness: 2,
              color: Color(0xffdddddd),
              indent: 20,
              endIndent: 20,
            ),
            ListTile(
              title: const Text(
                "Diagrammeinstellungen",
                style: TextStyle(
                    fontSize: 20
                ),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DiagramSettingsPage(
                        settingsObject: widget.settingsObject))
                ).whenComplete(() => {
                  widget.settingsObject.setEco2BackwardsSelf(),
                  widget.settingsObject.setTvocsBackwardsSelf()
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

// TODO: https://medium.flutterdevs.com/number-picker-in-flutter-7d6c8aa1d6ab#:~:text=The%20Numberpicker%20is%20a%20kind,both%20integer%20and%20decimal%20numbers.
