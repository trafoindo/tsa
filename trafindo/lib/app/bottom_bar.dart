import 'package:flutter/material.dart';
import 'package:trafindo/auth/auth_screen/profile_screen.dart';
import 'package:trafindo/screen/dashboard.dart';
import 'package:trafindo/screen/documentation_report.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({ Key? key, required this.index }) : super(key: key);

  final int index;

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {

  int _currentindex = 0; 
  final List<Widget> _children = [
    const DashboardScreen(),
    const DocumenntationReportScreen(),
    const ProfileScreen(),
  ];

  void onTappedBar(int index) {
    setState(() {
      _currentindex = index;
    });
  }

  void initState(){
    super.initState();
    if( widget.index == 3 ){
    setState(() {
      _currentindex = 3;
    });}
    if( widget.index == 2 ){
    setState(() {
      _currentindex = 2;
    });}
    if( widget.index == 1 ){
    setState(() {
      _currentindex = 1;
    });}
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
      _children[_currentindex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        iconSize: 28,
        selectedFontSize: 14,
        unselectedFontSize: 12,
        currentIndex: _currentindex,
        type: BottomNavigationBarType.fixed,
        onTap: onTappedBar,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Documentation',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}