import 'package:air_sensor_app/classes/qualityObject.dart';
import 'package:flutter/material.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

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
  final List<QualityObject> diagramData;

  @override
  State<DiagramPage> createState() => _DiagramPageState();
}

class _DiagramPageState extends State<DiagramPage> {
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
        series: <LineSeries<QualityObject, String>>[
          LineSeries<QualityObject, String>(
            color: const Color(0xff64b5f6),
            dataSource: widget.diagramData,
            xValueMapper: (QualityObject object, _) => object.timeOfRecording,
            yValueMapper: (QualityObject object, _) => object.value,
            dataLabelSettings: DataLabelSettings(
              isVisible: (widget.diagramData.length <= widget.dataLabelVisibleLength) ? true : false,
              textStyle: const TextStyle(
                color: Color(0xff9be7ff)
              ),
            ),
          ),
          //TODO bei bedarf weitere lines hinzufügen
        ],
      ),
    );
  }
}
