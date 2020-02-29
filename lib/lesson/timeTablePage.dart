//時間割ページ
import 'package:fairer_ui/models/user.dart';
import 'package:fairer_ui/pages/profile.dart';
import 'package:fairer_ui/service/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'classPage.dart';
import 'class_data.dart';
import 'package:path/path.dart' as path;
import 'dart:async';
import 'package:sqflite/sqflite.dart';

import 'class_data.dart';
import 'class_data.dart';
import 'class_data.dart';

enum LoadingStatus { NOTDETERMINED, DETERMINED }

class Table extends StatefulWidget {
  //デフォ 5限の金曜日まで
  final int numberClass = 5; //5限の場合5
  final int numberWeek = 6; //土曜日なし5(月～金)土曜あり6(月～土)
  final String uid;

  Table({this.uid});

  _TableState createState() => _TableState();
}

class _TableState extends State<Table> with RouteAware {
  Map<String, ClassData> map = new Map<String, ClassData>();
  LoadingStatus loadingStatus = LoadingStatus.NOTDETERMINED;

  void operate() async {
    final Future<Database> database = openDatabase(
      path.join(await getDatabasesPath(), 'ajj.db'),
      onCreate: (db, version) {
        return db.execute(
          " CREATE TABLE classdata (id String PRIMARY KEY,localId INTEGER, week INTEGER,time INTEGER,className TEXT,teacherName TEXT,roomName TEXT,classCode TEXT,attendance INTEGER,absence INTEGER,late INTEGER,color TEXT) ",
        );
      },
      version: 1,
    );
    database.then((data) async {
      _getClassData(data);
      await insertClassData(data);
      setState(() {
        loadingStatus = LoadingStatus.DETERMINED;
      });
    });
  }

  Future<void> insertClassData(Database database) async {
    final Database db = database;
    if(map.length > 0) {
      await db.insert(
        'classdata',
        map,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  void _getClassData(Database database) async {
    final List<Map<String, dynamic>> maps = await database.query('classdata');
    Map<String, ClassData> classDatas = Map<String, ClassData>();
    ClassData classdata;
    for (int i = 0; i < maps.length; i++) {
      classdata = ClassData(
        id: maps[i]['id'],
        localId: maps[i]['localId'],
        week: maps[i]['week'],
        time: maps[i]['time'],
        className: maps[i]['className'],
        teacherName: maps[i]['teacherName'],
        roomName: maps[i]['roomName'],
        classCode: maps[i]['classCode'],
        attendance: maps[i]['attendance'],
        absence: maps[i]['absence'],
        late: maps[i]['late'],
        color: maps[i]['color'],
      );
      classDatas[maps[i]['localId'].toString()] = classdata;
    }
    map = new Map<String, ClassData>.from(classDatas);
  }

  Widget _textItem(String week) {
    return Container(
        color: Colors.black87,
        child: Padding(
          padding: EdgeInsets.only(),
          child: Center(
              child: Text(
                week,
                style: TextStyle(color: Colors.white),
              )),
        ));
  }

  Color stringifiedColorToColor(String stringifiedColor) {
    Color reconvertedColor;
    switch (stringifiedColor) {
      case 'red':
        reconvertedColor = Colors.redAccent;
        break;
      case 'pinkAccent':
        reconvertedColor = Colors.pinkAccent;
        break;
      case 'redAccent':
        reconvertedColor = Colors.redAccent;
        break;
      case 'yellowAccent':
        reconvertedColor = Colors.yellowAccent;
        break;
      case 'orangeAccent':
        reconvertedColor = Colors.orangeAccent;
        break;
      case 'lightGreenAccent':
        reconvertedColor = Colors.lightGreenAccent;
        break;
      case 'greenAccent':
        reconvertedColor = Colors.greenAccent;
        break;
      case 'blueAccent':
        reconvertedColor = Colors.blueAccent;
        break;
      case 'indigoAccent':
        reconvertedColor = Colors.indigoAccent;
        break;
      case 'tealAccent':
        reconvertedColor = Colors.teal;
        break;
    }
    return reconvertedColor;
  }

  Widget Body() {
    final userProfile = Provider.of<UserProfile>(context);
    var baseWeeks;
    var baseTime;
    if (widget.numberWeek == 6)
      baseWeeks = [
        _textItem("月"),
        _textItem("火"),
        _textItem("水"),
        _textItem("木"),
        _textItem("金"),
        _textItem("土")
      ];
    else
      baseWeeks = [
        _textItem("Mon"),
        _textItem("Tue"),
        _textItem("Wed"),
        _textItem("Thu"),
        _textItem("Fri")
      ];
    switch (widget.numberClass) {
      case 5:
        baseTime = [
          _textItem("1"),
          _textItem("2"),
          _textItem("3"),
          _textItem("4"),
          _textItem("5")
        ];
        break;
      case 6:
        baseTime = [
          _textItem("1"),
          _textItem("2"),
          _textItem("3"),
          _textItem("4"),
          _textItem("5"),
          _textItem("6")
        ];
        break;
      case 7:
        baseTime = [
          _textItem("1"),
          _textItem("2"),
          _textItem("3"),
          _textItem("4"),
          _textItem("5"),
          _textItem("6"),
          _textItem("7")
        ];
        break;
      case 8:
        baseTime = [
          _textItem("1"),
          _textItem("2"),
          _textItem("3"),
          _textItem("4"),
          _textItem("5"),
          _textItem("6"),
          _textItem("7"),
          _textItem("8")
        ];
        break;
    }

    if (map != null) {
      print(map);
    }

    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return LayoutBuilder(builder: (context, constraints) {
      //タブレット端末を想定（simulatorはipadPro12で調整）
      if (screenWidth > 900 || screenHeight > 900) {
        return Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 40,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 12,
                        child: Padding(
                          padding: EdgeInsets.only(right: 2),
                          child: GridTile(
                            child: Container(
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 111,
                          child: GridView.count(
                            crossAxisCount: widget.numberWeek,
                            children: baseWeeks,
                            //     crossAxisSpacing: 2.0,
                            // 縦スペース
                            //   mainAxisSpacing: 2.0,
                            // 横スペース
                            childAspectRatio: 1.5,
                          ))
                    ],
                  ),
                ),
                Expanded(
                  flex: 645,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 12,
                        child: Padding(
                            padding: EdgeInsets.only(top: 2, right: 2),
                            child: GridView.count(
                              crossAxisCount: 1,
                              crossAxisSpacing: 2.0,
                              // 縦スペース
                              mainAxisSpacing: 2.0,
                              // 横スペース
                              childAspectRatio: 0.578,
                              children: baseTime,
                            )),
                      ),
                      Expanded(
                        flex: 111,
                        child: Padding(
                          padding: EdgeInsets.only(top: 2),
                          child: GridView.count(
                            crossAxisSpacing: 2.0,
                            // 縦スペース
                            mainAxisSpacing: 2.0,
                            // 横スペース
                            crossAxisCount: widget.numberWeek,
                            // childAspectRatio: 1/1.45,
                            childAspectRatio: 0.9,
                            children: List.generate(
                                widget.numberWeek * widget.numberClass, (index) {
                              if (map[index.toString()] == null) {
                                return Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      border: Border.all(color: Colors.grey[300]),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: InkWell(
                                    onTap: () async {
                                      //index%widget.numberWeek
                                      final result = await Navigator.of(context)
                                          .push(MaterialPageRoute(
                                          builder: (context) => ClassePage(
                                              index: 1,
                                              university:
                                              userProfile.university,
                                              numberClass:
                                              index ~/ (widget.numberClass+1),
                                              numberWeek:
                                              index % widget.numberWeek)));
                                      if (result != null)
                                        map[index.toString()] = result;
                                    },
                                  ),
                                );
                              } else {
                                if (map[index.toString()].roomName == "") {
                                  return Container(
                                      decoration: BoxDecoration(
                                          color: stringifiedColorToColor(
                                              map[index.toString()].color),
                                          border: Border.all(
                                            color: stringifiedColorToColor(
                                                map[index.toString()].color),
                                          ),
                                          borderRadius: BorderRadius.circular(5)),
                                      child: InkWell(
                                          onTap: () async {
                                            //index%widget.numberWeek
                                            final result = await Navigator.of(
                                                context)
                                                .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    ClassePage(
                                                        index: 0,
                                                        university: userProfile
                                                            .university,
                                                        data: map[
                                                        index.toString()],
                                                        numberClass: index ~/
                                                            (widget.numberClass+1),
                                                        numberWeek: index %
                                                            widget
                                                                .numberWeek)));
                                            if (result == 1)
                                              map[index.toString()] = null;
                                            else {
                                              if (result != null) {
                                                map[index.toString()] = result;
                                              }
                                            }
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                top: 10, bottom: 10),
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Container(),
                                                Center(
                                                    child: Text(
                                                      map[index.toString()].className,
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(fontSize: 30),
                                                    )),
                                                Container(),
                                              ],
                                            ),
                                          )));
                                } else {
                                  return Container(
                                      decoration: BoxDecoration(
                                          color: stringifiedColorToColor(
                                              map[index.toString()].color),
                                          border: Border.all(
                                            color: stringifiedColorToColor(
                                                map[index.toString()].color),
                                          ),
                                          borderRadius: BorderRadius.circular(5)),
                                      child: InkWell(
                                        onTap: () async {
                                          //index%widget.numberWeek
                                          final result = await Navigator.of(context)
                                              .push(MaterialPageRoute(
                                              builder: (context) => ClassePage(
                                                  index: 0,
                                                  university:
                                                  userProfile.university,
                                                  data: map[index.toString()],
                                                  numberClass: index ~/
                                                      (widget.numberClass+1),
                                                  numberWeek: index %
                                                      widget.numberWeek)));
                                          if (result == 1)
                                            map[index.toString()] = null;
                                          else {
                                            if (result != null) {
                                              map[index.toString()] = result;
                                            }
                                          }
                                        },
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Container(),
                                            Center(
                                                child: Text(
                                                  map[index.toString()].className,
                                                  textAlign: TextAlign.center,
                                                )),
                                            Container(
                                                padding: EdgeInsets.only(
                                                    bottom: 1,
                                                    top: 1,
                                                    right: 4,
                                                    left: 4),
                                                margin: EdgeInsets.only(bottom: 4),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        color: Colors.white),
                                                    borderRadius:
                                                    BorderRadius.circular(10)),
                                                child: Text(
                                                  map[index.toString()].roomName,
                                                  style: TextStyle(fontSize: 20),
                                                )),
                                          ],
                                        ),
                                      ));
                                }
                              }
                            }),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ));
      } else {
        return Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 40,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 12,
                        child: Padding(
                          padding: EdgeInsets.only(right: 2),
                          child: GridTile(
                            child: Container(
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 111,
                          child: GridView.count(
                            crossAxisCount: widget.numberWeek,
                            children: baseWeeks,
                            //     crossAxisSpacing: 2.0,
                            // 縦スペース
                            //   mainAxisSpacing: 2.0,
                            // 横スペース
                            childAspectRatio: 1.5,
                          ))
                    ],
                  ),
                ),
                Expanded(
                  flex: 645,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 12,
                        child: Padding(
                            padding: EdgeInsets.only(top: 2, right: 2),
                            child: GridView.count(
                              crossAxisCount: 1,
                              crossAxisSpacing: 2.0,
                              // 縦スペース
                              mainAxisSpacing: 2.0,
                              // 横スペース
                              childAspectRatio: 36 / 89,
                              children: baseTime,
                            )),
                      ),
                      Expanded(
                        flex: 111,
                        child: Padding(
                          padding: EdgeInsets.only(top: 2),
                          child: GridView.count(
                            crossAxisSpacing: 2.0,
                            // 縦スペース
                            mainAxisSpacing: 2.0,
                            // 横スペース
                            crossAxisCount: widget.numberWeek,
                            //childAspectRatio: 1/1.45,
                            childAspectRatio: 53 / 83,
                            children: List.generate(
                                widget.numberWeek * widget.numberClass, (index) {
                              if (map[index.toString()] == null) {
                                return Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      border: Border.all(color: Colors.grey[300]),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: InkWell(
                                    onTap: () async {
                                      //index%widget.numberWeek
                                      final result = await Navigator.of(context)
                                          .push(MaterialPageRoute(
                                          builder: (context) => ClassePage(
                                              index: 1,
                                              university:
                                              userProfile.university,
                                              numberClass:
                                              index ~/ (widget.numberClass+1),
                                              numberWeek:
                                              index % widget.numberWeek)));
                                      if (result != null)
                                        map[index.toString()] = result;
                                    },
                                  ),
                                );
                              } else {
                                if (map[index.toString()].roomName == "") {
                                  return Container(
                                      decoration: BoxDecoration(
                                          color: stringifiedColorToColor(
                                              map[index.toString()].color),
                                          border: Border.all(
                                            color: stringifiedColorToColor(
                                                map[index.toString()].color),
                                          ),
                                          borderRadius: BorderRadius.circular(5)),
                                      child: InkWell(
                                          onTap: () async {
                                            //index%widget.numberWeek
                                            final result = await Navigator.of(
                                                context)
                                                .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    ClassePage(
                                                        index: 0,
                                                        university: userProfile
                                                            .university,
                                                        data: map[
                                                        index.toString()],
                                                        numberClass: index ~/
                                                            (widget.numberClass+1),
                                                        numberWeek: index %
                                                            widget
                                                                .numberWeek)));
                                            if (result == 1)
                                              map[index.toString()] = null;
                                            else {
                                              if (result != null) {
                                                map[index.toString()] = result;
                                              }
                                            }
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                top: 10, bottom: 10),
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Container(),
                                                Center(
                                                    child: Text(
                                                      map[index.toString()].className,
                                                      textAlign: TextAlign.center,
                                                    )),
                                                Container(),
                                              ],
                                            ),
                                          )));
                                } else {
                                  return Container(
                                      decoration: BoxDecoration(
                                          color: stringifiedColorToColor(
                                              map[index.toString()].color),
                                          border: Border.all(
                                            color: stringifiedColorToColor(
                                                map[index.toString()].color),
                                          ),
                                          borderRadius: BorderRadius.circular(5)),
                                      child: InkWell(
                                        onTap: () async {
                                          //index%widget.numberWeek
                                          final result = await Navigator.of(context)
                                              .push(MaterialPageRoute(
                                              builder: (context) => ClassePage(
                                                  index: 0,
                                                  university:
                                                  userProfile.university,
                                                  data: map[index.toString()],
                                                  numberClass: index ~/
                                                      (widget.numberClass+1),
                                                  numberWeek: index %
                                                      widget.numberWeek)));
                                          if (result == 1)
                                            map[index.toString()] = null;
                                          else {
                                            if (result != null) {
                                              map[index.toString()] = result;
                                            }
                                          }
                                        },
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Container(),
                                            Center(
                                                child: Text(
                                                  map[index.toString()].className,
                                                  textAlign: TextAlign.center,
                                                )),
                                            Container(
                                                padding: EdgeInsets.only(
                                                    bottom: 1,
                                                    top: 1,
                                                    right: 4,
                                                    left: 4),
                                                margin: EdgeInsets.only(bottom: 4),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        color: Colors.white),
                                                    borderRadius:
                                                    BorderRadius.circular(10)),
                                                child: Text(
                                                  map[index.toString()].roomName,
                                                  style: TextStyle(fontSize: 12),
                                                )),
                                          ],
                                        ),
                                      ));
                                }
                              }
                            }),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ));
      }
    });
  }

  void _init() {
    operate();
  }

  void initState() {
    loadingStatus = LoadingStatus.NOTDETERMINED;
    _init();
    super.initState();
  }

  void dispose() {
    super.dispose();
//    print("dispose");
  }

  Widget build(BuildContext context) {
    switch (loadingStatus) {
      case LoadingStatus.DETERMINED:
        return Body();
        break;
      default:
        return Center(child: CircularProgressIndicator());
    }
  }
}