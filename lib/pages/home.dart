import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:provider/provider.dart';
import 'package:workout_dashboard/pages/settings.dart';
import 'package:workout_dashboard/parsing_ops/workout_data.dart';
import 'package:workout_dashboard/widgets/consistency_calender.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, workoutDatabase, widget) {
        return Scaffold(
          body: FutureBuilder(
            future: workoutDatabase.parseData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.025),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(),
                              const AutoSizeText(
                                "Workout Dashboard",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 200,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => SettingsPage(),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.settings),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Bar Chart Workout Type Intensity
                          Container(
                            height: MediaQuery.of(context).size.height * 0.32,
                            width: MediaQuery.of(context).size.width * 0.37,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            alignment: Alignment.center,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(
                                MediaQuery.of(context).size.width * 0.02,
                                MediaQuery.of(context).size.height * 0.05,
                                MediaQuery.of(context).size.width * 0.02,
                                MediaQuery.of(context).size.height * 0.05,
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.23,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.045,
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
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.01,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.15,
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    child: BarChart(
                                      swapAnimationDuration:
                                          const Duration(milliseconds: 250),
                                      BarChartData(
                                        alignment:
                                            BarChartAlignment.spaceAround,
                                        gridData: const FlGridData(show: false),
                                        borderData: FlBorderData(
                                          show: true,
                                          border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey[500]!),
                                            // left: BorderSide(color: Colors.grey[500]!),
                                          ),
                                        ),
                                        titlesData: FlTitlesData(
                                          bottomTitles: const AxisTitles(
                                            sideTitles:
                                                SideTitles(showTitles: false),
                                          ),
                                          rightTitles: const AxisTitles(
                                            sideTitles:
                                                SideTitles(showTitles: false),
                                          ),
                                          leftTitles: const AxisTitles(
                                            sideTitles:
                                                SideTitles(showTitles: false),
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
                                                toY: 15,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.03,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight: Radius.circular(10),
                                                ),
                                              )
                                            ],
                                          ),
                                          BarChartGroupData(
                                            x: 0,
                                            barRods: [
                                              BarChartRodData(
                                                toY: 10,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.03,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight: Radius.circular(10),
                                                ),
                                              )
                                            ],
                                          ),
                                          BarChartGroupData(
                                            x: 0,
                                            barRods: [
                                              BarChartRodData(
                                                toY: 7.5,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.03,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight: Radius.circular(10),
                                                ),
                                              )
                                            ],
                                          ),
                                          BarChartGroupData(
                                            x: 0,
                                            barRods: [
                                              BarChartRodData(
                                                toY: 5.5,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.03,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight: Radius.circular(10),
                                                ),
                                              )
                                            ],
                                          ),
                                          BarChartGroupData(
                                            x: 0,
                                            barRods: [
                                              BarChartRodData(
                                                toY: 6,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.03,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                borderRadius:
                                                    const BorderRadius.only(
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
                            ),
                          ),

                          // Workout Intensity History
                          Container(
                            height: MediaQuery.of(context).size.height * 0.32,
                            width: MediaQuery.of(context).size.width * 0.57,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            alignment: Alignment.center,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(
                                MediaQuery.of(context).size.width * 0.025,
                                MediaQuery.of(context).size.height * 0.04,
                                MediaQuery.of(context).size.width * 0.03,
                                MediaQuery.of(context).size.height * 0.04,
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.23,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
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
                                        items: const [
                                          DropdownMenuItem(
                                            child: Text("Dumbell Curls"),
                                          )
                                        ],
                                        onChanged: (x) {},
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.17,
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
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
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
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
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Consistency Calendar
                          Container(
                            height: MediaQuery.of(context).size.height * 0.40,
                            width: MediaQuery.of(context).size.width * 0.27,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            alignment: Alignment.center,
                            child: ConsistencyCalendar(),
                          ),

                          Container(
                            height: MediaQuery.of(context).size.height * 0.40,
                            width: MediaQuery.of(context).size.width * 0.27,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 24, 24, 24),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            alignment: Alignment.center,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(
                                MediaQuery.of(context).size.width * 0.0125,
                                MediaQuery.of(context).size.height * 0.02,
                                MediaQuery.of(context).size.width * 0.015,
                                MediaQuery.of(context).size.height * 0.02,
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.01,
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.19,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.05,
                                            child: const AutoSizeText(
                                              "Average Completion",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 200,
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.04),
                                      const Text("This Week"),
                                      const SizedBox(height: 10),
                                      LinearProgressIndicator(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        backgroundColor: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        value: 0.5,
                                        minHeight: 10,
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      const Text("Past Month"),
                                      const SizedBox(height: 10),
                                      LinearProgressIndicator(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        backgroundColor: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        value: 0.5,
                                        minHeight: 10,
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      const Text("Past 3 Months"),
                                      const SizedBox(height: 10),
                                      LinearProgressIndicator(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        backgroundColor: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        value: 0.5,
                                        minHeight: 10,
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      const Text("Past 6 Months"),
                                      const SizedBox(height: 10),
                                      LinearProgressIndicator(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        backgroundColor: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        value: 0.5,
                                        minHeight: 10,
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Last Workout
                          Container(
                            height: MediaQuery.of(context).size.height * 0.40,
                            width: MediaQuery.of(context).size.width * 0.37,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.23,
                                    height: MediaQuery.of(context).size.height *
                                        0.1,
                                    child: const AutoSizeText(
                                      "Last Workout",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 200,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  const Text(
                                    '''
            Squats (5-kg weight) - 25x3
            Lunges - 20x3
            Calf Raises (5-kg weight) - 35x3
                          ''',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 20,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  const SizedBox(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        );
      },
    );
  }
}
