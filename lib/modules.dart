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
          return ListTile(
            title: Text(_folders[index].name),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyFolderScreen(_folders[index]),
                ),
              );
            },
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
      type: 'application/pdf',
    );
    await intent.launch();
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
          return ListTile(
            title: Text(_files[index].name),
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
                await _downloadFile(_files[index]);
                Navigator.of(context).pop();
              },
            ),
          );
        },
      ),
    );
  }
}
////////////////////////////////////////////////////////