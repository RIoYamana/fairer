import 'package:flutter/material.dart';
import 'class_data.dart';
import 'package:path/path.dart' as path;
import 'dart:async';
import 'package:sqflite/sqflite.dart' as sqlite;

class ClassAttendance extends StatefulWidget {
  int attend;
  int absent;
  int late;
  ClassData data;

  ClassAttendance({
    @required this.data,
  }) : assert(data != null);

  _ClassAttendanceState createState() => _ClassAttendanceState();
}

class _ClassAttendanceState extends State<ClassAttendance> {
  int _counter = 0;
  Future<sqlite.Database> database;

  void initState() {
    _openDatabase();
    super.initState();
  }

  void _openDatabase() async {
    database = sqlite.openDatabase(
      path.join(await sqlite.getDatabasesPath(), 'ajj.db'),
      version: 1,
    );
  }

  Future<void> Insertclassdata(ClassData classDate) async {
    final sqlite.Database db = await database;
    await db.insert(
      'classdata',
      classDate.toMap(),
      conflictAlgorithm: sqlite.ConflictAlgorithm.replace,
    );
  }

  Widget build(BuildContext context) {
    if (_counter == 0) {
      widget.attend = widget.data.attendance;
      widget.absent = widget.data.absence;
      widget.late = widget.data.late;
      _counter = 1;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.data.className,
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 40),
            child: Text(
              "出席状況(タップで+1,長押しでリセットします)",
              style: TextStyle(fontSize: 14),
              
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 30,bottom: 30),
          child:Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
              Container(
                child: Padding(
                    padding: EdgeInsets.all(8),
                    child: InkWell(
                      child: Row(children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text(
                              "出席",
                              style: TextStyle(fontSize: 14),
                            ),
                            Text(''),
                            Text(''),
                          ],
                        ),
                        Center(
                          child: Text(
                            '${widget.attend}回',
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                      ]),
                      onTap: () {
                        setState(() {
                          widget.attend++;
                          print(widget.attend);
                        });
                      },
                      onLongPress: () {
                        setState(() {
                          widget.attend = 0;
                        });
                      },
                    )),
              ),
              Container(
                child:Padding(
                  padding: EdgeInsets.all(8),
                  child: InkWell(
                child: Row(children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        "遅刻",
                        style: TextStyle(fontSize: 14),
                      ),
                      Text(''),
                      Text(''),
                    ],
                  ),
                  Center(
                    child: Text(
                      '${widget.late}回',
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                ]),
                onTap: () {
                  setState(() {
                    widget.late++;
                    print(widget.late);
                  });
                },
                onLongPress: () {
                  setState(() {
                    widget.late = 0;
                  });
                },
              )),),
              Container(
                child:Padding(
                  padding: EdgeInsets.all(8),
                  child: InkWell(
                child: Row(children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        "欠席",
                        style: TextStyle(fontSize: 14),
                      ),
                      Text(''),
                      Text(''),
                    ],
                  ),
                  Center(
                    child: Text(
                      '${widget.absent}回',
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                ]),
                onTap: () {
                  setState(() {
                    widget.absent++;
                    print(widget.absent);
                  });
                },
                onLongPress: () {
                  setState(() {
                    widget.absent = 0;
                  });
                },
              )),)
            ]),
          )),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              color: Colors.lightBlue,
              // 送信ボタンクリック時の処理
              onPressed: () {
                // バリデーションチェック
                ClassData classdata = ClassData(
                    id: widget.data.id,
                    week: widget.data.week,
                    time: widget.data.time,
                    className: widget.data.className,
                    teacherName: widget.data.teacherName,
                    roomName: widget.data.roomName,
                    classCode: widget.data.classCode,
                    color: widget.data.color,
                    absence: widget.absent,
                    late: widget.late,
                    attendance: widget.attend);
                Insertclassdata(classdata);
                Navigator.of(context).pop(classdata);
              },
              child: Text(
                '戻る',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
