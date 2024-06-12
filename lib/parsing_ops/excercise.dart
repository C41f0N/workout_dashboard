class Excercise {
  late String name;
  late int sets;
  late double repsPerSet;

  Excercise(this.name, this.sets, this.repsPerSet);

  void printExcerice() {
    print("$name, ${repsPerSet}x$sets");
  }
}
