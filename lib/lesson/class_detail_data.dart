//授業の詳細ページ
import 'package:flutter/material.dart';
import 'class_data.dart';
import 'package:path/path.dart' as path;
import 'dart:async';
import 'class_attendance.dart';
import 'class_change_data.dart';
import 'package:sqflite/sqflite.dart' as sqlite;
class ClassDetailDate extends StatefulWidget {
  ClassData data;

  ClassDetailDate({this.data});

  _ClassDetailDateState createState() => _ClassDetailDateState();
}

class _ClassDetailDateState extends State<ClassDetailDate> {
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
  List<String> baseWeeks = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
  List<String> baseTime = [
    "1st",
    "2nd",
    "3rd",
    "4th",
    "5th",
    "6th",
    "7th",
    "8th"
  ];
  Color _color;
  Future<sqlite.Database> database;
  ClassData _classdata;
  void initState(){
    _openDatabase();
    _color=stringifiedColorToColor(widget.data.color);
    _classdata=widget.data;
    super.initState();
  }
  void _openDatabase() async{
    database=sqlite.openDatabase(
      path.join(await sqlite.getDatabasesPath(),'ajj.db'),
      version: 1,
    ) ;
  }
  Future<void> _deleteDatabase(int id)async{
    final db =await database;
    await db.delete(
      'classdata',
      where: "id=?",
      whereArgs: [id],
    );
  }
  void _delatedata(int id)async{
    _deleteDatabase(id);
  }
  Future <void> updateClass(ClassData data) async{
    final db =await database;
    await db.update(
      'classdata',
      data.toMap(),
      where:  "id=?",
      whereArgs:  [data.id],
      conflictAlgorithm: sqlite.ConflictAlgorithm.fail,
    );
  }
  void _changeColor(String newcolor) async{
    _classdata=ClassData(
        id: _classdata.id,
        week: _classdata.week,
        time: _classdata.time,
        className: _classdata.className,
        teacherName: _classdata.teacherName,
        roomName: _classdata.roomName,
        classCode: _classdata.classCode,
        color: newcolor,
        absence: _classdata.absence,
        late:  _classdata.late,
        attendance:_classdata.attendance,
    );
    await updateClass(_classdata);
    Navigator.of(context).pop(_classdata);
  }
  int _reslut=0;
  String _colorResult;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          baseWeeks[widget.data.week] +
              " " +
              baseTime[widget.data.time] +
              " period",
        ),
        backgroundColor: _color,
        /*actions: <Widget>[
          IconButton(icon: Icon(Icons.edit), onPressed: (){
              },)
        ],*/
        elevation: 0.0,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: 120,
                color: _color,
                child: Padding(
                  padding: EdgeInsets.only(left: 20, top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(widget.data.classCode.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 15)),
                      Text(
                        widget.data.className,
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      ),
                      Text(
                        widget.data.teacherName + "   " + widget.data.roomName,
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 40,
                color: Colors.grey[300],
                child: Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "記録",
                        style: TextStyle(fontSize: 17),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 50,
                child: InkWell(
                  onTap: () async{
                    final result = await Navigator.of(context).push(
                        MaterialPageRoute(
                      builder: (context) =>ClassAttendance(data: widget.data)
                  ));
                    if(result!=null)
                      Navigator.of(context).pop(result);
                      },
                  child: Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(Icons.check),
                            Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Text("出欠"),
                            )
                          ],
                        ),
                        Icon(Icons.arrow_forward_ios)
                      ],
                    ),
                  ),
                ),
              ),
              Divider(
                color: Colors.grey,
              ),
              Container(
                height: 50,
                child: InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(Icons.message),
                            Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Text("メモ"),
                            )
                          ],
                        ),
                        Icon(Icons.arrow_forward_ios)
                      ],
                    ),
                  ),
                ),
              ),
              Divider(
                color: Colors.grey,
              ),
              Container(
                height: 50,
                child: InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(Icons.library_books),
                            Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Text("シラバス"),
                            )
                          ],
                        ),
                        Icon(Icons.arrow_forward_ios)
                      ],
                    ),
                  ),
                ),
              ),
              Divider(
                color: Colors.grey,
              ),
              Container(
                height: 50,
                child: InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(Icons.dialer_sip),
                            Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Text("休講情報"),
                            )
                          ],
                        ),
                        Icon(Icons.arrow_forward_ios)
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: 40,
                color: Colors.grey[300],
                child: Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "編集",
                        style: TextStyle(fontSize: 17),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 50,
                child: InkWell(
                  onTap: () async{
                    final result = await Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) =>
                                ClassChange(
                                    numberClass:
                                    widget.data.time,
                                    numberWeek: widget.data.week,
                                beforeclassData: widget.data,)));
                    if(result!=null){
                      Navigator.of(context).pop(result);
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(Icons.edit),
                            Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Text("授業内容を編集"),
                            )
                          ],
                        ),
                        Icon(Icons.arrow_forward_ios)
                      ],
                    ),
                  ),
                ),
              ),
              Divider(
                color: Colors.grey,
              ),
              Container(
                height: 50,
                child: InkWell(
                  onTap: () async {
                    var result = await showDialog<int>(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return SimpleDialog(
                          children: <Widget>[
                            Column(children: <Widget>[
                              Row(
                                children: <Widget>[
                                  SimpleDialogOption(
                                    child: Container(
                                      width: 60,
                                      height: 60,
                                      child: MaterialButton(
                                        shape: CircleBorder(
                                            side: BorderSide(
                                                width: 2,
                                                color: Colors.redAccent,
                                                style: BorderStyle.solid)),
                                        color: Colors.redAccent,
                                        onPressed: () {
                                          setState(() {
                                            _color=Colors.redAccent;
                                            _colorResult="redAccent";
                                            _changeColor("redAccent");
                                          });
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                  ),
                                  SimpleDialogOption(
                                    onPressed: () => Navigator.pop(context, 1),
                                    child: Container(
                                      width: 60,
                                      height: 60,
                                      child: MaterialButton(
                                        shape: CircleBorder(
                                            side: BorderSide(
                                                width: 2,
                                                color: Colors.pinkAccent,
                                                style: BorderStyle.solid)),
                                        color: Colors.pinkAccent,
                                        onPressed: () {
                                          setState(() {
                                            _color=Colors.pinkAccent;
                                            _colorResult="pinkAccent";
                                          });
                                          _changeColor("pinkAccent");
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                  ),
                                  SimpleDialogOption(
                                    child: Container(
                                      width: 60,
                                      height: 60,
                                      child: MaterialButton(
                                        shape: CircleBorder(
                                            side: BorderSide(
                                                width: 2,
                                                color: Colors.orangeAccent,
                                                style: BorderStyle.solid)),
                                        color: Colors.orangeAccent,
                                        onPressed: () {
                                          setState(() {
                                            _color=Colors.orangeAccent;
                                            _colorResult="orangeAccent";
                                          });
                                          _changeColor("orangeAccent");
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  SimpleDialogOption(
                                    child: Container(
                                      width: 60,
                                      height: 60,
                                      child: MaterialButton(
                                        shape: CircleBorder(
                                            side: BorderSide(
                                                width: 2,
                                                color: Colors.yellowAccent,
                                                style: BorderStyle.solid)),
                                        color: Colors.yellowAccent,
                                        onPressed: () {
                                          setState(() {
                                            _color=Colors.yellowAccent;
                                            _colorResult="yellowAccent";
                                          });
                                          _changeColor("yellowAccent");
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                  ),
                                  SimpleDialogOption(
                                    child: Container(
                                      width: 60,
                                      height: 60,
                                      child: MaterialButton(
                                        shape: CircleBorder(
                                            side: BorderSide(
                                                width: 2,
                                                color: Colors.lightGreenAccent,
                                                style: BorderStyle.solid)),
                                        color: Colors.lightGreenAccent,
                                        onPressed: () {
                                          setState(() {
                                            _color=Colors.lightGreenAccent;
                                            _colorResult="lightGreenAccent";
                                          });
                                          _changeColor("lightGreenAccent");
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                  ),
                                  SimpleDialogOption(

                                    child: Container(
                                      width: 60,
                                      height: 60,
                                      child: MaterialButton(
                                        shape: CircleBorder(
                                            side: BorderSide(
                                                width: 2,
                                                color: Colors.greenAccent,
                                                style: BorderStyle.solid)),
                                        color: Colors.greenAccent,
                                        onPressed: () {
                                          setState(() {
                                            _color=Colors.greenAccent;
                                            _colorResult="greenAccent";
                                          });
                                          _changeColor("greenAccent");
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  SimpleDialogOption(
                                    child: Container(
                                      width: 60,
                                      height: 60,
                                      child: MaterialButton(
                                        shape: CircleBorder(
                                            side: BorderSide(
                                                width: 2,
                                                color: Colors.blueAccent,
                                                style: BorderStyle.solid)),
                                        color: Colors.blueAccent,
                                        onPressed: () {
                                          setState(() {
                                            _color=Colors.blueAccent;
                                            _colorResult="blueAccent";
                                          });
                                          _changeColor("blueAccent");
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                  ),
                                  SimpleDialogOption(
                                    child: Container(
                                      width: 60,
                                      height: 60,
                                      child: MaterialButton(
                                        shape: CircleBorder(
                                            side: BorderSide(
                                                width: 2,
                                                color: Colors.indigoAccent,
                                                style: BorderStyle.solid)),
                                        color: Colors.indigoAccent,
                                        onPressed: () {
                                          setState(() {
                                            _color=Colors.indigoAccent;
                                            _colorResult="indigoAccentt";
                                          });
                                          _changeColor("indigoAccent");
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                  ),
                                  SimpleDialogOption(
                                    child: Container(
                                      width: 60,
                                      height: 60,
                                      child: MaterialButton(
                                        shape: CircleBorder(
                                            side: BorderSide(
                                                width: 2,
                                                color: Colors.teal,
                                                style: BorderStyle.solid)),
                                        color: Colors.teal,
                                        onPressed: () {
                                          setState(() {
                                            _color=Colors.teal;
                                            _colorResult="tealAccent";
                                          });
                                          _changeColor("tealAccent");
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SimpleDialogOption(
                                onPressed: () => Navigator.pop(context, 2),
                                child: const Text('キャンセル'),
                              ),
                            ])
                          ],
                        );
                      },
                    );
                    /*if(_colorResult!=null)
                      Navigator.of(context).pop(_colorResult);*/
                    // --
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(Icons.color_lens),
                            Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Text("色を変える"),
                            )
                          ],
                        ),
                        Icon(Icons.arrow_forward_ios)
                      ],
                    ),
                  ),
                ),
              ),
              Divider(
                color: Colors.grey,
              ),
              Container(
                margin: EdgeInsets.only(bottom: 30),
                height: 50,
                child: InkWell(
                  onTap: () async {
                    // ダイアログを表示------------------------------------
                    var result = await showDialog<int>(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Text('この授業を外してよろしいですか?'),
                          actions: <Widget>[
                            FlatButton(
                                child: Text('Cancel'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                }),
                            FlatButton(
                                child: Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  _delatedata(_classdata.id);
                                  _reslut=1;
                                }),
                          ],
                        );
                      },
                    );
                    if(_reslut==1)
                      Navigator.of(context).pop(1);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(Icons.remove_circle_outline),
                            Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Text("授業をコマから外す"),
                            )
                          ],
                        ),
                        Icon(Icons.arrow_forward_ios)
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
