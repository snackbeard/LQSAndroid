import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'classes/espConfigurationObject.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';


class NewDevice extends StatefulWidget {
  const NewDevice({Key? key}) : super(key: key);

  @override
  State<NewDevice> createState() => _NewDeviceState();
}
// https://blog.kuzzle.io/communicate-through-ble-using-flutter
class _NewDeviceState extends State<NewDevice> {

  StreamSubscription<BluetoothDiscoveryResult>? _streamSubscription;
  List<BluetoothDiscoveryResult> results = List<BluetoothDiscoveryResult>.empty(growable: true);
  bool isDiscovering = true;
  ControllerConfiguration cc = ControllerConfiguration();

  _NewDeviceState();

  @override
  void initState() {
    super.initState();

    _startDiscovery();
  }

  void _startDiscovery() {
    _streamSubscription = FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
      setState(() {

        if (r.device.name != null) {
          results.add(r);
        }

        /*
        final existingIndex = results.indexWhere(
          (element) => element.device.name == r.device.address);

        if (existingIndex >= 0) {
          results[existingIndex] = r;
        } else {
          results.add(r);
        }
         */
      });

      _streamSubscription!.onDone(() {
        setState(() {
          isDiscovering = false;
        });
      });
    });
  }

  void _restartDiscovery() {
    setState(() {
      results.clear();
      isDiscovering = true;
    });

    _startDiscovery();
  }

  void _sendDataBt(String address) async {
    try {
        cc.checkValues();
        BluetoothConnection connection = await BluetoothConnection.toAddress(
            address);
        debugPrint(connection.isConnected.toString());
        debugPrint('connected');
        List<int> list = cc.toBtString().codeUnits;
        Uint8List bytes = Uint8List.fromList(list);
        connection.output.add(bytes);
        await connection.output.allSent;
        connection.input?.listen((Uint8List data) {
          if (ascii.decode(data).contains('1')) {
            connection.finish();
            debugPrint('disconnected');
            Navigator.of(context).pop();
            cc = ControllerConfiguration();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Color(0xff64b5f6),
                content: Text('Erfolgreich konfiguriert!'),
              ),
            );
          }
        });
        debugPrint("data send??");
        // https://pub.dev/packages/flutter_bluetooth_serial
        // redirect configuration page
    } catch (exception) {
      debugPrint(exception.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xff64b5f6),
          content: Text(exception.toString()),
        ),
      );
    }
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isDiscovering ? const Text('Suche Geräte ...') : const Text('Geräte gefunden'),
        actions: <Widget>[
          isDiscovering ? FittedBox(
            child: Container(
              margin: const EdgeInsets.all(16.0),
              child: const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.white),
              ),
            ),
          )
          : IconButton(
            icon: const Icon(Icons.replay),
            onPressed: _restartDiscovery,
          )
        ],
      ),
      body: ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          BluetoothDiscoveryResult result = results[index];
          final device = result.device;
          final address = device.address;
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 8,
                    child: Container(
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      margin: const EdgeInsets.only(left: 20),
                      child: Text(
                        device.name!,
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
                        child: IconButton(
                          icon: const Icon(Icons.bluetooth_connected),
                          color: const Color(0xffdddddd),
                          onPressed: () {
                            debugPrint("click");
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Bitte Konfigurieren'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        decoration: const InputDecoration(hintText: 'WiFi Name'),
                                        onChanged: (value) {
                                          cc.ssid = value;
                                        },
                                      ),
                                      TextField(
                                        obscureText: true,
                                        enableSuggestions: false,
                                        autocorrect: false,
                                        decoration: const InputDecoration(hintText: 'WiFi Password'),
                                        onChanged: (value) {
                                          cc.password = value;
                                        },
                                      ),
                                      TextField(
                                        decoration: const InputDecoration(hintText: 'Server IP'),
                                        onChanged: (value) {
                                          cc.serverIp = value;
                                        },
                                      ),
                                      TextField(
                                        decoration: const InputDecoration(hintText: 'Port'),
                                        onChanged: (value) {
                                          cc.port = value;
                                        },
                                      ),
                                      TextField(
                                        decoration: const InputDecoration(hintText: 'Controller Name'),
                                        onChanged: (value) {
                                          cc.controllerName = value;
                                        },
                                      ),
                                    ],
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
                                        _sendDataBt(address);
                                      },
                                    )
                                  ],
                                );
                              }
                            );
                          },
                        ),
                      ),
                    ),
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
        },
      ),
    );
  }
}

