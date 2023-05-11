import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/userManage.dart';


class sample extends StatefulWidget {
  const sample({Key? key}) : super(key: key);

  @override
  State<sample> createState() => _sampleState();
}

class _sampleState extends State<sample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(


          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
          Text("Role: ${UserDetails.uid}", style: TextStyle(fontSize: 20.0),),
          Text(
            "Batch: ${UserDetails.batch}", style: TextStyle(fontSize: 20.0),),
          Text("Name: ${UserDetails.role}", style: TextStyle(fontSize: 20.0),),
          Text("Email: ${UserDetails.fullname}",
            style: TextStyle(fontSize: 20.0),),
              ElevatedButton(
                onPressed: ()  {

                  Navigator.pushNamed(context, '/sample2');
                },
                child: Text('Navigate to Screen 2'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple, // Set the button's background color to blue
                ),
              )
            ],
          )


      ),
    );
  }
}
