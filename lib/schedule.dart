import 'package:flutter/material.dart';
import 'package:timetable_app/lesson/timeTablePage.dart' as prefix0;
import 'calender/calender_base.dart';
class Schedule extends StatefulWidget {
  Schedule();

  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  var _selectedValue = '時間割';
  var _usState = ["時間割", "カレンダー"];
  Widget build(BuildContext context) =>
      Scaffold(
        appBar: AppBar(
          leading: PopupMenuButton<String>(
            initialValue: _selectedValue,
            onSelected: (String s){
              setState(() {
                _selectedValue = s;
                if(s=="カレンダー")
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Sample()));
              });
            },
            itemBuilder: (BuildContext context){
              return _usState.map((String s){
                return PopupMenuItem(
                    child: Text(s),
                  value: s,
                );
              }).toList();
            },
          ),
          title: Text(""),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.settings), onPressed: () {}),
            IconButton(icon: Icon(Icons.add), onPressed: () {}),
          ],
        ),
        body: prefix0.Table(),
      );
  Widget Sample(){
    return Scaffold(
        appBar: AppBar(
          leading: PopupMenuButton<String>(
            initialValue: _selectedValue,
            onSelected: (String s){
              setState(() {
                _selectedValue = s;
                if(s=="時間割")
                  Navigator.of(context).pop(true);
              });
            },
            itemBuilder: (BuildContext context){
              return _usState.map((String s){
                return PopupMenuItem(
                  child: Text(s),
                  value: s,
                );
              }).toList();
            },
          ),
          title: Text(""),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.settings), onPressed: () {}),
            IconButton(icon: Icon(Icons.add), onPressed: () {}),
          ],
        ),
        body:CalenderBase());
  }
}
