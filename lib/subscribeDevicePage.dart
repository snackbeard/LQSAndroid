import 'package:air_sensor_app/classes/settingsObject.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'classes/controllerSubscription.dart';

class SubscribeDevice extends StatefulWidget {
  const SubscribeDevice({Key? key, required this.personalSettings}) : super(key: key);

  final SettingsObject personalSettings;

  @override
  State<SubscribeDevice> createState() => _SubscribeDeviceState();
}

class _SubscribeDeviceState extends State<SubscribeDevice> {

  String _lastColor = '0xffffffff';

  Future<List<ControllerSubscription>> _startGetControllers(int userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    List<ControllerSubscription> controllers = await fetchControllers(userId);
    return controllers;

  }

  Future<bool> _startSubscribeController(int userId, int controllerId) async {
    bool done = await subscribeController(userId, controllerId);
    return done;
  }

  @override
  void initState() {
    super.initState();
    debugPrint("userID: ${widget.personalSettings.userId}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Geräte verwalten'),
      ),
      body: Center(
        child: FutureBuilder<List<ControllerSubscription>>(
          future: _startGetControllers(widget.personalSettings.userId),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {

                  debugPrint(snapshot.data![index].color);
                  debugPrint(int.parse(snapshot.data![index].color).toString());

                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 6,
                            child: Container(
                              padding: const EdgeInsets.only(top: 20, bottom: 20),
                              margin: const EdgeInsets.only(left: 20),
                              child: Text(
                                snapshot.data![index].controller.name,
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              padding: const EdgeInsets.only(top: 20, bottom: 20),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: snapshot.data![index].isSubscribed ? IconButton(
                                  icon: const Icon(Icons.color_lens),
                                  color: Color(int.parse(snapshot.data![index].color)),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          backgroundColor: const Color(0xff111111),
                                          title: const Text(
                                            'Farbe auswählen!',
                                            style: TextStyle(
                                                color: Color(0xffdddddd)
                                            ),
                                          ),
                                          content: SingleChildScrollView(
                                            child: BlockPicker(
                                              pickerColor: Colors.red,
                                              onColorChanged: (Color color) {
                                                _lastColor = color.value.toRadixString(16);
                                              },
                                            ),
                                          ),
                                          actions: [
                                            ElevatedButton(
                                              child: const Text(
                                                'Bestätigen',
                                                style: TextStyle(
                                                  color: Color(0xffdddddd)
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                changeControllerColor(
                                                  widget.personalSettings.userId,
                                                  snapshot.data![index].controller.objectId,
                                                  _lastColor
                                                );
                                                setState(() {
                                                  _startGetControllers(widget.personalSettings.userId);
                                                });
                                              },
                                            )
                                          ],
                                        );
                                      }
                                    );
                                  },
                                ) : null,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              padding: const EdgeInsets.only(top: 20, bottom: 20),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: snapshot.data![index].isSubscribed ? IconButton(
                                  onPressed: () {
                                    unsubscribeController(widget.personalSettings.userId, snapshot.data![index].controller.objectId);
                                    setState(() {
                                      _startGetControllers(widget.personalSettings.userId);
                                    });
                                  },
                                  icon: const Icon(Icons.check_box_outlined),
                                  color: const Color(0xffdddddd),
                                ) : IconButton(
                                  onPressed: () {
                                    _startSubscribeController(widget.personalSettings.userId, snapshot.data![index].controller.objectId).then((value) {
                                      setState(() {
                                        _startGetControllers(widget.personalSettings.userId);
                                      });
                                    });
                                  },
                                  icon: const Icon(Icons.check_box_outline_blank),
                                  color: const Color(0xffdddddd),
                                )
                              ),
                            )
                          ),
                        ],
                      ),
                      const Divider(
                        height: 2,
                        thickness: 2,
                        color: Color(0xffdddddd),
                        indent: 20,
                        endIndent: 20,
                      ),
                    ],
                  );

                  // return Text(snapshot.data![index].controller.name);
                }
              );
            }
            return const CircularProgressIndicator(
              color: Color(0xff64b5f6),
            );
          }
        )
      ),
    );
  }
}

