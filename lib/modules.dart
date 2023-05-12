import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class MyStorageScreen extends StatefulWidget {
  @override
  _MyStorageScreenState createState() => _MyStorageScreenState();
}

class _MyStorageScreenState extends State<MyStorageScreen> {
  List<Reference> _folders = [];

  @override
  void initState() {
    super.initState();
    _listFolders();
  }

  Future<void> _listFolders() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    ListResult result = await storage.ref().child('foc/21.1 SE').listAll();
    List<Reference> refs = result.prefixes;
    setState(() {
      _folders = refs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Storage Screen'),
      ),
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
    final String fileName = '${ref.name}';
    final String url = await ref.getDownloadURL();
    final Directory appDirectory = await getApplicationDocumentsDirectory();
    final String filePath = '${appDirectory.path}/$fileName';
    final http.Response downloadData = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(downloadData.bodyBytes);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('File downloaded successfully'),
      ),
    );
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
                      title: Text('Downloading...'),
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
