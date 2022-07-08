import 'package:air_sensor_app/classes/settingsObject.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:numberpicker/numberpicker.dart';

class DiagramSettingsPage extends StatefulWidget {
  const DiagramSettingsPage({Key? key, required this.settingsObject}) : super(key: key);

  final SettingsObject settingsObject;

  @override
  State<DiagramSettingsPage> createState() => _DiagramSettingsPageState();
}

class _DiagramSettingsPageState extends State<DiagramSettingsPage> {

  final String _texteco2 = 'Anzahl alter eCO2 Werte:';
  final String _texttvoc = 'Anzahl alter TVOC Werte:';
  final String _textcolorpicker = 'Farbe für Graphen auswählen:';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diagrammeinstellungen'),
      ),
      body: Center(
        child: ListView(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 8,
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    margin: const EdgeInsets.only(left: 20),
                    child: Text(
                      _texteco2,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: NumberPicker(
                    value: widget.settingsObject.eco2Backwards!,
                    minValue: 1,
                    maxValue: 95,
                    step: 1,
                    haptics: true,
                    onChanged: (int value) => {
                      setState(() => {
                        widget.settingsObject.eco2Backwards = value
                      })
                    },
                  )
                )
              ],
            ),
            const Divider(
              height: 2,
              thickness: 2,
              color: Color(0xffdddddd),
              indent: 20,
              endIndent: 20,
            ),
            Row(
              children: [
                Expanded(
                  flex: 8,
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    margin: const EdgeInsets.only(left: 20),
                    child: Text(
                      _texttvoc,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                Expanded(
                    flex: 2,
                    child: NumberPicker(
                      value: widget.settingsObject.tvocsBackwards!,
                      minValue: 1,
                      maxValue: 95,
                      step: 1,
                      haptics: true,
                      onChanged: (int value) => {
                        setState(() => {
                          widget.settingsObject.tvocsBackwards = value
                        })
                      },
                    )
                )
              ],
            ),
            const Divider(
              height: 2,
              thickness: 2,
              color: Color(0xffdddddd),
              indent: 20,
              endIndent: 20,
            ),
            Row(
              children: [
                Expanded(
                  flex: 8,
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    margin: const EdgeInsets.only(left: 20),
                    child: Text(
                      _textcolorpicker,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                const Expanded(
                    flex: 2,
                    child: Text("Placeholder")
                )
              ],
            ),
            const Divider(
              height: 2,
              thickness: 2,
              color: Color(0xffdddddd),
              indent: 20,
              endIndent: 20,
            )
          ],
        ),
      ),
    );
  }
}
