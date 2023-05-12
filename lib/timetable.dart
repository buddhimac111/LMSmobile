import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';


class timetable extends StatefulWidget {
  const timetable({Key? key}) : super(key: key);

  @override
  State<timetable> createState() => _timetableState();
}

class _timetableState extends State<timetable> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Timetable"),
      ),
    );
  }
}
