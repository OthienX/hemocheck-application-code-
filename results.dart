import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ResultsPage extends StatefulWidget {
  const ResultsPage({super.key});

  @override
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  List<dynamic> _results = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      List<dynamic> results = await fetchFastAPIResults();
      setState(() {
        _results = results;
      });
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Server Time out'),
      ));
    }
  }

  Future<List<dynamic>> fetchFastAPIResults() async {
    final response = await http.get(Uri.parse('smarthemo.pythonanywhere.com/compute_pt'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load results');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: Container(),
        title: const Text('Results'),
      ),
      body: Center(
        child: _results.isEmpty
            ? const CircularProgressIndicator() // Show a loading indicator while fetching data
            : Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: _results.map((result) {
                      return ListTile(
                        title: Text(result['title']),
                        subtitle: Text(result['desciption']),
                      );
                    }).toList(),
                  ),
                ),
        ),
      ),
    );
  }
}
