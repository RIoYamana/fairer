/*import 'package:flutter/material.dart';
import 'package:timetable_app/lesson/timeTablePage.dart' as prefix0;
class Root extends StatefulWidget {
  Root();

  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  PageController _pageController;
  int _page = 1;

  void initState() {
    super.initState();
    _pageController = new PageController();
  }

  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  Widget bottmNavi() {
    return BottomNavigationBar(
      currentIndex: _page,
      onTap: onTapBottomNavigation,
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.access_time,color: Colors.grey,), title: new Text("スケジュール",style: TextStyle(color: Colors.grey),)),
        BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today,color: Colors.grey), title:new Text("時間割",style: TextStyle(color: Colors.grey))),
        BottomNavigationBarItem(
            icon: Icon(Icons.card_travel,color: Colors.grey), title:new Text("キャリア",style: TextStyle(color: Colors.grey))),
        BottomNavigationBarItem(icon: Icon(Icons.cast,color: Colors.grey), title:new Text("ニュース",style: TextStyle(color: Colors.grey)))
      ],
    );
  }

  void onTapBottomNavigation(int page) {
    _pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease
    );
  }

  Widget appbar() =>
      AppBar(
        title: Text(""),
      );

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }

  Widget build(BuildContext context) =>
      Scaffold(
        appBar: appbar(),
        body: PageView(
          controller: _pageController,
          onPageChanged: onPageChanged,
          children: [
            prefix0.Table(),
            Sample(),
            Sample(),
            Sample()
          ],
        ),
        bottomNavigationBar: bottmNavi(),
      );
}

Widget Sample(){
  return Container(
    color: Colors.blue,
  );
}*/