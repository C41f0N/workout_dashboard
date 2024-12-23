import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_dashboard/parsing_ops/excercise.dart';
import 'package:workout_dashboard/parsing_ops/workout.dart';
import 'package:workout_dashboard/parsing_ops/workout_data.dart';

class LastWorkoutDisplay extends StatefulWidget {
  const LastWorkoutDisplay({super.key});

  @override
  State<LastWorkoutDisplay> createState() => _LastWorkoutDisplayState();
}

class _LastWorkoutDisplayState extends State<LastWorkoutDisplay> {
  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(builder: (context, workoutDatabase, widget) {
      Workout? lastWorkout = workoutDatabase.getLastWorkout();

      return Padding(
        padding: EdgeInsets.fromLTRB(
          MediaQuery.of(context).size.width * 0.0125,
          MediaQuery.of(context).size.height * 0.02,
          MediaQuery.of(context).size.width * 0.015,
          MediaQuery.of(context).size.height * 0.02,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  child: Container(
                    alignment: Alignment.center,
                    // width: MediaQuery.of(context).size.width * 0.19,
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: const AutoSizeText(
                      "Last Workout",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 200,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                SizedBox(
                  child: Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height * 0.03,
                    child: AutoSizeText(
                      lastWorkout != null ? lastWorkout.name : "",
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 200,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.24,
                  child: ListView.builder(
                      itemCount: lastWorkout!.excercises.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Container(
                            color: Colors.black,
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Name
                                Text(lastWorkout.excercises[index].name),

                                // Reps per set
                                Text(lastWorkout.excercises[index].repsPerSet %
                                            1 ==
                                        0
                                    ? lastWorkout.excercises[index].repsPerSet
                                        .toInt()
                                        .toString()
                                    : lastWorkout.excercises[index].repsPerSet
                                        .toString()),

                                // Sets
                                Text(lastWorkout.excercises[index].sets
                                    .toString()),
                              ],
                            ),
                          ),
                        );
                      }),
                )
              ],
            ),
          ],
        ),
      );
    });
  }
}
