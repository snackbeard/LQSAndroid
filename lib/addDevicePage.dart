import 'package:air_sensor_app/classes/settingsObject.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import 'classes/controllerSubscription.dart';

class AddDevice extends StatefulWidget {
  const AddDevice({Key? key, required this.personalSettings}) : super(key: key);

  final SettingsObject personalSettings;

  @override
  State<AddDevice> createState() => _AddDeviceState();
}

class _AddDeviceState extends State<AddDevice> {

  Future<List<ControllerSubscription>> _startGetControllers(int userId) async {
    List<ControllerSubscription> controllers = await fetchControllers(userId);
    await Future.delayed(const Duration(milliseconds: 500));
    return controllers;

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
                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 7,
                            child: Container(
                              padding: const EdgeInsets.all(20.0),
                              margin: const EdgeInsets.only(left: 20),
                              child: Text(
                                snapshot.data![index].controller.name,
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                              padding: const EdgeInsets.all(20.0),
                              margin: const EdgeInsets.only(left: 20),
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
                                    subscribeController(widget.personalSettings.userId, snapshot.data![index].controller.objectId);
                                    setState(() {
                                      _startGetControllers(widget.personalSettings.userId);
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

