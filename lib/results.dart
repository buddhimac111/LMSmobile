import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:lms/main.dart';
import 'services/userManage.dart';
import 'dart:convert';

class ResultsPage extends StatefulWidget {
  const ResultsPage({Key? key}) : super(key: key);

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  List<DataRow> tableRowsY1S1 = [];
  List<DataRow> tableRowsY1S2 = [];
  List<DataRow> tableRowsY2S1 = [];
  List<DataRow> tableRowsY2S2 = [];
  List<DataRow> tableRowsY3S1 = [];
  List<DataRow> tableRowsY3S2 = [];

  @override
  void initState() {
    super.initState();
    fetchResultsData();
  }

  String getGrade(String marks) {
    int marksInt = int.parse(marks);
    if (marksInt > 100) {
      return 'TBA';
    } else if (marksInt >= 75) {
      return 'A+ : Pass';
    } else if (marksInt >= 70) {
      return 'A : Pass';
    } else if (marksInt >= 65) {
      return 'A- : Pass';
    } else if (marksInt >= 60) {
      return 'B+ : Pass';
    } else if (marksInt >= 55) {
      return 'B : Pass';
    } else if (marksInt >= 50) {
      return 'B- : Pass';
    } else if (marksInt >= 45) {
      return 'C+ : Pass';
    } else if (marksInt >= 40) {
      return 'C : Pass';
    } else if (marksInt >= 35) {
      return 'C- : Repeat';
    } else if (marksInt >= 30) {
      return 'D+ : Repeat';
    } else if (marksInt >= 25) {
      return 'D : Repeat';
    } else if (marksInt >= 20) {
      return 'D- : Repeat';
    } else if (marksInt >= 0) {
      return 'F : Repeat';
    } else {
      return 'N/A';
    }

  }

  void fetchResultsData() {
    final database = FirebaseDatabase.instance.ref("results/${UserDetails.uid}");

    database.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      final y1s1 = data['y1s1'];
      final y1s2 = data['y1s2'];
      final y2s1 = data['y2s1'];
      final y2s2 = data['y2s2'];
      final y3s1 = data['y3s1'];
      final y3s2 = data['y3s2'];

      List<DataRow> rowsY1S1 = [];
      List<DataRow> rowsY1S2 = [];
      List<DataRow> rowsY2S1 = [];
      List<DataRow> rowsY2S2 = [];
      List<DataRow> rowsY3S1 = [];
      List<DataRow> rowsY3S2 = [];


      for (var entry in y1s1.entries) {
        rowsY1S1.add(
          DataRow(cells: [
            DataCell(Text(entry.key)),
            DataCell(Text('${getGrade(entry.value.toString())}')),
          ]),
        );
      }

      for (var entry in y1s2.entries) {
        rowsY1S2.add(
          DataRow(cells: [
            DataCell(Text(entry.key)),
            DataCell(Text('${getGrade(entry.value.toString())}')),
          ]),
        );
      }

      for (var entry in y2s1.entries) {
        rowsY2S1.add(
          DataRow(cells: [
            DataCell(Text(entry.key)),
            DataCell(Text('${getGrade(entry.value.toString())}')),
          ]),
        );
      }

      for (var entry in y2s2.entries) {
        rowsY2S2.add(
          DataRow(cells: [
            DataCell(Text(entry.key)),
            DataCell(Text('${getGrade(entry.value.toString())}')),
          ]),
        );
      }

      for (var entry in y3s1.entries) {
        rowsY3S1.add(
          DataRow(cells: [
            DataCell(Text(entry.key)),
            DataCell(Text('${getGrade(entry.value.toString())}')),
          ]),
        );
      }

      for (var entry in y3s2.entries) {
        rowsY3S2.add(
          DataRow(cells: [
            DataCell(Text(entry.key)),
            DataCell(Text('${getGrade(entry.value.toString())}')),
          ]),
        );
      }


      setState(() {
        tableRowsY1S1 = rowsY1S1;
        tableRowsY1S2 = rowsY1S2;
        tableRowsY2S1 = rowsY2S1;
        tableRowsY2S2 = rowsY2S2;
        tableRowsY3S1 = rowsY3S1;
        tableRowsY3S2 = rowsY3S2;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          // year 1 semester 1
          Card(
            color: customColors.secondary,
            elevation: 4,
            child: ExpansionTile(
              childrenPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              expandedCrossAxisAlignment: CrossAxisAlignment.end,
              maintainState: true,
              title: Text(
                '1st Year | Semester 1',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold, // Make the title bold
                ),
              ),
              children: [
                DataTable(
                  columns: [
                    DataColumn(label: Text('Subject')),
                    DataColumn(label: Text('Grade/Status')),
                  ],
                  rows: tableRowsY1S1,
                ),
              ],
            ),
          ),
          // year 1 semester 2
          Card(
            color: customColors.secondary,
            elevation: 4,
            child: ExpansionTile(
              childrenPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              expandedCrossAxisAlignment: CrossAxisAlignment.end,
              maintainState: true,
              title: Text(
                '1st Year | Semester 2',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold, // Make the title bold
                ),
              ),
              children: [
                DataTable(
                  columns: [
                    DataColumn(label: Text('Subject')),
                    DataColumn(label: Text('Grade')),
                  ],
                  rows: tableRowsY1S2,
                ),
              ],
            ),
          ),

          // year 2 semester 1
          Card(
            color: customColors.secondary,
            elevation: 4,
            child: ExpansionTile(
              childrenPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              expandedCrossAxisAlignment: CrossAxisAlignment.end,
              maintainState: true,
              title: Text(
                '2nd Year | Semester 1',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold, // Make the title bold
                ),
              ),
              children: [
                DataTable(
                  columns: [
                    DataColumn(label: Text('Subject')),
                    DataColumn(label: Text('Grade')),
                  ],
                  rows: tableRowsY2S1,
                ),
              ],
            ),
          ),

          // year 2 semester 2
          Card(
            color: customColors.secondary,
            elevation: 4,
            child: ExpansionTile(
              childrenPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              expandedCrossAxisAlignment: CrossAxisAlignment.end,
              maintainState: true,
              title: Text(
                '2nd Year | Semester 2',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold, // Make the title bold
                ),
              ),
              children: [
                DataTable(
                  columns: [
                    DataColumn(label: Text('Subject')),
                    DataColumn(label: Text('Grade')),
                  ],
                  rows: tableRowsY2S2,
                ),
              ],
            ),
          ),

          // year 3 semester 1
          Card(
            color: customColors.secondary,
            elevation: 4,
            child: ExpansionTile(
              childrenPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              expandedCrossAxisAlignment: CrossAxisAlignment.end,
              maintainState: true,
              title: Text(
              '3rd Year | Semester 1',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold, // Make the title bold
              ),
            ),
              children: [
                DataTable(
                  columns: [
                    DataColumn(label: Text('Subject')),
                    DataColumn(label: Text('Grade')),
                  ],
                  rows: tableRowsY3S1,
                ),
              ],
            ),
          ),

          // year 3 semester 2
          Card(
            color: customColors.secondary,
            elevation: 4,
            child: ExpansionTile(
              childrenPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              expandedCrossAxisAlignment: CrossAxisAlignment.end,
              maintainState: true,
              title: Text(
                '3rd Year | Semester 2',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold, // Make the title bold
                ),
              ),
              children: [
                DataTable(
                  columns: [
                    DataColumn(label: Text('Subject')),
                    DataColumn(label: Text('Grade')),
                  ],
                  rows: tableRowsY3S2,
                ),
              ],
            ),
          ),


        ],
      ),
    );
  }
}
