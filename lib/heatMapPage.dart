import 'package:flutter/material.dart';
import 'heatMap/heatmap_calendar.dart';
import 'heatMap/time_utils.dart';

var heatmap = HeatMapCalendar(
  input: {
    TimeUtils.removeTime(DateTime.now().subtract(Duration(days: 3))): 5,
    TimeUtils.removeTime(DateTime.now().subtract(Duration(days: 2))): 35,
    TimeUtils.removeTime(DateTime.now().subtract(Duration(days: 1))): 14,
    TimeUtils.removeTime(DateTime.now()): 5,
  },
  colorThresholds: {
    1: Colors.green[100],
    10: Colors.green[300],
    30: Colors.green[500]
  },
  weekDaysLabels: ['S', 'M', 'T', 'W', 'T', 'F', 'S'],
  monthsLabels: [
    "",
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec",
  ],
  squareSize: 16.0,
  textOpacity: 0.3,
  labelTextColor: Colors.blueGrey,
  dayTextColor: Colors.blue[500],
);

class HeatMap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Center(
          child: heatmap,
        ),
      ),
    );
  }
}
