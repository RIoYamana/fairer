//時間割ページで授業をタップしたときのルート分けをする
//授業が登録されていない場合 登録のclass_register.dartに
//授業が登録されいている場合　授業の詳細ページclass_detail_dataに

import 'package:flutter/material.dart';
import 'class_register.dart';
import 'class_data.dart';
import 'class_detail_data.dart';
class ClassePage extends StatefulWidget{
  int index;
  int numberClass; //1限の場合0
  int numberWeek;//月曜日の場合0
  ClassData data;
  ClassePage({
    @required this.index,
    this.data,
    @required this.numberClass,
    @required this.numberWeek,
}):assert(index!=null),
        assert(numberClass <=7 &&numberClass>=0),
        assert(numberWeek <=5 && numberWeek>=0);
  _ClassPageState createState() => _ClassPageState();
}
class _ClassPageState extends State<ClassePage>{
  List<String> baseWeeks = ["Mon","Tue","Wed","Thu","Fri","Sat"];
  List<String> baseTime = ["1st","2nd","3rd","4th","5th","6th","7th","8th"];
  List<String> Classes =List.filled(25,'0,0,0,0');////25は5限,金曜日までの時間割//授業名、教室、教員、色

  final TextEditingController eCtrl = TextEditingController();
  void dispose() {
    //ページがdispose（ページの切り替え？）が起きたときに
    //コントローラーの中身を削除する
    eCtrl.dispose();
    super.dispose();
  }
  Widget build(BuildContext context){
    if(widget.index==1)
      return ClassRegister(numberClass: widget.numberClass, numberWeek:widget.numberWeek);
    else
      return ClassDetailDate(data: widget.data,);

  }
}