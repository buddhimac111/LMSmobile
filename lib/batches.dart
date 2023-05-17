import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:path/path.dart' as path;

class LectuersHome extends StatefulWidget {
  @override
  _LectuersHomeState createState() => _LectuersHomeState();
}

class _LectuersHomeState extends State<LectuersHome> {
  List<Reference> _folders = [];

  @override
  void initState() {
    super.initState();
    _listFolders();
  }

  Future<void> _listFolders() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    ListResult result = await storage.ref().child('foc').listAll();
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
          return ListTile(
            title: Text(_folders[index].name),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubFolderScreen(_folders[index].name),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

//sub
class SubFolderScreen extends StatefulWidget {
  final String subfolderRef;

  const SubFolderScreen(this.subfolderRef);

  @override
  State<SubFolderScreen> createState() => _SubFolderScreenState();
}

class _SubFolderScreenState extends State<SubFolderScreen> {
  List<Reference> _subfolders = [];

  IconData _getFileIcon(String fileName) {
    String extension = path.extension(fileName).toLowerCase();
    switch (extension) {
      case '.pdf':
        return Icons.picture_as_pdf;
      case '.doc':
      case '.docx':
        return Icons.description;
      case '.jpg':
      case '.jpeg':
      case '.png':
        return Icons.image;
      // Add more cases for other file extensions as needed
      default:
        return Icons.insert_drive_file;
    }
  }

  @override
  void initState() {
    super.initState();
    _listSubFolders();
  }

  Future<void> _listSubFolders() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    ListResult result =
        await storage.ref().child('foc/${widget.subfolderRef}').listAll();
    List<Reference> refs = result.prefixes;
    setState(() {
      _subfolders = refs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subfolderRef),
      ),
      body: ListView.builder(
        itemCount: _subfolders.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_subfolders[index].name),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FilesScreen(_subfolders[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

//sub

class FilesScreen extends StatefulWidget {
  final Reference folderRef;

  const FilesScreen(this.folderRef);

  @override
  _FilesScreenState createState() => _FilesScreenState();
}

class _FilesScreenState extends State<FilesScreen> {
  List<Reference> _files = [];

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
// type: 'application/pdf',
    );
    await intent.launch();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.folderRef.name),
      ),
      body: ListView.builder(
        itemCount: _files.length,
        itemBuilder: (context, index) {
          Reference file = _files[index];
          String fileName = file.name;
          IconData fileIcon = _getFileIcon(fileName);
          return Card(
            child: ListTile(
              leading: Icon(fileIcon),
              title: Text(fileName),
              subtitle: Text('File'),
              trailing: IconButton(
                icon: Icon(Icons.download_rounded),
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Fetching...'),
                        content: LinearProgressIndicator(),
                      );
                    },
                  );
                  await _downloadFile(file);
                  Navigator.of(context).pop();
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
