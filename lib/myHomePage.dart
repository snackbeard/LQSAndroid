import 'dart:async';

import 'package:air_sensor_app/classes/controllerSingleData.dart';
import 'package:air_sensor_app/classes/settingsObject.dart';
import 'package:air_sensor_app/diagramPage.dart';
import 'package:air_sensor_app/settingsPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'addDevicePage.dart';
import 'loginPage.dart';
import 'classes/qualityObject.dart';

class HomePage extends StatefulWidget {

  const HomePage({Key? key, required this.title, required this.personalSettings}) : super(key: key);

  final String title;
  final SettingsObject personalSettings;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  static const String _verwalten = "Geräte verwalten";
  static const String _home = "Home";
  static const String _settings = "Einstellungen";

  static const String _eco2 = "eCO2";
  static const String _tvocs = "TVOCs";

  bool show = false;

  // List<QualityObject> dataTvoc = <QualityObject>[];
  // List<QualityObject> dataEco2 = <QualityObject>[];
  List<ControllerSingleData> dataTvoc = <ControllerSingleData>[];
  List<ControllerSingleData> dataEco2 = <ControllerSingleData>[];

  void _updateData() {

    debugPrint("updating data");
    fetchDataTvoc(
      widget.personalSettings.userId,
      widget.personalSettings.tvocsBackwards!).then((result) {
        debugPrint(result.length.toString());
        setState(() {
          dataTvoc = result;
        });
    });

    fetchDataEco2(
        widget.personalSettings.userId,
        widget.personalSettings.eco2Backwards!).then((result) {
          debugPrint(result.length.toString());
          setState(() {
            dataEco2 = result;
          });
    });
  }

  @override
  void initState() {
    super.initState();
    _updateData();
    FlutterNativeSplash.remove();
    debugPrint("userID: ${widget.personalSettings.userId}");
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            return DefaultTabController(
              length: 2,
              child: Scaffold(
                appBar: AppBar(
                  title: Text(widget.title),
                  bottom: const TabBar(
                    tabs: [
                      Tab(
                        text: _eco2,
                      ),
                      Tab(
                        text: _tvocs,
                      )
                    ],
                  ),
                ),
                drawer: Drawer(
                  child: ListView(
                    children: [
                      ListTile(
                        title: const Text(
                          _home,
                          style: TextStyle(
                            fontSize: 20
                          ),
                        ),
                        leading: const Icon(
                          Icons.home,
                          color: Color(0xffdddddd),
                        ),
                        onTap: () {
                          Navigator.pop(context);
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
                          _verwalten,
                          style: TextStyle(
                              fontSize: 20
                          ),
                        ),
                        leading: const Icon(
                          Icons.add,
                          color: Color(0xffdddddd),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>
                                  AddDevice(personalSettings: widget.personalSettings))
                          ).whenComplete(() => {
                            _updateData()
                          });
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
                          _settings,
                          style: TextStyle(
                              fontSize: 20
                          ),
                        ),
                        leading: const Icon(
                          Icons.settings,
                          color: Color(0xffdddddd),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SettingsPage(settingsObject: widget.personalSettings))
                          ).whenComplete(() => {
                            _updateData()
                          });
                        },
                      )
                    ],
                  ),
                ),
                body: TabBarView(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      child: DiagramPage(
                        diagramTitle: "eCO2",
                        diagramData: dataEco2,
                        dataLabelVisibleLength: 15,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      child: DiagramPage(
                        diagramTitle: "TVOCs",
                        diagramData: dataTvoc,
                        dataLabelVisibleLength: 15,
                      ),
                    )
                  ],
                ),
              ),
            );
          } else {
            return DefaultTabController(
              length: 2,
              child: Scaffold(
                appBar: AppBar(
                  toolbarHeight: 0.0,
                  bottom: const PreferredSize(
                    preferredSize: Size(0.0, 0.0),
                    child: SizedBox(
                      width: 0.0,
                      child: TabBar(
                        tabs: [
                          Tab(
                            text: _eco2,
                          ),
                          Tab(
                            text: _tvocs,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                body: TabBarView(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      child: DiagramPage(
                        diagramTitle: "eCO2",
                        diagramData: dataEco2,
                        dataLabelVisibleLength: 30,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      child: DiagramPage(
                        diagramTitle: "TVOCs",
                        diagramData: dataTvoc,
                        dataLabelVisibleLength: 30,
                      ),
                    )
                  ],
                ),
              )
            );
          }
        }
    );
  }
}
