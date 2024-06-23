import 'package:auto_size_text/auto_size_text.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_dashboard/pages/settings.dart';
import 'package:workout_dashboard/parsing_ops/workout_data.dart';
import 'package:workout_dashboard/widgets/average_completion_display.dart';
import 'package:workout_dashboard/widgets/consistency_calender.dart';
import 'package:workout_dashboard/widgets/file_availability_wrapper.dart';
import 'package:workout_dashboard/widgets/reps_intensity_history.dart';
import 'package:workout_dashboard/widgets/workout_history_density.dart';

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
                            child: FileAvailabilityWrapper(
                              fileAvailable:
                                  workoutDatabase.getStoredFilePath() != null,
                              child: WorkoutHistoryDensity(),
                            ),
                          ),

                          // Reps Intensity History
                          Container(
                            height: MediaQuery.of(context).size.height * 0.32,
                            width: MediaQuery.of(context).size.width * 0.57,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            alignment: Alignment.center,
                            child: FileAvailabilityWrapper(
                              fileAvailable:
                                  workoutDatabase.getStoredFilePath() != null,
                              child: RepsIntensityHistory(),
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
                            child: FileAvailabilityWrapper(
                              fileAvailable:
                                  workoutDatabase.getStoredFilePath() != null,
                              child: const ConsistencyCalendar(),
                            ),
                          ),

                          // Average Completion
                          Container(
                            height: MediaQuery.of(context).size.height * 0.40,
                            width: MediaQuery.of(context).size.width * 0.27,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 24, 24, 24),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            alignment: Alignment.center,
                            child: FileAvailabilityWrapper(
                              fileAvailable:
                                  workoutDatabase.getStoredFilePath() != null,
                              child: const AverageCompletionDisplay(),
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
