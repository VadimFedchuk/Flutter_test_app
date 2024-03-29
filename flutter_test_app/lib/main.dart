import 'package:flutter/material.dart';
import 'package:flutter_test_app/tabs/colors_history_page.dart';
import 'package:flutter_test_app/tabs/random_color_page.dart';

void main() {
  runApp(const MyApp());
}

/// Defines the main app widget
class MyApp extends StatelessWidget {
  /// Constructor with a key parameter for widget identification and management.
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

/// Main Page of our app, which contains 2 tabs
class HomePage extends StatefulWidget {
  /// Title to be displayed on the app bar, passed through the constructor.
  const HomePage({required this.title, super.key,});

  /// Declaration of title variable to store the app bar title.
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
