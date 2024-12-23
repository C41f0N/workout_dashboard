import 'package:auto_size_text/auto_size_text.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_dashboard/parsing_ops/workout_data.dart';

class WorkoutHistoryDensity extends StatefulWidget {
  WorkoutHistoryDensity({super.key});

  int densityThresholdWeeks = 5;

  @override
  State<WorkoutHistoryDensity> createState() => _WorkoutHistoryDensityState();
}

class _WorkoutHistoryDensityState extends State<WorkoutHistoryDensity> {
  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(builder: (context, workoutData, widget1) {
      widget.densityThresholdWeeks =
          workoutData.getSelectedDensityDurationWeeks() ?? 5;

      Map<String, double> workoutDensity =
          workoutData.getWorkoutsDensity(widget.densityThresholdWeeks);

      return Padding(
        padding: EdgeInsets.fromLTRB(
          MediaQuery.of(context).size.width * 0.02,
          MediaQuery.of(context).size.height * 0.025,
          MediaQuery.of(context).size.width * 0.02,
          MediaQuery.of(context).size.height * 0.025,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.08,
              width: MediaQuery.of(context).size.width * 0.32,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: SizedBox(
                      child: Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.1,
                            child: Slider(
                                value: (widget.densityThresholdWeeks - 1) / 36,
                                onChanged: (newValue) {
                                  setState(() {
                                    workoutData.setSelectedDensityDurationWeeks(
                                        (newValue * 36).round() + 1);
                                  });
                                }),
                          ),
                          Text(widget.densityThresholdWeeks == 1
                              ? "1 Week"
                              : "${widget.densityThresholdWeeks} Weeks"),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.1,
                        height: MediaQuery.of(context).size.height * 0.045,
                        child: const AutoSizeText(
                          "Workout Density",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 200,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.01,
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.18,
              width: MediaQuery.of(context).size.width * 0.3,
              child: BarChart(
                swapAnimationDuration: const Duration(milliseconds: 250),
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(
                    show: true,
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[500]!),
                      // left: BorderSide(color: Colors.grey[500]!),
                    ),
                  ),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                          reservedSize: 22,
                          showTitles: true,
                          getTitlesWidget: (index, titleMeta) {
                            List<String> workouts = [
                              "Arms",
                              "Shldr/Back",
                              "Chest",
                              "Abs",
                              "Legs",
                            ];

                            return Text(workouts[index.toInt()]);
                          }),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(
                        reservedSize: 5,
                        getTitlesWidget: (x, y) {
                          return const Text("dfdf");
                        },
                      ),
                    ),
                  ),
                  barGroups: [
                    BarChartGroupData(
                      x: 0,
                      barRods: [
                        BarChartRodData(
                          toY: workoutDensity["Arms"] ?? 0,
                          width: MediaQuery.of(context).size.width * 0.03,
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        )
                      ],
                    ),
                    BarChartGroupData(
                      x: 1,
                      barRods: [
                        BarChartRodData(
                          toY: workoutDensity["Shoulders and Back"] ?? 0,
                          width: MediaQuery.of(context).size.width * 0.03,
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        )
                      ],
                    ),
                    BarChartGroupData(
                      x: 2,
                      barRods: [
                        BarChartRodData(
                          toY: workoutDensity["Chest"] ?? 0,
                          width: MediaQuery.of(context).size.width * 0.03,
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        )
                      ],
                    ),
                    BarChartGroupData(
                      x: 3,
                      barRods: [
                        BarChartRodData(
                          toY: workoutDensity["Abs"] ?? 0,
                          width: MediaQuery.of(context).size.width * 0.03,
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        )
                      ],
                    ),
                    BarChartGroupData(
                      x: 4,
                      barRods: [
                        BarChartRodData(
                          toY: workoutDensity["Legs"] ?? 0,
                          width: MediaQuery.of(context).size.width * 0.03,
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        )
                      ],
                    ),
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
