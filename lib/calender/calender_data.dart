//授業のデータを持つクラス
//id INTEGER KEY, year INTEGER,month INTEGER,day INTEGER,plan TEXT,startTime TEXT,endTime TEXT,color TEXT
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'dart:async';
import 'package:sqflite/sqflite.dart' as sqlite;
class CalenderData{
  final int number;
  final String id;
  final String plan;
  final int sday;
  final int day;
  final int month;
  final int year;
  final int eday;
  final String startTime;
  final String startDay;
  final String endTime;
  final String endDay;
  final String color;
  CalenderData({
    this.number,
    this.sday,
    this.eday,
    this.day,
    this.month,
    this.year,
    this.id,
    this.plan,
    this.startTime,
    this.startDay,
    this.endTime,
    this.endDay,
    this.color,
  });
  Map<String,dynamic> toMap(){
    return {
      'day':day,
      'month':month,
      'year':year,
      'number':number,
      'id':id,
      'sday':sday,
      'eday':eday,
      'plan':plan,
      'startTime':startTime,
      'startDay':startDay,
      'endDay':endDay,
      'endTime':endTime,
      'color':color
    };
  }
  Future<void> Insertclassdate(CalenderData calenderData,sqlite.Database database) async {
    final sqlite.Database db = await database;
    await db.insert(
      'calenderplan',
      calenderData.toMap(),
      conflictAlgorithm: sqlite.ConflictAlgorithm.replace,
    );
  }
}