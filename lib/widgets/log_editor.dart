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
      widget.logController.text =
          workoutData.rawWorkoutLogString.split("\n\n").last;

      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          AutoSizeText(
            "Last Workout",
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 40,
            ),
            textAlign: TextAlign.right,
          ),
          TextField(
            controller: widget.logController,
            maxLines: null,
            readOnly: true,
            decoration: InputDecoration(
              fillColor: Colors.grey[900],
              filled: true,
            ),
          ),
        ],
      );
    });
  }
}
