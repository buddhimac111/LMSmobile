import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:lms/main.dart';
import 'package:path/path.dart' as path;
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
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0), // Adjust horizontal and vertical padding values
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyFolderScreen(_folders[index]),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.only(top: 8.0), // Add a gap from the top
                height: 100, // Adjust the height of the box as needed
                decoration: BoxDecoration(
                  color: customColors.secondary,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1, // Reduce the spread radius
                      blurRadius: 2, // Reduce the blur radius
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.local_library_rounded,
                        size: 40,
                        color: customColors.primary,
                      ),
                      SizedBox(width: 16),
                      Text(
                        _folders[index].name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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

  @override
  void initState() {
    super.initState();
    _listFiles();
  }
  IconData _getFileIcon(String fileName) {
    String extension = path.extension(fileName).toLowerCase();
    switch (extension) {
      case '.pdf':
        return Icons.picture_as_pdf;
      case '.doc':
      case '.docx':
      case '.ppt':
      case '.pptx':
      case '.xls':
      case '.xlsx':
        return Icons.description;
      case '.jpg':
      case '.jpeg':
      case '.png':
        return Icons.image;
      case '.mp4':
        return Icons.video_collection;
      case '.mp3':
        return Icons.music_note;
// Add more cases for other file extensions as needed
      default:
        return Icons.insert_drive_file;
    }
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
        title: Text(widget.folderRef.name),
        backgroundColor: customColors.primary,
      ),
      body: ListView.builder (
        itemCount: _files.length,
        itemBuilder: (context, index) {
          Reference file = _files[index];
          String fileName = file.name;
          IconData fileIcon = _getFileIcon(fileName);
          String extension = path.extension(fileName).replaceFirst('.', '').toUpperCase();
          String fileNameWithoutExtension = path.basenameWithoutExtension(fileName);

          return Card(
            color: customColors.fileListBackground,
            child: ListTile(
              leading: Icon(fileIcon, color: customColors.fileListText),
              title: Text(
                fileNameWithoutExtension,
                style: TextStyle(color: customColors.black),
              ),
              subtitle: Text(
                extension,
                style: TextStyle(color: customColors.fileListText),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.download_rounded, color: customColors.fileListText),
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Fetching...', style: TextStyle(color: customColors.alertText)), // Set dialog title text color to white
                            content: LinearProgressIndicator(),
                            backgroundColor: customColors.alertBackground, // Set dialog background color to blue
                          );
                        },
                      );
                      await _downloadFile(file);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );

        },
      ),
    );
  }

}
////////////////////////////////////////////////////////