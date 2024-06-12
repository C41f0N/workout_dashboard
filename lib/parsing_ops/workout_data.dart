import 'package:file_selector/file_selector.dart';
import 'package:workout_dashboard/parsing_ops/workout.dart';

class WorkoutData {
  late List<Workout> workouts;
  XFile? workoutLogFile;

  void parseData() {
    print(rawWorkoutLogString);
  }
}
