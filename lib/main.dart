import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:workout_dashboard/pages/home.dart';
import 'package:workout_dashboard/parsing_ops/workout_data.dart';

void main() async {
  // Initializing Hive
  await Hive.initFlutter();
  await Hive.openBox("WORKOUT_DATABASE");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => WorkoutData(),
      child: MaterialApp(
        title: 'Workout Dashboard',
        theme: ThemeData(
          colorScheme: const ColorScheme.dark(
            primary: Colors.green,
          ),
        ),
        home: Home(),
      ),
    );
  }
}
