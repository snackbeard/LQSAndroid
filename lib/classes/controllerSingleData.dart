import 'dart:convert';

import 'package:air_sensor_app/classes/qualityObject.dart';

import 'package:http/http.dart' as http;

import '../infrastructure/appUrl.dart';

Future<List<ControllerSingleData>> fetchDataTvoc(int userId, int backwards) async {

  List<ControllerSingleData> controllerData;

  final response = await http
      .get(Uri.parse(AppUrl
        .buildUrl(AppUrl.userPath, '.$userId.fetchDataTvoc.$backwards')));

  if (response.statusCode == 200) {
    var data = json.decode(utf8.decode(response.bodyBytes)) as List;
    controllerData =
        data.map<ControllerSingleData>(
            (json) => ControllerSingleData.fromJson(json)).toList();

    return controllerData;

  } else {
    throw (response.body);
  }

}

Future<List<ControllerSingleData>> fetchDataEco2(int userId, int backwards) async {

  List<ControllerSingleData> controllerData;

  final response = await http
      .get(Uri.parse(AppUrl
      .buildUrl(AppUrl.userPath, '.$userId.fetchDataEco2.$backwards')));

  if (response.statusCode == 200) {
    var data = json.decode(utf8.decode(response.bodyBytes)) as List;
    controllerData =
        data.map<ControllerSingleData>(
                (json) => ControllerSingleData.fromJson(json)).toList();

    return controllerData;

  } else {
    throw (response.body);
  }

}

class ControllerSingleData {
  String name;
  List<QualityObject> data;

  ControllerSingleData({
    required this.name,
    required this.data
  });

  factory ControllerSingleData.fromJson(Map<String, dynamic> json) {

    var data = json['data'] as List;

    return ControllerSingleData(
      name: json['name'],
      data: data.map((e) => QualityObject.fromJson(e)).toList()
    );
  }
  
}