import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lms/main.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:path/path.dart' as path;
import 'services/userManage.dart';
import 'package:file_picker/file_picker.dart';

class subDir {
  static String subDirName = '';
}

class LectuersHome extends StatefulWidget {
  @override
  _LectuersHomeState createState() => _LectuersHomeState();
}

class _LectuersHomeState extends State<LectuersHome> {
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
    ListResult result = await storage.ref().child('$facShort').listAll();
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
          return Container(
            height: 90, // Adjust the height as needed
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Card(
              color: customColors.secondary,
              child: ListTile(
                leading: Icon(
                  Icons.groups_rounded,
                  color: customColors.primary, // Adjust the icon color here
                ),
                title: Text(
                  _folders[index].name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios_sharp,
                  color: customColors.primary, // Adjust the icon color here
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SubFolderScreen(_folders[index].name),
                    ),
                  );
                },
              ),
            ),
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
  String faculty = UserDetails.faculty;
  String facShort = '';

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
    if (faculty == 'Computing') {
      facShort = 'foc';
    } else if (faculty == 'Business') {
      facShort = 'fob';
    } else if (faculty == 'Science') {
      facShort = 'fos';
    }
    FirebaseStorage storage = FirebaseStorage.instance;
    ListResult result =
        await storage.ref().child('$facShort/${widget.subfolderRef}').listAll();
    List<Reference> refs = result.prefixes;
    setState(() {
      _subfolders = refs;
    });
    subDir.subDirName = widget.subfolderRef;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subfolderRef),
        backgroundColor: customColors.primary,
      ),
      body: ListView.builder(
        itemCount: _subfolders.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 2.0,
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            color: customColors.secondary,
            child: ListTile(
              contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              leading: Icon(
                Icons.folder,
                color: customColors.primary, // Adjust the icon color here
              ),
              title: Text(
                _subfolders[index].name,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios_sharp,
                color: customColors.primary, // Adjust the icon color here
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FilesScreen(_subfolders[index]),
                  ),
                );
              },
            ),
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
  String faculty = UserDetails.faculty;
  String facShort = '';

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

/////////////////////////////upload file to firebase storage//////////////////////////////

  Future<void> _uploadFile(File file) async {
    if (faculty == 'Computing') {
      facShort = 'foc';
    } else if (faculty == 'Business') {
      facShort = 'fob';
    } else if (faculty == 'Science') {
      facShort = 'fos';
    }
    String fileName = file.path.split('/').last;

    try {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Uploading...'),
            content: LinearProgressIndicator(),
          );
        },
      );

      Reference storageRef = FirebaseStorage.instance.ref(
          '$facShort/${subDir.subDirName}/${widget.folderRef.name}/$fileName');
      await storageRef.putFile(file);

      Navigator.of(context).pop(); // Close the uploading dialog

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Upload Complete'),
            content: Text('File uploaded successfully!'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await _refreshFiles();
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      print(e);
      Navigator.of(context).pop(); // Close the uploading dialog

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Upload Failed'),
            content: Text('An error occurred while uploading the file.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

//////////////////////////////////////////////////////////////////////

  ///////////////////////////pick file from device///////////////////////////////////////////
  Future<void> _pickAndUploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      String fileName = result.files.single.name!;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirm Upload'),
            content: Text('Upload file: $fileName?'),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('OK'),
                onPressed: () async {
                  Navigator.of(context).pop(); // Close the dialog
                  await _uploadFile(file);
                },
              ),
            ],
          );
        },
      );
    }
  }

//////////////////////////////////////////////////////////

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

  Future<void> _deleteFile(Reference ref) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete File'),
          content: Text('confirm delete? ${ref.name}'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () async {
                Navigator.of(context).pop();
                await ref.delete();
                await _refreshFiles();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _refreshFiles() async {
    ListResult result = await widget.folderRef.listAll();
    List<Reference> refs = result.items;
    setState(() {
      _files = refs;
    });
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
                    icon: Icon(Icons.download_rounded,color: customColors.fileListText),
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Fetching...', style: TextStyle(color: customColors.alertText)),
                            content: LinearProgressIndicator(),
                          );
                        },
                      );
                      await _downloadFile(file);
                      Navigator.of(context).pop();
                    },
                  ),
                  IconButton(
                    color: Colors.red[900],
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      // Perform delete operation
                      await _deleteFile(file);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: customColors.primary,
        child: Icon(Icons.add),
        onPressed: _pickAndUploadFile,
      ),
    );
  }
}
