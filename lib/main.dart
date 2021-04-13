import 'package:flutter/material.dart';
import 'package:flutter_event_tracker/settingPage.dart';
import 'heatMapPage.dart';
import 'EventsList/eventsList.dart';
import 'eventEditor.dart';
import 'EventDetails.dart';
import 'common/util.dart';
import 'common/const.dart';
import 'package:flutter/widgets.dart';
import 'unitsManagerPage.dart';
import 'DAO/base.dart';
import 'package:share/share.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

//TODO 增加桩程序，获取faked传感器数据
//TODO heatMap可交互
void main() {
  runApp(EventTracker());
}

class EventTracker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "eventEditor": (context) => new EventEditor(),
        "unitsManager": (context) => new UnitsManager(),
        "EventDetails": (context) => new EventDetails(),
      },
      title: 'Event Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainPages(),
    );
  }
}

class MainPages extends StatefulWidget {
  // final UniqueKey _key = UniqueKey();

  @override
  _MainPagesState createState() => _MainPagesState();
}

class _MainPagesState extends State<MainPages> {
  int _selectedIndex = 0;

  bool floatingButtonVisible = true;
  List<Widget> _children = [EventList(), HeatMap(), SettingPage()];
  dynamic eventData; //添加event用，接收返回值

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Event Tracker"),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                DBHandle().db.deleteEverything();
                setState(() {
                  _children.removeAt(0);
                  _children.insert(0, EventList(key: GlobalKey()));
                });
              },
              icon: Icon(Icons.delete)),
          IconButton(
              icon: Icon(Icons.share),
              onPressed: () {
                Share.share('Developed By Yuer Guo');
              }),
        ],
      ),
      body: NotificationListener<ReloadEventsNotification>(
        child: IndexedStack(children: _children, index: _selectedIndex),
        onNotification: (notification) {
          setState(() {
            _children.removeAt(0);
            _children.insert(0, EventList(key: GlobalKey()));
          });
          return true;
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        // 底部导航
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.event_note_rounded), label: '事项'),
          BottomNavigationBarItem(
              icon: Icon(Icons.pie_chart_outline_rounded), label: '统计'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: '选项'),
        ],
        currentIndex: _selectedIndex,
        fixedColor: Colors.blue,
        onTap: _onItemTapped,
      ),
      floatingActionButton: new Visibility(
          visible: floatingButtonVisible,
          child: FloatingActionButton(
              //悬浮按钮
              child: Icon(Icons.note_add_rounded),
              onPressed: () {
                eventData = Navigator.of(context).pushNamed("eventEditor");
                eventData.then((value) {
                  DBHandle().db.addEventInDB(value);
                  setState(() {
                    _children.removeAt(0);
                    _children.insert(0, EventList(key: GlobalKey()));
                  });
                });
              })),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      if (index == 0) {
        floatingButtonVisible = true;
      } else {
        floatingButtonVisible = false;
      }
      _selectedIndex = index;
    });
  }
}