import 'package:flutter/material.dart';
class test extends StatefulWidget {
  const test({Key? key}) : super(key: key);

  @override
  State<test> createState() => _testState();
}

class _testState extends State<test> {
  @override
  Widget build(BuildContext context) {
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


    child: Row(
      mainAxisAlignment:
      MainAxisAlignment.spaceAround,
      children: [
        const Icon(
          Icons.insert_drive_file_outlined,
          size: 25.0,
        ),
        const VerticalDivider(
          color: Colors.white,
          thickness: 1.0,
          width: 20.0,
        ),
        // SizedBox(height: 10.0),
        Text(
          _files[index].name,
          style: const TextStyle(
            color: Colors.white,
            // fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        // SizedBox(width: 20,),
        const Icon(Icons.download_sharp, size: 20),
      ],
    ),
  }
}
