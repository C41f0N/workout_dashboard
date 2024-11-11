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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.01,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.19,
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
                  ],
                ),
                Text(lastWorkout != null ? lastWorkout.name : ""),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: lastWorkout != null
                      ? lastWorkout.excercises.map((Excercise excercise) {
                          return Container(
                            child: Text(excercise.name),
                          );
                        }).toList() as List<Widget>
                      : [],
                )
              ],
            ),
          ],
        ),
      );
    });
  }
}
