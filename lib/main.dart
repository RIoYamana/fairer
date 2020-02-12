import 'package:flutter/material.dart';
import 'package:timetable_app/root.dart';
import 'schedule.dart';
import 'lesson/class_register.dart';
import 'package:timetable_app/lesson/timeTablePage.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  final RouteObserver<PageRoute> routeObserver = new RouteObserver<PageRoute>();
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: <NavigatorObserver>[routeObserver],
      home: Schedule(),
      );
  }
}