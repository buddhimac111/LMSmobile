import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'services/userManage.dart';

//////////////Folders list////////////////////

class StudentsHome extends StatefulWidget {
  @override
  _StudentsHomeState createState() => _StudentsHomeState();
}

class _StudentsHomeState extends State<StudentsHome> {
  List<Reference> _folders = [];

  String faculty = UserDetails.faculty;
  String facShort = '';

  @override
  void initState() {
    super.initState();
    _listFolders();
  }

//${UserDetails.facShort}/${UserDetails.batch} ${UserDetails.degree}

  Future<void> _listFolders() async {
    if (faculty == 'Computing') {
      facShort = 'foc';
    } else if (faculty == 'Business') {
      facShort = 'fob';
    } else if (faculty == 'Science') {
      facShort = 'fos';
    }

    FirebaseStorage storage = FirebaseStorage.instance;
    ListResult result = await storage
        .ref()
        .child('$facShort/${UserDetails.batch} ${UserDetails.degree}')
        .listAll();
    List<Reference> refs = result.prefixes;
    setState(() {
      _folders = refs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _folders.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(3.0),
            child: Center(
              child: Wrap(spacing: 20.0, runSpacing: 20.0, children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: 380.0,
                      height: 143.0,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MyFolderScreen(_folders[index])));
                        },
                        splashColor: Colors.blue,
                        child: Card(
                          color: Colors.blue,
                          elevation: 2.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.library_books,
                                    size: 45.0,
                                  ),
                                  const VerticalDivider(
                                    color: Colors.white,
                                    thickness: 1.0,
                                    width: 20.0,
                                  ),
                                  const SizedBox(height: 10.0),
                                  Center(
                                    child: Text(
                                      _folders[index].name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        // fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
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
                  ],
                ),
              ]),
            ),
          );
        },
      ),
    );
  }
}

////////////////////////////////////////////////////////

//////////////////////Files list///////////////////////

class MyFolderScreen extends StatefulWidget {
  final Reference folderRef;

  const MyFolderScreen(this.folderRef);

  @override
  _MyFolderScreenState createState() => _MyFolderScreenState();
}

class _MyFolderScreenState extends State<MyFolderScreen> {
  List<Reference> _files = [];
  // bool hasUserAccessed = true; // Example boolean indicating user access

  @override
  void initState() {
    super.initState();
    _listFiles();
  }

  Future<void> _listFiles() async {
    ListResult result = await widget.folderRef.listAll();
    List<Reference> refs = result.items;
    setState(() {
      _files = refs;
    });
  }

  Future<void> _downloadFile(Reference ref) async {
    final String url = await ref.getDownloadURL();
    final String filename = ref.name;
    final Directory systemTempDir = Directory.systemTemp;
    final File tempFile = File('${systemTempDir.path}/$filename');
    if (tempFile.existsSync()) {
      await tempFile.delete();
    }
    await tempFile.create();
    final http.Response response = await http.get(Uri.parse(url));
    await tempFile.writeAsBytes(response.bodyBytes);
    await OpenFile.open(tempFile.path);
    final AndroidIntent intent = AndroidIntent(
      action: 'action_view',
      data: Uri.parse(url).toString(),
    );
    await intent.launch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text(widget.folderRef.name),
        title: Text("Lecture Materials"),
      ),
      body: ListView.builder(
        itemCount: _files.length,
        itemBuilder: (context, index) {
          // final lessonText = _files[index];
          // final lessonNumber = extractLessonNumber(lessonText as String);
          return Padding(
            padding: const EdgeInsets.all(3.0),
            child: Center(
              child: Wrap(spacing: 20.0, runSpacing: 10.0, children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: 380.0,
                      height: 80.0,
                      child: InkWell(
                        onTap: () async {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Please Wait.'),
                                content: LinearProgressIndicator(),
                              );
                            },
                          );
                          await _downloadFile(_files[index]);
                          Navigator.of(context).pop();
                        },
                        splashColor: Colors.blue,
                        child: Card(
                          // color: hasUserAccessed
                          //     ? Colors.green
                          //     : Colors
                          //         .blue, // Change color based on user access
                          color: Colors.blue,
                          elevation: 2.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                leading: Icon(Icons.insert_drive_file_outlined),
                                // VerticalDivider(
                                //   color: Colors.white,
                                //   thickness: 1.0,
                                //   width: 20.0,
                                // ),
                                title: Text(
                                  widget.folderRef.name,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    // fontWeight: FontWeight.bold,
                                    // fontSize: 20.0,
                                  ),
                                ),
                                subtitle: Text(_files[index].name),
                                trailing: Icon(Icons.download_sharp),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ]),
            ),
          );
        },
      ),
    );
  }
  // int extractLessonNumber(String lessonText) {
  //   final pattern = RegExp(r'Lesson (\d+)');
  //   final match = pattern.firstMatch(lessonText);
  //   final numberString = match?.group(1) ?? 'N/A';
  //   return int.tryParse(numberString) ?? -1;
  // }
}
////////////////////////////////////////////////////////
