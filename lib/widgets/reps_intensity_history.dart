import 'package:auto_size_text/auto_size_text.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_dashboard/parsing_ops/workout_data.dart';

class RepsIntensityHistory extends StatefulWidget {
  RepsIntensityHistory({super.key});

  @override
  State<RepsIntensityHistory> createState() => RepsIntensityHistoryState();

  String? excerciseName;
}

class RepsIntensityHistoryState extends State<RepsIntensityHistory> {
  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(builder: (context, workoutDatabase, child) {
      widget.excerciseName ??=
          workoutDatabase.getAllRecordedExcerciseNames().first;

      return Padding(
        padding: EdgeInsets.fromLTRB(
          MediaQuery.of(context).size.width * 0.025,
          MediaQuery.of(context).size.height * 0.04,
          MediaQuery.of(context).size.width * 0.03,
          MediaQuery.of(context).size.height * 0.04,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.23,
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: const AutoSizeText(
                    "Set History",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 200,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                DropdownButton(
                  value: widget.excerciseName,
                  items: workoutDatabase
                      .getAllRecordedExcerciseNames()
                      .map(
                        (excerciseName) => DropdownMenuItem(
                          value: excerciseName,
                          child: AutoSizeText(excerciseName),
                        ),
                      )
                      .toList(),
                  onChanged: (excerciseName) {
                    print("Changing to $excerciseName");
                    setState(() {
                      widget.excerciseName = excerciseName;
                    });
                  },
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.17,
              width: MediaQuery.of(context).size.width * 0.5,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(
                    border: const Border(
                      left: BorderSide(),
                    ),
                  ),
                  titlesData: const FlTitlesData(
                    topTitles: AxisTitles(),
                    bottomTitles: AxisTitles(),
                    rightTitles: AxisTitles(),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      isCurved: true,
                      color: Theme.of(context).colorScheme.primary,
                      barWidth: 5,
                      curveSmoothness: 0.35,
                      spots: [
                        const FlSpot(0, 1),
                        const FlSpot(1, 1.5),
                        const FlSpot(2, 0.7),
                        const FlSpot(3, 0.6),
                        const FlSpot(4, 0.9),
                        const FlSpot(5, 0.5),
                        const FlSpot(6, 1.5),
                        const FlSpot(7, 0.7),
                        const FlSpot(8, 0.6),
                        const FlSpot(9, 0.9),
                        const FlSpot(10, 0.3),
                        const FlSpot(11, 0.6),
                        const FlSpot(12, 0.7),
                        const FlSpot(13, 0.6),
                        const FlSpot(14, 0.9),
                        const FlSpot(15, 0.3),
                        const FlSpot(16, 0.4),
                        const FlSpot(17, 0.7),
                        const FlSpot(18, 0.6),
                        const FlSpot(19, 0.9),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
