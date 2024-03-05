import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'package:flutter_test_app/db/db_provider.dart';
import 'package:flutter_test_app/model/color_model.dart';

/// shows a random color on the screen.
class RandomColorPage extends StatefulWidget {
  const RandomColorPage({super.key});

  @override
  State<RandomColorPage> createState() => _RandomColorPageState();
}

class _RandomColorPageState extends State<RandomColorPage> {

  Color _currentBackgroundColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          _currentBackgroundColor = _randomColor();
        });
      },
      child: ColoredBox(
        color: _currentBackgroundColor,
        child: const Center(
          child: Text(
            'Hello there',
          ),
        ),
      ),
    );
  }

  Color _randomColor() {
    final int value = (math.Random().nextDouble() * 0xFFFFFF).toInt();
    final Color color = Color(value).withOpacity(1.0);
    addColorToDatabase(value.toString());
    return color;
  }

  Future<void> addColorToDatabase(String color) async {
    await DBProvider.db.addColorToDB(
        ColorModel(id: math.Random().nextInt(1000), color: color),
    );
  }
}
