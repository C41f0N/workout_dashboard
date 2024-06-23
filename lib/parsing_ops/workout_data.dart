import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:workout_dashboard/parsing_ops/excercise.dart';
import 'package:workout_dashboard/parsing_ops/workout.dart';

class WorkoutData extends ChangeNotifier {
  final _workoutDatabase = Hive.box("WORKOUT_DATABASE");

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

    // Persisting read file
    persistLogFile();
    notifyListeners();
  }

  void removeFile() {
    workoutLogFile = null;
    workouts = [];
    persistLogFile();
    notifyListeners();
  }

  // Function to persist the log into device storage
  void persistLogFile() {
    if (workoutLogFile != null) {
      _workoutDatabase.put("workout_log_file_path", workoutLogFile!.path);
    } else {
      _workoutDatabase.put("workout_log_file_path", null);
    }
  }

  // Function to load the log from the device storage
  void loadPersistedLogFile() {
    if (_workoutDatabase.get("workout_log_file_path") != null) {
      workoutLogFile = XFile(_workoutDatabase.get("workout_log_file_path"));
    } else {
      workoutLogFile = null;
    }
  }

  // Function to read data from file
  Future<void> readFile() async {
    loadPersistedLogFile();

    if (workoutLogFile != null) {
      rawWorkoutLogString = await workoutLogFile!.readAsString();
    }
  }

  // Parse the file data and store it (returns true when parsing complete)
  Future<bool> parseData() async {
    await readFile();

    workouts = [];

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
              .add(Excercise(excerciseName, excerciseSets, excerciseReps));
        }

        // Creating and adding workout

        workouts.add(Workout(workoutDate, workoutName, excercises));
      } catch (e) {
        print("Some exception occoured : ${e.toString()}");
      }
    }

    return true;
  }

  // Print all recorded workouts
  void printWorkouts() {
    for (int i = 0; i < workouts.length; i++) {
      workouts[i].printWorkout();
    }
  }

  // Get month index number
  int monthToNum(String month3Letter) {
    return monthNum[month3Letter] ?? 1;
  }

  // Convert time based reps to float values, one unit being one minute
  double manageRepsToFloat(String reps) {
    if (double.tryParse(reps) == null) {
      int minutes = 0, seconds = 0;

      if (reps.contains("min")) {
        minutes = int.parse(reps.split("min")[0]);

        if (reps.contains("sec")) {
          seconds = int.parse(reps.split("min")[1].replaceAll("sec", ""));
        }
      }
      return minutes + (seconds / 60);
    }

    return double.parse(reps);
  }

  // Function to get workout dates
  List<DateTime> getWorkoutDates() {
    List<DateTime> workoutDates = [];

    for (int i = 0; i < workouts.length; i++) {
      workoutDates.add(workouts[i].date);
    }

    return workoutDates;
  }

  // Get current file path
  String? getStoredFilePath() {
    return _workoutDatabase.get("workout_log_file_path");
  }

  // Get previous weeks percentage completion
  double getPreviousWeekPercentageCompletion(int weeks) {
    List<DateTime> workoutDates = getWorkoutDates();
    double completionPercentage = 0.0;

    DateTime dayToCheck =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    //get last monday
    while (dayToCheck.weekday != 1) {
      dayToCheck = dayToCheck.subtract(const Duration(days: 1));
    }

    // for every week
    for (int i = 0; i < weeks; i++) {
      int completedInWeek = 0;

      // Check each day of the week
      for (int j = 0; j < 7; j++) {
        dayToCheck = dayToCheck.subtract(const Duration(days: 1));
        if (workoutDates.contains(dayToCheck)) {
          completedInWeek++;
        }
      }

      completionPercentage = (completionPercentage + (completedInWeek / 5)) / 2;
    }

    return completionPercentage;
  }

  // Get current week percentage completion
  double getCurrentWeekCompletion() {
    List<DateTime> workoutDates = getWorkoutDates();

    DateTime dayToCheck =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    int completedInWeek = 0;

    // Check each day of the week and stop at monday
    do {
      if (workoutDates.contains(dayToCheck)) {
        completedInWeek++;
      }

      dayToCheck = dayToCheck.subtract(const Duration(days: 1));
    } while (dayToCheck.weekday != 1);

    // Check Monday
    if (workoutDates.contains(dayToCheck)) {
      completedInWeek++;
    }

    return completedInWeek / 5;
  }

  // Get all recorded excercise names
  List<String> getAllRecordedExcerciseNames() {
    Set<String> excerciseNames = {};

    for (int i = 0; i < workouts.length; i++) {
      for (int j = 0; j < workouts[i].excercises.length; j++) {
        excerciseNames.add(workouts[i].excercises[j].name);
      }
    }

    print(excerciseNames);
    print(workouts.length);
    return excerciseNames.toList();
  }

  // Get Reps History for an excercise
  Map<DateTime, double> getRepsHistory(String excerciseName) {
    Map<DateTime, double> repsHistory = {};

    // Check each workout
    for (int i = 0; i < workouts.length; i++) {
      // Get excercise index
      int excerciseIndex = workouts[i]
          .excercises
          .indexWhere((Excercise excercise) => excercise.name == excerciseName);

      if (excerciseIndex != -1) {
        // Add the reps to the corresponding date
        repsHistory[workouts[i].date] =
            workouts[i].excercises[excerciseIndex].repsPerSet;
      }
    }

    return repsHistory;
  }
}
