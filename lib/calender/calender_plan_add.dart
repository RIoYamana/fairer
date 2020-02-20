//リストにない授業を登録するページ
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart' as sqlite;
import 'calender_data.dart';

class CalenderAdd extends StatefulWidget {
  Map<String,List<CalenderData>> map=Map<String,List<CalenderData>>();
  CalenderAdd({@required this.map});
  _CalenderAddState createState() => _CalenderAddState();
}

class _CalenderAddState extends State<CalenderAdd> {
  final _formKey = GlobalKey<FormState>();
  final planfocus = FocusNode(); //予定
  /*final startTimefocus = FocusNode(); //始める日
  final endTimefocus = FocusNode(); //始める時間
  final startDayfocus = FocusNode(); //終わりの時間
  final endDayfocus = FocusNode(); //終わりの日*/
  var _plan = '';
  var _sday=(DateFormat.d()).format(DateTime.now());
  var _eday=(DateFormat.d()).format(DateTime.now());
  var _startTime = DateTime
      .now()
      .hour
      .toString() + ":" + DateTime
      .now()
      .minute
      .toString();
  var _endTime = DateTime
      .now()
      .hour
      .toString() + ":" + DateTime
      .now()
      .minute
      .toString();
  var _startselected = DateTime.now();
  var _startDay = (DateFormat.yMd()).format(DateTime.now());
  var _endDay = (DateFormat.yMd()).format(DateTime.now());
  List<Color> _color = [
    Color(0xFFA0C6F2),
    Color(0xFFF0BBBA),
    Color(0xFF8BEBB7),
    Color(0xFFFFFB90),
  ];
  List<Color> _colorcircle = [
  Colors.black87,
  Color(0xFFF0BBBA),
  Color(0xFF8BEBB7),
    Color(0xFFFFFB90),
  ];
  String converterColor(Color beColor){
    if(beColor==Color(0xFFA0C6F2))
      return "0xFFA0C6F2";
    if(beColor==Color(0xFFF0BBBA))
      return "0xFFF0BBBA";
    if(beColor==Color(0xFF8BEBB7))
      return "0xFF8BEBB7";
    if(beColor==Color(0xFFFFFB90))
      return "0xFFFFFB90";
  }
  int _colorHilight=0;
  void _updatePlan(String plan) {
    setState(() {
      _plan = plan;
    });
  }

  void _updateStartTime(String startTime) {
    setState(() {
      _startTime = startTime;
    });
  }

  void _updateStartDay(String startDay) {
    setState(() {
      _startDay = startDay;
    });
  }

  void _updateEndTime(String endTime) {
    setState(() {
      _endTime = endTime;
    });
  }

  void _updateEndDay(String endDay) {
    setState(() {
      _endDay = endDay;
    });
  }
  var _id=(DateFormat.yMd()).format(DateTime.now());
  Future<void> _selectstartDate(BuildContext context) async {
    final DateTime selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2022),
    );
    if (selected != null) {
      setState(() {
        _startselected = selected;
        _startDay = (DateFormat.Md()).format(selected);
        _id=(DateFormat.yMd()).format(selected);
        _sday=(DateFormat.d()).format(selected);
      });
      print(_id);
    }
  }

  Future<void> _selectendDate(BuildContext context) async {
    final DateTime selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2022),
    );
    if (selected != null) {
      setState(() {
        if (_startselected.day > selected.day) {
          _startDay = (DateFormat.Md()).format(selected);
          _sday=(DateFormat.d()).format(selected);
          _id=(DateFormat.yMd()).format(selected);
        }
        _endDay = (DateFormat.Md()).format(selected);
        _eday=(DateFormat.d()).format(selected);
      });
    }
  }

  Widget startTimehour(BuildContext context) {
    return TextFormField(
      focusNode: planfocus,
      decoration: InputDecoration(
        labelText: "新しい予定",
        hintText: "予定を記入してください",
        icon: Icon(Icons.card_travel),
      ),
      validator: (value) {
        if (value.isEmpty) {
          return '必須項目です。';
        }
      },
      onSaved: (value) {
        _updatePlan(value);
      },
    );
  }

  TextFormField planFormField(BuildContext context) {
    return TextFormField(
      focusNode: planfocus,
      decoration: InputDecoration(
        labelText: "新しい予定",
        hintText: "予定を記入してください",
        icon: Icon(Icons.card_travel),
      ),
      validator: (value) {
        if (value.isEmpty) {
          return '必須項目です。';
        }
      },
      onSaved: (value) {
        _updatePlan(value);
      },
    );
  }

  Future<sqlite.Database> database;
  void _init() async{
    await _openDatabase();
  }
  void initState() {
    _init();
    selected=DateTime.now();
    super.initState();
    _startTime = DateTime
        .now()
        .hour
        .toString() + ":" + DateTime
        .now()
        .minute
        .toString();
    _endTime = DateTime
        .now()
        .hour
        .toString() + ":" + DateTime
        .now()
        .minute
        .toString();
  }

  void _openDatabase() async {
    database = sqlite.openDatabase(
      path.join(await sqlite.getDatabasesPath(), 'calender6.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE calenderplan (id TEXT KEY,number INTEGER, plan TEXT,day INTEGER,month INTEGER,year INTEGER,startTime TEXT,sday INTEGER,eday INTEGER,startDay TEXT,endDay TEXT,endTime TEXT,color TEXT) ",
        );
      },
      version: 1,
    );
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
  Future<void> Insertcalenderdata(CalenderData calenderDate) async {
    final sqlite.Database db = await database;
    await db.insert(
      'calenderplan',
      calenderDate.toMap(),
      conflictAlgorithm: sqlite.ConflictAlgorithm.replace,
    );
  }

  var _labelText;
  DateTime selectedDate = DateTime.now();
DateTime selected=DateTime.now();
  Future<Null> _selectStartTime(BuildContext context) async {
    final TimeOfDay t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (t != null) {
      var dt = _toDateTime(t);
      selected=_toDateTime(t);
      setState(() {
        _startTime = (DateFormat.Hm()).format(dt);
      });
    }
  }

  Future<Null> _selectEndTime(BuildContext context) async {
    final TimeOfDay t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (t != null) {
      var dt = _toDateTime(t);
      setState(() {
        _endTime = (DateFormat.Hm()).format(dt);
      });
    }
  }

  _toDateTime(TimeOfDay t) {
    var now = DateTime.now();
    return DateTime(
        now.year, now.month, now.day,
        t.hour, t.minute);
  }

  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: true,
        body: Form(
          key: _formKey,
          child: Padding(
              padding: EdgeInsets.only(top: 80),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 90,
                      margin: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: planFormField(context),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 90,
                      margin: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Row(
                        children: <Widget>[
                          Text("開始日時"),
                          IconButton(
                            icon: Icon(Icons.calendar_today),
                            onPressed: () => _selectstartDate(context),
                          ),
                          InkWell(
                            onTap: () => _selectstartDate(context),
                            child: Text(_startDay),),
                          IconButton(
                            icon: Icon(Icons.timer),
                            onPressed: () => _selectStartTime(context),
                          ),
                          InkWell(
                            onTap: () => _selectStartTime(context),
                            child: Text(_startTime),),
                        ],
                      ),
                    ),
                    Container(
                      height: 90,
                      margin: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Row(
                        children: <Widget>[
                          Text("終了日時"),
                          IconButton(
                            icon: Icon(Icons.calendar_today),
                            onPressed: () => _selectendDate(context),
                          ),
                          InkWell(
                            onTap: () => _selectendDate(context),
                            child: Text(_endDay),),
                          IconButton(
                            icon: Icon(Icons.timer),
                            onPressed: () => _selectEndTime(context),
                          ),
                          InkWell(
                            onTap: () => _selectEndTime(context),
                            child: Text(_endTime),)
                        ],
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Row(
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.all(5),
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  child: MaterialButton(
                                    shape: CircleBorder(
                                        side: BorderSide(
                                            width: 2,
                                            color: _colorcircle[0],
                                            style: BorderStyle.solid)),
                                    color: _color[0],
                                    onPressed: () {
                                      setState(() {
                                        _colorcircle[0]=Colors.black87;
                                        _colorHilight=0;
                                        for(int i=0;i<3;i++){
                                          if(i!=0)
                                            _colorcircle[i]=_color[i];
                                        }
                                        //_color=Colors.redAccent;
                                        //_changeColor("redAccent");
                                      });
                                      //Navigator.pop(context);
                                    },
                                  ),
                                )),
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: Container(
                                width: 40,
                                height: 40,
                                child: MaterialButton(
                                  shape: CircleBorder(
                                      side: BorderSide(
                                          width: 2,
                                          color: _colorcircle[1],
                                          style: BorderStyle.solid)),
                                  color: _color[1],
                                  onPressed: () {
                                    setState(() {
                                      //_color=Colors.redAccent;
                                      //_changeColor("redAccent");
                                      _colorcircle[1]=Colors.black87;
                                      _colorHilight=1;
                                      for(int i=0;i<3;i++){
                                        if(i!=1)
                                          _colorcircle[i]=_color[i];
                                      }
                                    });
                                    //Navigator.pop(context);
                                  },
                                ),
                              ),),
                            /*Padding(
                              padding: EdgeInsets.all(5),
                              child: Container(
                                width: 40,
                                height: 40,
                                child: MaterialButton(
                                  shape: CircleBorder(
                                      side: BorderSide(
                                          width: 2,
                                          color: _color[2],
                                          style: BorderStyle.solid)),
                                  color: _color[2],
                                  onPressed: () {
                                    setState(() {
                                      //_color=Colors.redAccent;
                                      //_changeColor("redAccent");
                                    });
                                    Navigator.pop(context);
                                  },
                                ),
                              ),),*/
                            Padding(
                              padding: EdgeInsets.all(5),
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  child: MaterialButton(
                                    shape: CircleBorder(
                                        side: BorderSide(
                                            width: 2,
                                            color: _colorcircle[2],
                                            style: BorderStyle.solid)),
                                    color: _color[2],
                                    onPressed: () {
                                      setState(() {
                                        _colorcircle[2]=Colors.black87;
                                        _colorHilight=2;
                                        for(int i=0;i<3;i++){
                                          if(i!=2)
                                            _colorcircle[i]=_color[i];
                                        }
                                        //_color=Colors.redAccent;
                                        //_changeColor("redAccent");
                                      });
                                      //Navigator.pop(context);
                                    },
                                  ),
                                )),
                          ],
                        )),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: RaisedButton(
                        color: Colors.lightBlue,
                        // 送信ボタンクリック時の処理
                        onPressed: () {
                          // バリデーションチェック
                          if (_formKey.currentState.validate()) {
                            int _number;
                            if(widget.map[_id]!=null){
                              _number=selected.year*100000+selected.month*1000+selected.day*10+widget.map[_id].length;
                            }
                            else
                              _number=selected.year*100000+selected.month*1000+selected.day*10;
                            print(_number);
                            // 各フォームのonSavedに記述した処理を実行
                            // このsave()を呼び出さないと、onSavedは実行されないので注意
                            _formKey.currentState.save();
                            CalenderData calenderDate=CalenderData(
                                id:_id.toString(),
                                number: _number,
                                plan:_plan,

                                day:selected.day,
                                month:selected.month,
                                year: selected.year,
                                sday: int.parse(_sday),
                                eday: int.parse(_eday),
                                startTime:_startTime,
                                startDay:_startDay,
                                endTime:_endTime,
                                endDay:_endDay,
                                color:converterColor(_color[_colorHilight]));
                            Insertcalenderdata(calenderDate);
                            if(widget.map[_id]==null)
                              widget.map[_id]=[];
                            if(int.parse(_sday)==int.parse(_eday)){
                              widget.map[_id].add(calenderDate);
                            Navigator.of(context).pop(widget.map);
                            }else{
                              CalenderData calenderDate=CalenderData(
                                  id:_id.toString(),
                                  number: _number,
                                  plan:_plan,
                                  day:selected.day,
                                  month:selected.month,
                                  year: selected.year,
                                  sday: int.parse(_sday),
                                  eday: int.parse(_eday),
                                  startTime:_startTime,
                                  startDay:_startDay,
                                  endTime:'↓',
                                  endDay:_endDay,
                                  color:converterColor(_color[_colorHilight]));
                              widget.map[_id].add(calenderDate);
                              int k=0;
                              while ( int.parse(_eday)- int.parse(_sday) - k > 0) {
                                k++; //number.add(maps[i]['sday'] + k);
                                if(int.parse(_eday)- int.parse(_sday) - k+1==1){
                                  calenderDate = CalenderData(
                                      id:_id.toString(),
                                      number: _number,
                                      plan:_plan,
                                      day:selected.day,
                                      month:selected.month,
                                      year: selected.year,
                                      sday: int.parse(_sday),
                                      eday: int.parse(_eday),
                                      startTime:_startTime,
                                      startDay:_startDay,
                                      endTime:'↑',
                                      endDay:_endDay,
                                      color:converterColor(_color[_colorHilight]));
                                }else{
                                  calenderDate = CalenderData(
                                      id:_id.toString(),
                                      number: _number,
                                      plan:_plan,
                                      day:selected.day,
                                      month:selected.month,
                                      year: selected.year,
                                      sday: int.parse(_sday),
                                      eday: int.parse(_eday),
                                      startTime:'終日',
                                      startDay:_startDay,
                                      endTime:'',
                                      endDay:_endDay,
                                      color:converterColor(_color[_colorHilight]));
                                }
                                String iid=(selected.month).toString()+'/'+(int.parse(_sday)+k).toString()+'/'+(selected.year).toString();
                                if (widget.map[iid] == null)
                                  widget.map[iid] = [];
                                print(iid);
                                (widget.map[iid]).add(calenderDate);
                              }
                              Navigator.of(context).pop(widget.map);
                            }

                          }
                        },
                        child: Text(
                          '登録する',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),)),
        ));
  }
}
