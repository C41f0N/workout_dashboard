import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_dashboard/parsing_ops/workout_data.dart';

class LogEditor extends StatefulWidget {
  LogEditor({super.key});

  final TextEditingController logController = TextEditingController();

  @override
  State<LogEditor> createState() => _LogEditorState();
}

class _LogEditorState extends State<LogEditor> {
  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(builder: (context, workoutData, widget1) {
      widget.logController.text = workoutData.rawWorkoutLogString;

      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AutoSizeText(
              "Log Editor",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 35,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.28,
              child: TextField(
                controller: widget.logController,
                maxLines: null,
                decoration: InputDecoration(
                  fillColor: Colors.grey[900],
                  filled: true,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
