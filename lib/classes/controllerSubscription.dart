import 'dart:async';
import 'dart:convert';

import 'package:air_sensor_app/classes/controllerEsp.dart';
import 'package:air_sensor_app/infrastructure/appUrl.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

Future<List<ControllerSubscription>> fetchControllers(int userId) async {
  
  List<ControllerSubscription> subscriptions;
  
  final response = await http
      .get(Uri.parse(AppUrl.buildUrl(AppUrl.getAllControllers, '.$userId')));

  if (response.statusCode == 200) {
    var data = json.decode(utf8.decode(response.bodyBytes)) as List;
    subscriptions =
        data.map<ControllerSubscription>(
                (json) => ControllerSubscription.fromJson(json)).toList();

    return subscriptions;
  } else {
    throw (response.body);
  }
  
}

Future<bool> unsubscribeController(int userId, int controllerId) async {
  final response = await http
      .get(Uri.parse(AppUrl
      .buildUrl(AppUrl.userPath, '.$userId.unsubscribeFrom.$controllerId')));

  if (response.statusCode == 200) {
    return true;
  } else {
    throw (response.body);
  }
}

Future<bool> subscribeController(int userId, int controllerId) async {
  final response = await http
      .get(Uri.parse(AppUrl
      .buildUrl(AppUrl.userPath, '.$userId.subscribeTo.$controllerId')));

  if (response.statusCode == 200) {
    return true;
  } else {
    throw (response.body);
  }
}

Future<bool> changeControllerColor(int userId, int controllerId, String color) async {
  final response = await http
    .post(Uri.parse(AppUrl.buildUrl(AppUrl.userPath, '.$userId.changeColorOf.$controllerId')),
    headers: <String, String> {
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String> {
      'color': '0x$color',
    }),
  );

  if (response.statusCode == 200) {
    return true;
  } else {
    throw (response.body);
  }
}

class ControllerSubscription {
  bool isSubscribed;
  ControllerEsp controller;
  String color;

  ControllerSubscription({
    required this.isSubscribed,
    required this.controller,
    required this.color
  });

  factory ControllerSubscription.fromJson(Map<String, dynamic> json) {
    return ControllerSubscription(
      color: json['color'],
      isSubscribed: json['isSubscribed'],
      controller: ControllerEsp.fromJson(json['controller'])
    );
  }

}