import 'package:file_selector/file_selector.dart';
import 'package:workout_dashboard/parsing_ops/workout.dart';

class WorkoutData {
  late List<Workout> workouts;
  XFile? workoutLogFile;
  String rawWorkoutLogString = "";

  void getFile() async {
    workoutLogFile = await openFile(acceptedTypeGroups: <XTypeGroup>[
      const XTypeGroup(
        label: "TXT",
        extensions: ['txt'],
      )
    ]);

    await readFile();
  }

  // Function to read data from file
  Future<void> readFile() async {
    if (workoutLogFile != null) {
      rawWorkoutLogString = await workoutLogFile!.readAsString();
    }
  }

  void parseData() {
    print(rawWorkoutLogString);
  }
}
