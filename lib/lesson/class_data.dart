//授業のデータを持つクラス
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'dart:async';
import 'package:sqflite/sqflite.dart' as sqlite;
class ClassData{
  final int id;
  final int week;
  final int time;
  final String className;
  final String teacherName;
  final String roomName;
  final String classCode;
  final int attendance;//出席
  final int absence;//欠席
  final int late;//遅刻
  //List<String> memo;
  //List<DateTime> canceled;//休講
  final String color;
  ClassData({
    this.id,
    this.week,
    this.time,
    this.className,
    this.teacherName,
    this.roomName,
    this.classCode,
    this.attendance,
    this.absence,
    //this.memo,
    //this.canceled,
    this.late,
    this.color,
  });
  Map<String,dynamic> toMap(){
    return {
      'id':id,
      'week':week,
      'time':time,
      'className':className,
      'teacherName':teacherName,
      'roomName':roomName,
      'classCode':classCode,
      'attendance':attendance,
      'absence':absence,
      'late':late,
      'color':color
    };
  }
  Future<void> Insertclassdate(ClassData classDate,sqlite.Database database) async {
    final sqlite.Database db = await database;
    await db.insert(
      'classdate',
      classDate.toMap(),
      conflictAlgorithm: sqlite.ConflictAlgorithm.replace,
    );
  }
}