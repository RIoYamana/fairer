//時間割ページ
import 'package:flutter/material.dart';
import 'classPage.dart';
import 'class_data.dart';
import 'package:path/path.dart' as path;
import 'dart:async';
import 'package:sqflite/sqflite.dart';

class Table extends StatefulWidget {
  //デフォ 5限の金曜日まで
  final int numberClass = 5; //5限の場合5
  final int numberWeek = 6; //土曜日なし5(月～金)土曜あり6(月～土)
  Table({Key key}):super(key:key);

  _TableState createState() => _TableState();
}
class _TableState extends State<Table> with RouteAware{
  Map<String,ClassData> map;
  @override
  int count=0;
  void operate()async {
    final Future<Database> database = openDatabase(
      path.join(await getDatabasesPath(), 'ajj.db'),
      onCreate: (db, version) {
        return db.execute(
            " CREATE TABLE classdata (id INTEGER PRIMARY KEY, week INTEGER,time INTEGER,className TEXT,teacherName TEXT,roomName TEXT,classCode TEXT,attendance INTEGER,absence INTEGER,late INTEGER,color TEXT) ",
        );
      },
      version: 1,
    );
    Future<void> insertClassData(ClassData data) async {
      final Database db = await database;
      await db.insert(
        'classdata',
        data.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    void _getClassData() async {
      final Database db = await database;
      final List<Map<String, dynamic>> maps = await db.query('classdata');
      Map<String, ClassData> classDatas = Map<String, ClassData>();
      ClassData classdata;
      for (int i = 0; i < maps.length; i++) {
        classdata = ClassData(
          id: maps[i]['id'],
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
        classDatas[maps[i]['id'].toString()] = classdata;
      }
      map = classDatas;
      print(map);
    }
    await _getClassData();
    //deleteClass();
  }

  Widget _textItem(String week) {
    return Container(
      color: Colors.black87,
      child:Padding(
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
        reconvertedColor=Colors.redAccent;
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

    return Container(
        //child: Padding(
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
                        child:Padding(
                          padding: EdgeInsets.only(right: 2),
                        child: GridTile(
                            child:Container(
                              color: Colors.black87,
                            ),
                        ),),
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
                          child:Padding(
                            padding: EdgeInsets.only(top: 2,right: 2),
                          child: GridView.count(
                            crossAxisCount: 1,
                            crossAxisSpacing: 2.0,
                            // 縦スペース
                            mainAxisSpacing: 2.0,
                            // 横スペース
                            childAspectRatio: 36/89,
                            children: baseTime,
                          )),),
                      Expanded(
                        flex: 111,
                        child:Padding(
                          padding: EdgeInsets.only(top: 2),
                        child: GridView.count(
                          crossAxisSpacing: 2.0,
                          // 縦スペース
                          mainAxisSpacing: 2.0,
                          // 横スペース
                          crossAxisCount: widget.numberWeek,
                          //childAspectRatio: 1/1.45,
                          childAspectRatio: 53 /83,
                          children: List.generate(
                              widget.numberWeek * widget.numberClass, (index) {
                            if (map[index.toString()]==null){
                              return Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    border: Border.all(color: Colors.grey[300]),
                                    borderRadius: BorderRadius.circular(5)
                                ),
                                child: InkWell(
                                  onTap: () async{
                                    //index%widget.numberWeek
                                    final result = await Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ClassePage(
                                                    index: 1,
                                                    numberClass:
                                                    index ~/ widget.numberClass,
                                                    numberWeek: index %
                                                        widget.numberWeek)));
                                    if(result!=null)
                                      map[index.toString()] = result;
                                  },
                                ),
                              );
                            }
                            else{
                              if(map[index.toString()].roomName==""){
                              return Container(
                                decoration: BoxDecoration(
                                  color: stringifiedColorToColor(map[index.toString()].color),
                                border: Border.all(color: stringifiedColorToColor(map[index.toString()].color),),
                                  borderRadius: BorderRadius.circular(5)
                                ),
                                  child: InkWell(
                                      onTap: () async{
                                        //index%widget.numberWeek
                                        final result = await Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ClassePage(
                                                        index: 0,
                                                        data: map[
                                                        index.toString()],
                                                        numberClass: index ~/
                                                            widget.numberClass,
                                                        numberWeek: index %
                                                            widget
                                                                .numberWeek)));
                                        if(result==1)
                                          map[index.toString()]=null;
                                        else{
                                          if(result!=null){
                                            map[index.toString()]=result;
                                          }}

                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            top: 10, bottom: 10),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Container(),
                                            Center(
                                                child: Text(
                                                  map[index.toString()]
                                                      .className,
                                                  textAlign: TextAlign.center,
                                                )),
                                            Container(),
                                          ],
                                        ),
                                      )));}
                              else{
                                return Container(
                                    decoration: BoxDecoration(
                                        color: stringifiedColorToColor(map[index.toString()].color),
                                        border: Border.all(color: stringifiedColorToColor(map[index.toString()].color),),
                                        borderRadius: BorderRadius.circular(5)
                                    ),
                                    child: InkWell(
                                        onTap: () async{
                                          //index%widget.numberWeek
                                          final result = await Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ClassePage(
                                                          index: 0,
                                                          data: map[
                                                          index.toString()],
                                                          numberClass: index ~/
                                                              widget.numberClass,
                                                          numberWeek: index %
                                                              widget
                                                                  .numberWeek)));
                                          if(result==1)
                                            map[index.toString()]=null;
                                          else{
                                            if(result!=null){
                                              map[index.toString()]=result;
                                            }}
                                          },
                                      child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Container(),
                                              Center(
                                                  child: Text(
                                                    map[index.toString()]
                                                        .className,
                                                    textAlign: TextAlign.center,
                                                  )),
                                              Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.all(color: Colors.white),
                                                      borderRadius: BorderRadius.circular(5)
                                                  ),
                                                  child:Text(map[index.toString()].roomName,
                                                  )),
                                            ],
                                          ),
                                        ));
                              }
                          }}),
                        ),),
                        ),
                    ],
                  ),
                )
              ],
            ));
  }
  void _init() async {
    map = Map<String, ClassData>();
    await operate();
  }
  void initState() {
    _init();
    super.initState();

    count=1;
  }
  void dispose() {
    super.dispose();
    print("dispose");
  }
  Widget build(BuildContext context) {
    //if(widget.numberClass==widget.numberWeek)
    return Body();
  }
}
