import 'package:flutter/material.dart';
import 'package:flutter_test_app/tabs/colors_history_page.dart';
import 'package:flutter_test_app/tabs/random_color_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(title: 'Flutter Test app'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({required this.title, super.key,});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Key _colorsHistoryPageKey = const ValueKey("ColorsHistoryPageDefault");
  int _selectedIndex = 0;

  static const List<BottomNavigationBarItem> _tabs = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.work),
      label: 'Random color',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.history),
      label: 'History',
    ),
  ];

  void _onTabClicked(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 1) {
        _colorsHistoryPageKey = ValueKey("ColorsHistoryPage${DateTime.now()}");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgets = <Widget>[
      const RandomColorPage(),
      ColorsHistoryPage(key: _colorsHistoryPageKey,),
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: Center(
          child: Text(
            widget.title,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: widgets,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: _tabs,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white60,
        onTap: _onTabClicked,
        backgroundColor: Colors.deepOrangeAccent,
      ),
    );
  }
}
