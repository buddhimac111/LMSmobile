import 'package:flutter/material.dart';
import 'package:lms/main.dart';
import 'services/getTimetable.dart';

class timetable extends StatefulWidget {
  const timetable({Key? key}) : super(key: key);

  @override
  State<timetable> createState() => _timetableState();
}

class _timetableState extends State<timetable> {
  List<String> subjects = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      subjects = [];
    });
    // Call the function to retrieve the subjects
    getSubjects();
  }

  Future<void> getSubjects() async {
    try {
      final fileUrl = 'https://drive.google.com/uc?export=download&id=1-avFlaWJsq1pjIHq4JYRl34iZelNr9pX';
      await GetTimetable.readExcelFromSharePoint(fileUrl);
      setState(() {
        subjects = GetTimetable.subjects;
      });
    } catch (e) {
      setState(() {
        subjects = ['-1', 'An error occurred: $e'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: subjects.isEmpty
            ? CircularProgressIndicator() // Show a loading indicator while subjects are being retrieved
            : subjects[0] == "-1" ? Text( // show error message
          subjects[1],
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 25.0,
          ),
        ) : subjects[0] == "0" ? Text( // show error message
            subjects[1],
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 25.0,
            ),) :ListView.builder(
          itemCount: subjects.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: SizedBox(
                  width: 190.0,
                  height: 113.0,
                  child: InkWell(
                      onTap: () {},
                      child: Card(
                        color: customColors.secondary,
                        elevation: 2.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 10.0),
                                Center(
                                  child: Text(
                                    subjects[index].split("-")[0] + "-" + subjects[index].split("-")[1],
                                    style: TextStyle(
                                      color: customColors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25.0,
                                    ),
                                  ),
                                ),Center(
                                  child: Text(
                                    subjects[index].split("-")[2],
                                    style: TextStyle(
                                      color: customColors.primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ),
              ),
            );
          },
        ),
      ),
    );
  }
}