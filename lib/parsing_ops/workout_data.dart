import 'dart:async';
import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:workout_dashboard/parsing_ops/excercise.dart';
import 'package:workout_dashboard/parsing_ops/workout.dart';

int secondsToWaitBeforeChange = 5;

class WorkoutData extends ChangeNotifier {
  final _workoutDatabase = Hive.box("WORKOUT_DATABASE");

  WorkoutData() {
    final writeTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) async {
        if (writeAt.isBefore(DateTime.now()) && fileChanged) {
          // Call write function

          await writeToFile();
          writeAt =
              DateTime.now().add(Duration(seconds: secondsToWaitBeforeChange));
          fileChanged = false;
          notifyListeners();
        }
      },
    );
  }

  DateTime writeAt =
      DateTime.now().add(Duration(seconds: secondsToWaitBeforeChange));
  bool fileChanged = false;
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
        // print("Some exception occoured : ${e.toString()}");
      }
    }

    return true;
  }

  // Write updated raw string to file
  Future<void> writeToFile({data}) async {
    if (data != null) {
      rawWorkoutLogString = data;
    }

    if (workoutLogFile != null) {
      final Uint8List fileData =
          Uint8List.fromList(rawWorkoutLogString.codeUnits);
      const String mimeType = 'text/plain';
      final XFile textFile = XFile.fromData(fileData,
          mimeType: mimeType, name: workoutLogFile!.name);
      await textFile.saveTo(workoutLogFile!.path);

      fileChanged = false;
    }

    notifyListeners();
  }

  // Update raw string data
  Future<void> updateLogRaw(String updatedLogString) async {
    rawWorkoutLogString = updatedLogString;
    fileChanged = true;
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

    for (int i = workouts.length - 1; i >= 0; i--) {
      for (int j = 0; j < workouts[i].excercises.length; j++) {
        excerciseNames.add(workouts[i].excercises[j].name);
      }
    }
    return excerciseNames.toList();
  }

  // Get all recorded workout names
  List<String> getAllRecordedWorkoutNames() {
    Set<String> workoutNames = {};

    for (int i = 0; i < workouts.length; i++) {
      workoutNames.add(workouts[i].name);
    }

    return workoutNames.toList();
  }

  // Get Reps History for an excercise
  Map<DateTime, double> getRepsHistory(
    String excerciseName,
    Duration duration,
  ) {
    setSelectedSetHisoryExcercise(excerciseName);
    Map<DateTime, double> repsHistory = {};

    // Check each workout
    for (int i = workouts.length - 1; i >= 0; i--) {
      // Get excercise index

      if (workouts[i].date.isBefore(DateTime.now().subtract(duration))) {
        break;
      }

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

  // Get density for workouts done in history
  Map<String, double> getWorkoutsDensity(int weeks) {
    Map<String, int> workoutCount = {};

    DateTime thresholdDate = DateTime.now().subtract(Duration(days: weeks * 7));

    int totalWorkouts = 0;

    for (int i = workouts.length - 1; i >= 0; i--) {
      if (workouts[i].date.isAfter(thresholdDate)) {
        totalWorkouts++;

        if (!workoutCount.keys.contains(workouts[i].name)) {
          workoutCount[workouts[i].name] = 0;
        } else {
          workoutCount[workouts[i].name] = workoutCount[workouts[i].name]! + 1;
        }
      } else {
        break;
      }
    }

    Map<String, double> workoutDensity = {};

    for (int i = 0; i < workoutCount.keys.length; i++) {
      workoutDensity[workoutCount.keys.toList()[i]] =
          workoutCount[workoutCount.keys.toList()[i]]!.toDouble() /
              totalWorkouts;
    }

    return workoutDensity;
  }

  Workout? getLastWorkout() {
    return workouts.isNotEmpty ? workouts.last : null;
  }

  void registerFileChange() {
    fileChanged = true;
    writeAt = DateTime.now().add(Duration(seconds: secondsToWaitBeforeChange));
  }

  void setWorkoutLogFileRawString(String rawString) {
    rawWorkoutLogString = rawString;
  }

  void setSelectedSetHisoryExcercise(String workout) {
    _workoutDatabase.put("SELECTED_SET_HISTORY_WORKOUT", workout);
  }

  String? getSelectedSetHisoryExcercise() {
    return _workoutDatabase.get("SELECTED_SET_HISTORY_WORKOUT");
  }

  void setSelectedDensityDurationWeeks(int weeks) {
    _workoutDatabase.put("SELECTED_DENSITY_DURATION_WEEKS", weeks);
  }

  int? getSelectedDensityDurationWeeks() {
    return _workoutDatabase.get("SELECTED_DENSITY_DURATION_WEEKS");
  }
}
