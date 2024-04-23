import 'package:flutter/material.dart';
import 'package:smart_hemo_check/start_test.dart';
import 'package:smart_hemo_check/results.dart';
import 'package:smart_hemo_check/settings.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const StartTest(),
    const ResultsPage(),
    Settings(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Smart Hemo Check',
              style: TextStyle(color: Colors.black),
            ),
            IconButton(
              color: Colors.black,
              onPressed: () {
                _showBottomSheet(context);
              },
              icon: const Icon(Icons.menu),
            ),
          ],
        ),
        backgroundColor: Color.fromARGB(255, 61, 252, 252),
        leading: Container(),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _buildListRow(context, 'Start Test', Icons.play_arrow, 0),
            _buildListRow(context, 'Results', Icons.bar_chart, 1),
            _buildListRow(context, 'Settings', Icons.settings, 2),
            // Add more list rows here
          ],
        );
      },
    );
  }

  Widget _buildListRow(BuildContext context, String title, IconData iconData, int index) {
    return ListTile(
      leading: Icon(
        iconData,
        size: 40,
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 20),
      ),
      onTap: () {
        Navigator.pop(context); // Close the bottom sheet
        setState(() {
          _selectedIndex = index;
        });
      },
    );
  }
}

