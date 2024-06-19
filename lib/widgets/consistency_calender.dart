import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:provider/provider.dart';
import 'package:workout_dashboard/parsing_ops/workout_data.dart';

class ConsistencyCalendar extends StatefulWidget {
  const ConsistencyCalendar({super.key});

  @override
  State<ConsistencyCalendar> createState() => _ConsistencyCalendarState();
}

class _ConsistencyCalendarState extends State<ConsistencyCalendar> {
  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, workoutDatabase, widget) {
        return HeatMapCalendar(
          colorMode: ColorMode.opacity,
          showColorTip: false,
          size: min(
            MediaQuery.of(context).size.height * 0.47 * 0.6,
            MediaQuery.of(context).size.width * 0.27 * 0.1,
          ),
          colorsets: const {10: Colors.green},
          datasets: <DateTime, int>{
            for (DateTime date in workoutDatabase.getWorkoutDates()) date: 1
          },
          borderRadius: 100,
          defaultColor: Theme.of(context).colorScheme.surface,
          textColor: Colors.white,
        );
      },
    );
  }
}
