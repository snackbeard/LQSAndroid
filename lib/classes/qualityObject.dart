import 'dart:async';
import 'dart:convert';

import 'package:air_sensor_app/infrastructure/appUrl.dart';
import 'package:http/http.dart' as http;

Future<List<QualityObject>> fetchTvocs(int backwards) async {

  List<QualityObject> qualityObjects;

  final response = await http
      .get(Uri.parse(AppUrl.buildUrl("gettvocs.$backwards", null)));

  if (response.statusCode == 200) {
    var data = json.decode(response.body) as List;
    qualityObjects =
        data.map<QualityObject>((json) => QualityObject.fromJson(json)).toList();

    return qualityObjects;

    // return QualityObject.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to fetch data!');
  }
  // https://medium.flutterdevs.com/parsing-complex-json-in-flutter-b7f991611d3e
}

Future<List<QualityObject>> fetchEco2(int backwards) async {
  
  List<QualityObject> qualityObjects;

  final response = await http
      .get(Uri.parse(AppUrl.buildUrl('geteco2.$backwards', null)));

  if (response.statusCode == 200) {
    var data = json.decode(response.body) as List;
    qualityObjects =
        data.map<QualityObject>((json) => QualityObject.fromJson(json)).toList();

    return qualityObjects;
  } else {
    throw Exception('Failed to fetch data!');
  }
}

class QualityObject {

  final double value;
  final String timeOfRecording;

  const QualityObject({
    required this.value,
    required this.timeOfRecording
  });

  factory QualityObject.fromJson(Map<String, dynamic> json) {
    return QualityObject(
      value: json['value'],
      timeOfRecording: (json['timeOfRecording'] as String)
    );
  }

}