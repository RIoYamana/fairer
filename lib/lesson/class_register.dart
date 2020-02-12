//時間割に授業を登録する

import 'package:flutter/material.dart';
import 'class_add.dart';
class ClassRegister extends StatefulWidget{
  int numberClass; //1限の場合0
  int numberWeek;//月曜日の場合0
  ClassRegister({
    @required this.numberClass,
    @required this.numberWeek,
  }):assert(numberClass !=null),
        assert(numberWeek != null);
  _ClassRegisterState createState() => _ClassRegisterState();
}
class _ClassRegisterState extends State<ClassRegister>{
  final TextEditingController eCtrl = TextEditingController();
  void dispose() {
    //ページがdispose（ページの切り替え？）が起きたときに
    //コントローラーの中身を削除する
    eCtrl.dispose();
    super.dispose();
  }
  List<String> baseWeeks = ["Mon","Tue","Wed","Thu","Fri","Sat"];
  List<String> baseTime = ["1st","2nd","3rd","4th","5th","6th","7th","8th"];
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
              baseWeeks[widget.numberWeek]+" "+baseTime[widget.numberClass]+"period",
            )
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Container(
                height: 70,
                margin: EdgeInsets.all(5.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: eCtrl,
                        decoration: InputDecoration(
                          hintText: "講義名または教員名で検索",
                          icon: Icon(Icons.search),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(
              Icons.add
          ),
          onPressed: ()async{
            final result=await Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ClassAdd(numberClass:widget.numberClass, numberWeek:widget.numberWeek)));
            if(result!=null)
              Navigator.of(context).pop(result);
          },

        )
    );
  }
}