import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_dashboard/parsing_ops/workout_data.dart';

class AverageCompletionDisplay extends StatefulWidget {
  const AverageCompletionDisplay({super.key});

  @override
  State<AverageCompletionDisplay> createState() =>
      _AverageCompletionDisplayState();
}

class _AverageCompletionDisplayState extends State<AverageCompletionDisplay> {
  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(builder: (context, workoutDatabase, widget) {
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
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                const Text("This Week"),
                const SizedBox(height: 10),
                LinearProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  value: workoutDatabase.getCurrentWeekCompletion(),
                  minHeight: 10,
                  borderRadius: BorderRadius.circular(100),
                ),
              ],
            ),
            Column(
              children: [
                const Text("Previous 4 Weeks"),
                const SizedBox(height: 10),
                LinearProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  value: workoutDatabase.getPreviousWeekPercentageCompletion(4),
                  minHeight: 10,
                  borderRadius: BorderRadius.circular(100),
                ),
              ],
            ),
            Column(
              children: [
                const Text("Past 12 Weeks"),
                const SizedBox(height: 10),
                LinearProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  value:
                      workoutDatabase.getPreviousWeekPercentageCompletion(12),
                  minHeight: 10,
                  borderRadius: BorderRadius.circular(100),
                ),
              ],
            ),
            Column(
              children: [
                const Text("Past 36 Weeks"),
                const SizedBox(height: 10),
                LinearProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  value:
                      workoutDatabase.getPreviousWeekPercentageCompletion(36),
                  minHeight: 10,
                  borderRadius: BorderRadius.circular(100),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
