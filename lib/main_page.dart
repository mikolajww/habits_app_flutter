import 'package:Habitect/calendar_page.dart';
import 'package:Habitect/home_page.dart';
import 'package:Habitect/statistics_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentMenuTab = 0;

  final PageController pageController = PageController(initialPage: 0, keepPage: true);

  void _onMenuItemTapped(int value) {
    setState(() {
      _currentMenuTab = value;
      pageController.animateToPage(_currentMenuTab, duration: Duration(milliseconds: 300), curve: Curves.ease);
    });
  }

  void _onPageChanged(int value) {
    setState(() {
      _currentMenuTab = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          onPageChanged: _onPageChanged,
          controller: pageController,
          children: [
            HomePage(),
            StatisticsPage(),
            CalendarPage(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wysiwyg_sharp),
            label: 'To-Do',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
        ],
        currentIndex: _currentMenuTab,
        backgroundColor: Color(0xff1e1e1e),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green[500],
        onTap: _onMenuItemTapped,
      ),
    );
  }
}
