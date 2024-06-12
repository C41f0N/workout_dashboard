import 'package:file_selector/file_selector.dart';
import 'package:workout_dashboard/parsing_ops/excercise.dart';
import 'package:workout_dashboard/parsing_ops/workout.dart';

class WorkoutData {
  List<Workout> workouts = [];
  XFile? workoutLogFile;
  String rawWorkoutLogString = "";

  Map<String, int> monthNum = {
    "Jan": 1,
    "Feb": 2,
    "Mar": 3,
    "Apr": 4,
    "May": 5,
    "Jun": 6,
    "Jul": 7,
    "Aug": 8,
    "Sep": 9,
    "Oct": 10,
    "Nov": 11,
    "Dec": 12,
  };

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
    List<String> workoutRawStrings = rawWorkoutLogString.split("\n\n");

    for (int i = 0; i < workoutRawStrings.length; i++) {
      try {
        String rawWorkoutString = workoutRawStrings[i];

        // Parsing Date
        String dateString = rawWorkoutString.split("\n")[0].split(" - ")[0];

        DateTime workoutDate = DateTime(
          int.parse(dateString.split(" ")[2]),
          monthToNum(dateString.split(" ")[1]),
          int.parse(dateString.split(" ")[0]),
        );

        // Paring Name
        String workoutName = rawWorkoutString.split("\n")[0].split(" - ")[1];

        // Parsing Excercises
        List<Excercise> excercises = [];

        for (int j = 1; j < rawWorkoutString.split("\n").length; j++) {
          String rawExcerciseString = rawWorkoutString.split("\n")[j];

          // name
          String excerciseName = rawExcerciseString.split(" - ")[0];

          // reps
          double excerciseReps = manageRepsToFloat(
              rawExcerciseString.split(" - ")[1].split("x")[0]);

          // sets
          int excerciseSets =
              int.parse(rawExcerciseString.split(" - ")[1].split("x")[1]);

          // Creating and adding excercises
          excercises
              .add(new Excercise(excerciseName, excerciseSets, excerciseReps));
        }

        // Creating and adding workout
        workouts.add(new Workout(workoutDate, workoutName, excercises));
      } catch (e) {
        print("Some exception occoured : ${e.toString()}");
      }

      printWorkouts();
    }
  }

  void printWorkouts() {
    for (int i = 0; i < workouts.length; i++) {
      workouts[i].printWorkout();
    }
  }

  int monthToNum(String month3Letter) {
    return monthNum[month3Letter] ?? 1;
  }

  double manageRepsToFloat(String reps) {
    if (double.tryParse(reps) == null) {
      int minutes = 0, seconds = 0;

      if (reps.contains("min")) {
        int minutes = int.parse(reps.split("min")[0]);

        if (reps.contains("sec")) {
          seconds = int.parse(reps.split("min")[1].replaceAll("sec", ""));
        }
      }
      return minutes + (seconds / 60);
    }

    return double.parse(reps);
  }
}
