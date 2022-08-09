import 'dart:async';

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

  void _connectToBt(String address) async {
    try {
      BluetoothConnection connection = await BluetoothConnection.toAddress(address);
      debugPrint(connection.isConnected.toString());
      debugPrint('connected');
      // https://pub.dev/packages/flutter_bluetooth_serial
      // redirect configuration page
    } catch (exception) {
      debugPrint(exception.toString());
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
                            _connectToBt(address);
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

