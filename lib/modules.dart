import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:android_intent_plus/android_intent.dart';




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

 //download file and save to local storage and display on phone internal storage and display it on file manager
 //
 //    final String fileName = '${ref.name}';
 //    final String url = await ref.getDownloadURL();
 //    final Directory? appDirectory = await getExternalStorageDirectory();
 //    final String filePath = '${appDirectory?.path}/$fileName';
 //    final List<int> bytes = await http.readBytes(Uri.parse(url));
 //    final File file = File(filePath);
 //    await file.writeAsBytes(bytes);
 //
 //    // Scan the downloaded file and make it available in the device's file manager
 //    final AndroidIntent intent = AndroidIntent(
 //      action: 'android.intent.action.MEDIA_SCANNER_SCAN_FILE',
 //      data: Uri.parse('file://$filePath').toString(),
 //    );
 //    await intent.launch();
 //
 //    ScaffoldMessenger.of(context).showSnackBar(
 //      SnackBar(
 //        content: Text('File downloaded successfully'),
 //      ),
 //    );
 //    OpenFile.open(filePath);
 //    Navigator.of(context).pop(); // Add this line to close the dialog

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
