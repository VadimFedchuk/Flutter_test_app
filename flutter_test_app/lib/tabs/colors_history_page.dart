import 'package:flutter/material.dart';
import 'package:flutter_test_app/db/db_provider.dart';
import 'package:flutter_test_app/model/color_model.dart';

/// displays a history of colors stored in the database.
class ColorsHistoryPage extends StatefulWidget {
  const ColorsHistoryPage({super.key});

  @override
  State<ColorsHistoryPage> createState() => _ColorsHistoryPageState();
}

class _ColorsHistoryPageState extends State<ColorsHistoryPage> {
  List<ColorModel> colors = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : colors.isEmpty
              ? const Center(child: Text('No data available'))
              : ListView.builder(
                  itemCount: colors.length,
                  itemBuilder: (context, index) => Card(
                    margin: const EdgeInsets.all(16),
                    child: ColorListItem(color: colors[index].color),
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(deleteItems);
        },
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.delete_sweep_outlined,
          color: Colors.deepOrangeAccent,
        ),
      ),
    );
  }

  Future<void> _refreshData() async {
    _isLoading = true;
    final data = await DBProvider.db.getColorsFromDB();
    setState(() {
      colors = data;
      _isLoading = false;
    });
  }

  Future<void> deleteItems() async {
    final isSuccessfullyDeleted = await DBProvider.db.deleteColorsFromDB();
    if (isSuccessfullyDeleted) {
      showSnackBar();
    }
    await _refreshData();
  }

  void showSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Successfully deleted!'),
        backgroundColor: Colors.green,
      ),
    );
  }
}

/// displays a single color item.
class ColorListItem extends StatelessWidget {
  const ColorListItem({required this.color, super.key,});

  final String color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Color: $color'),
          Container(
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(
              color: Color(int.parse(color)).withOpacity(1.0),
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}
