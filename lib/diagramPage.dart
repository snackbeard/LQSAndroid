import 'package:air_sensor_app/classes/qualityObject.dart';
import 'package:flutter/material.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

import 'classes/controllerSingleData.dart';

class DiagramPage extends StatefulWidget {
  const DiagramPage({
    Key? key,
    required this.diagramTitle,
    required this.diagramData,
    required this.dataLabelVisibleLength}) : super(key: key);

  final String diagramTitle;
  final int dataLabelVisibleLength;

  // zum erweitern List<List<QualityObject>> übergeben und im initState
  // eine LineSeries für jede Liste erstellen und unten hinzufügen
  final List<ControllerSingleData> diagramData;

  @override
  State<DiagramPage> createState() => _DiagramPageState();
}

class _DiagramPageState extends State<DiagramPage> {


  List<LineSeries<QualityObject, String>> getSeries() {
    List<LineSeries<QualityObject, String>> lines = [];

    for (var controller in widget.diagramData) {
      lines.add(LineSeries(
        animationDelay: 500,
        animationDuration: 5000,
        name: controller.name,
        color: Color(int.parse(controller.color)),
        dataSource: controller.data,
        xValueMapper: (QualityObject object, _) => object.timeOfRecording,
        yValueMapper: (QualityObject object, _) => object.value,
        dataLabelSettings: DataLabelSettings(
          isVisible: (controller.data.length <= widget.dataLabelVisibleLength && widget.diagramData.length == 1) ? true : false,
          textStyle: TextStyle(
              color: Color(int.parse(controller.color))
          ),
        ),
      ));
    }

    return lines;

  }

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SfCartesianChart(
        plotAreaBorderWidth: 0,
        title: ChartTitle(
          text: widget.diagramTitle,
          textStyle: const TextStyle(
            color: Color(0xffdddddd)
          ),
        ),
        legend: Legend(
          isVisible: true,
          textStyle: const TextStyle(
            color: Color(0xffdddddd),
          ),
        ),
        primaryXAxis: CategoryAxis(
          majorGridLines: const MajorGridLines(width: 0),
          labelRotation: -45,
          labelStyle: const TextStyle(
            color: Color(0xffdddddd)
          ),
        ),
        primaryYAxis: NumericAxis(
          rangePadding: ChartRangePadding.additional,
          labelStyle: const TextStyle(
            color: Color(0xffdddddd)
          ),
        ),
        series: getSeries(),
      ),
    );
  }
}
