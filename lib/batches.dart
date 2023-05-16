import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class FOCFilesScreen extends StatefulWidget {
  final String folderPath;

  FOCFilesScreen({required this.folderPath});

  @override
  _FOCFilesScreenState createState() => _FOCFilesScreenState();
}

class _FOCFilesScreenState extends State<FOCFilesScreen> {
  List<String> fileNames = [];
  List<String> folderNames = [];
  bool showAppBar = false;

  @override
  void initState() {
    super.initState();
    loadFOCItems(widget.folderPath);
  }

  Future<void> loadFOCItems(String folderPath) async {
    try {
      firebase_storage.ListResult result =
      await firebase_storage.FirebaseStorage.instance.ref(folderPath).listAll();

      setState(() {
        fileNames = result.items.map((item) => item.name).toList();
        folderNames = result.prefixes.map((prefix) => prefix.name).toList();
      });
    } catch (e) {
      print('Error loading FOC items: $e');
    }
  }

  void openFolder(String folderName) {
    String folderPath = '${widget.folderPath}$folderName/';
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FOCFilesScreen(folderPath: folderPath),
      ),
    );
  }

  void navigateToParentFolder() {
    String parentFolderPath = widget.folderPath.substring(0, widget.folderPath.trim().length - 1);
    int lastIndex = parentFolderPath.lastIndexOf('/');
    parentFolderPath = parentFolderPath.substring(0, lastIndex + 1);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FOCFilesScreen(folderPath: parentFolderPath),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Show the app bar only if there are subfolders
    showAppBar = folderNames.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FOC Files'),
        leading: showAppBar ? IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: navigateToParentFolder,
        ) : null,
      ),
      body: ListView.builder(
        itemCount: fileNames.length + folderNames.length,
        itemBuilder: (context, index) {
          if (index < folderNames.length) {
            // Display subfolder
            return ListTile(
              leading: Icon(Icons.folder),
              title: Text(folderNames[index]),
              onTap: () => openFolder(folderNames[index]),
            );
          } else {
            // Display file
            int fileIndex = index - folderNames.length;
            return ListTile(
              leading: Icon(Icons.insert_drive_file),
              title: Text(fileNames[fileIndex]),
            );
          }
        },
      ),
    );
  }
}


