//リストにない授業を登録するページ
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'dart:async';
import 'package:sqflite/sqflite.dart' as sqlite;
import 'package:timetable_app/schedule.dart';
import 'class_data.dart';
class ClassChange extends StatefulWidget {
  int numberClass;
  int numberWeek;
  ClassData beforeclassData;
  ClassChange({
    @required this.beforeclassData,
    @required this.numberClass,
    @required this.numberWeek,
  })  : //assert(numberClass != null),
        //assert(numberWeek != null),
  assert(beforeclassData!=null);

  _ClassChangeState createState() => _ClassChangeState();
}

class _ClassChangeState extends State<ClassChange> {
  final _formKey = GlobalKey<FormState>();
  final classfocus = FocusNode(); //授業名
  final teacherfocus = FocusNode(); //講師名
  final roomfocus = FocusNode(); //教室名
  final codefocus = FocusNode(); //講義コード

  var _class = '';
  var _teacher = '';
  var _room = '';
  var _code = '';
  var _initclass = '';
  var _initteacher = '';
  var _initroom = '';
  var _initcode = '';
  void _updateClass(String className) {
    setState(() {
      _class = className;
    });
  }

  void _updateTeacher(String teacher) {
    setState(() {
      _teacher = teacher;
    });
  }

  void _updateRoom(String room) {
    setState(() {
      _room = room;
    });
  }

  void _updateCode(String code) {
    if(code!=null)
      setState(() {
        _code = code;
      });
  }

  TextFormField classFormField(BuildContext context) {
    return TextFormField(
      initialValue: _initclass,
      focusNode: classfocus,
      decoration: InputDecoration(
        labelText: "授業名(必須)",
        hintText: "正式名称を記入してください",
        icon: Icon(Icons.edit),
      ),
      validator: (value) {
        if (value.isEmpty) {
          return '必須項目です。';
        }
      },
      onSaved: (value) {
        _updateClass(value);
      },
    );
  }

  TextFormField teacherFormField(BuildContext context) {
    return TextFormField(
      initialValue: _initteacher,
      focusNode: teacherfocus,
      decoration: InputDecoration(
        labelText: "教員名(任意)",
        hintText: "教員名(なるべくフルネーム)",
        icon: Icon(Icons.person_outline),
      ),
      onSaved: (value) {
        _updateTeacher(value);
      },
    );
  }

  TextFormField roomFormField(BuildContext context) {
    return TextFormField(
      initialValue: _initroom,
      focusNode: roomfocus,
      decoration: InputDecoration(
        labelText: "教室名(任意)",
        hintText: "正式名称を記入してください",
        icon: Icon(Icons.room),
      ),
      onSaved: (value) {
        _updateRoom(value);
      },
    );
  }

  TextFormField codeFormField(BuildContext context) {
    return TextFormField(
      initialValue: _initcode,
      focusNode: codefocus,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: "講義コード(任意)",
        hintText: "正式に記入してください(数字8桁)",
        icon: Icon(Icons.format_list_numbered),
      ),
      validator: (value) {
        if (value.isNotEmpty && value.length != 8) {
          return '講義コードは数字8桁です。';
        }
      },
      onSaved: (value) {
        _updateCode(value);
      },
    );
  }
  Future<sqlite.Database> database;
  void initState(){
    _initclass=widget.beforeclassData.className;
    _initcode=widget.beforeclassData.classCode;
    _initroom=widget.beforeclassData.roomName;
    _initteacher=widget.beforeclassData.teacherName;
    _openDatabase();
    super.initState();
  }
  void _openDatabase() async{
    database=sqlite.openDatabase(
      path.join(await sqlite.getDatabasesPath(),'ajj.db'),
      version: 1,
    ) ;
  }
  List<String> baseWeeks = ["Mon","Tue","Wed","Thu","Fri","Sat"];
  List<String> baseTime = ["1st","2nd","3rd","4th","5th","6th","7th","8th"];
  Future<void> Insertclassdata(ClassData classDate) async {
    final sqlite.Database db = await database;
    await db.insert(
      'classdata',
      classDate.toMap(),
      conflictAlgorithm: sqlite.ConflictAlgorithm.replace,
    );
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
  Widget build(BuildContext context){

    return Scaffold(
        resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          backgroundColor: stringifiedColorToColor(widget.beforeclassData.color),
          title: Text(
            baseWeeks[widget.numberWeek]+" "+baseTime[widget.numberClass]+"period",
          ),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      Text("授業を更新します。"),
                      Text("更新した授業は、他のユーザーにも共有されます。")
                    ],
                  ),
                ),
                Container(
                  height: 90,
                  margin: EdgeInsets.only(left:10.0,right: 10.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: classFormField(context),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 90,
                  margin: EdgeInsets.only(left:10.0,right: 10.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: teacherFormField(context),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 90,
                  margin: EdgeInsets.only(left:10.0,right: 10.0),
                  child: Row(
                    children: <Widget>[Expanded(child: roomFormField(context))],
                  ),
                ),
                Container(
                  height: 90,
                  margin: EdgeInsets.only(left:10.0,right: 10.0),
                  child: Row(
                    children: <Widget>[Expanded(child: codeFormField(context))],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: RaisedButton(
                    color: Colors.lightBlue,
                    // 送信ボタンクリック時の処理
                    onPressed: () {
                      // バリデーションチェック
                      if (_formKey.currentState.validate()) {
                        // 各フォームのonSavedに記述した処理を実行
                        // このsave()を呼び出さないと、onSavedは実行されないので注意
                        _formKey.currentState.save();
                        /*if(_teacher=="")_teacher=null;
                      if(_room=="")_room=null;
                      if(_code=="")_code=null;
                      if(_teacher=="")_teacher=null;*/
                        ClassData classdata =ClassData(
                            id: (widget.numberClass*6+widget.numberWeek),
                            week: widget.numberWeek,
                            time: widget.numberClass,
                            className: _class,
                            teacherName: _teacher,
                            roomName: _room,
                            classCode: _code,
                            color: widget.beforeclassData.color,
                            absence: 0,
                            late:  0,
                            attendance: 0);
                        Insertclassdata(classdata);
                        Navigator.of(context).pop(classdata);
                      }
                    },
                    child: Text('更新する',style: TextStyle(color: Colors.white),),
                  ),
                ),
              ],
            ),
          ),
        ));}
}
