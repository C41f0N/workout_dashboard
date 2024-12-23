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
                  height: MediaQuery.of(context).size.height * 0.015,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        child: Container(
                          alignment: Alignment.bottomLeft,
                          width: MediaQuery.of(context).size.width * 0.16,
                          height: MediaQuery.of(context).size.height * 0.055,
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
                          alignment: Alignment.bottomRight,
                          height: MediaQuery.of(context).size.height * 0.03,
                          width: MediaQuery.of(context).size.width * 0.06,
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
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.015,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black.withOpacity(0.3),
                  ),
                  height: MediaQuery.of(context).size.height * 0.26,
                  child: ListView.builder(
                      itemCount: lastWorkout!.excercises.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            height: 60,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Name
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  width:
                                      MediaQuery.of(context).size.width * 0.15,
                                  child: AutoSizeText(
                                      lastWorkout.excercises[index].name),
                                ),

                                // Reps per set
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  width:
                                      MediaQuery.of(context).size.width * 0.025,
                                  child: AutoSizeText(lastWorkout
                                                  .excercises[index]
                                                  .repsPerSet %
                                              1 ==
                                          0
                                      ? lastWorkout.excercises[index].repsPerSet
                                          .toInt()
                                          .toString()
                                      : lastWorkout.excercises[index].repsPerSet
                                          .toString()),
                                ),

                                // Sets
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  width:
                                      MediaQuery.of(context).size.width * 0.025,
                                  child: AutoSizeText(lastWorkout
                                      .excercises[index].sets
                                      .toString()),
                                ),
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
