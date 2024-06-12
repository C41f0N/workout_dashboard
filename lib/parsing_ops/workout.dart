import 'package:workout_dashboard/parsing_ops/excercise.dart';

class Workout {
  late DateTime date;
  late String name;
  late List<Excercise> excercises;

  Workout(this.date, this.name, this.excercises);

  void printWorkout() {
    print("$date $name");
    for (int i = 0; i < excercises.length; i++) {
      excercises[i].printExcerice();
    }
  }
}
