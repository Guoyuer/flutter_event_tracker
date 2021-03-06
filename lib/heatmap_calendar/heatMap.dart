import 'package:flutter/material.dart';
import 'util.dart';
import 'heatMapBuildingBlocks.dart';
import '../common/const.dart';

var nilTime = DateTime.fromMicrosecondsSinceEpoch(0);

class HeatMapSetting {
  final Map<int, Color> colorMap; //int indicates level
  final double dayTileSize;
  final double dayTileMargin;
  final double weekTileMargin;
  final double monthTileMargin;

  const HeatMapSetting(
      {this.colorMap = heatmapColorMap,
      this.dayTileSize = 15,
      this.dayTileMargin = 5,
      this.weekTileMargin = 6,
      this.monthTileMargin = 2});
}

class HeatMapDataHolder extends InheritedWidget {
  final HeatMapSetting setting;
  final Map<DateTime, int> date2level;
  final Map<DateTime, double> data; // 用于toolTip
  final DateTimeRange dateRange; //因为map无序
  late final String? unit;

  HeatMapDataHolder(
      {required this.setting,
      required this.data,
      required this.date2level,
      required this.dateRange,
      this.unit,
      required Widget child})
      : super(child: child);

  @override
  bool updateShouldNotify(HeatMapDataHolder oldWidget) {
    return setting != oldWidget.setting;
  }

  static HeatMapDataHolder of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<HeatMapDataHolder>()!;
  }
}

// ignore: must_be_immutable
class HeatMapCalendar extends StatefulWidget {
  final HeatMapSetting setting;
  final Map<DateTime, double> data = {};
  final DateTimeRange dateRange;
  final String unit; //Tooltip显示的单位
  late double maxVal = 0;

  HeatMapCalendar(
      {Key? key,
      this.setting = const HeatMapSetting(),
      required Map<DateTime, double> input,
      required this.dateRange,
      required this.unit})
      : super(key: key) {
    input.forEach((key, value) {
      if (value > maxVal) maxVal = value;
      this.data[getDate(key)] = value;
    });
  }

  @override
  HeatMapCalendarState createState() {
    return HeatMapCalendarState();
  }
}

class HeatMapCalendarState extends State<HeatMapCalendar> {
  @override
  Widget build(BuildContext context) {
    //把date:double转化为date:level
    List<double> threshold = [0];
    int colorNum = widget.setting.colorMap.length - 1; //还有一个是透明
    for (int i = 0; i < colorNum - 1; i++) {
      threshold.add(i * widget.maxVal / colorNum);
    }
    Map<DateTime, int> date2level = Map<DateTime, int>();
    date2level[nilTime] = -1; //用于留白
    for (DateTime i = widget.dateRange.start;
        i.compareTo(widget.dateRange.end) <= 0;
        i = i.add(Duration(days: 1))) {
      if (widget.data.containsKey(i)) {
        int level = 0;
        for (int j = 0; j < threshold.length; j++) {
          if (widget.data[i]! > threshold[j]) level = j;
        }
        date2level[i] = level;
        //可能并不是所有日期都有数据，要允许这样的留白;
      } else {
        date2level[i] = 0;
      }
    }
    return HeatMapDataHolder(
        setting: widget.setting,
        date2level: date2level,
        data: widget.data,
        dateRange: widget.dateRange,
        unit: widget.unit,
        child: Container(
          child: HeatMapDisplay(),
        ));
  }
}
