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
      if (workoutDatabase.workouts.isNotEmpty) {
        widget.excerciseName ??=
            workoutDatabase.workouts.last.excercises.last.name;
      } else {
        widget.excerciseName = "";
      }

      Map<DateTime, double> repsHistory =
          workoutDatabase.getRepsHistory(widget.excerciseName ?? "");

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
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(),
                    bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        DateTime date =
                            DateTime.fromMillisecondsSinceEpoch(value.toInt());
                        return Text(
                            "${date.year.toString().substring(2)}/${date.month}");
                      },
                    )),
                    rightTitles: AxisTitles(),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      isCurved: true,
                      color: Theme.of(context).colorScheme.primary,
                      barWidth: 5,
                      curveSmoothness: 0.2,
                      spots: List.generate(repsHistory.length, (i) {
                        // Getting an double value for dateTime so that it can be passed into FlSpot
                        double xValue = (repsHistory.keys.toList())[i]
                            .millisecondsSinceEpoch
                            .toDouble();

                        double yValue =
                            repsHistory[(repsHistory.keys.toList())[i]]!;

                        return FlSpot(xValue, yValue);
                      }),
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
