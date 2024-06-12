import 'package:workout_dashboard/parsing_ops/class_excercise.dart';

class Workout {
  late DateTime date;
  late String name;
  late List<Excercise> excercises;

  Workout(this.date, this.name, this.excercises);
}
