import 'package:flutter/material.dart';
import 'package:workout_dashboard/pages/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workout Dashboard',
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(
          primary: Colors.green,
        ),
      ),
      home: Home(),
    );
  }
}