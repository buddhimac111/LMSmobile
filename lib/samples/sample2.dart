import 'package:flutter/material.dart';

import '../services/userManage.dart';


class sample2 extends StatefulWidget {
  const sample2({Key? key}) : super(key: key);

  @override
  State<sample2> createState() => _sample2State();
}

class _sample2State extends State<sample2> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(



          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Role: ${UserDetails.uid}", style: TextStyle(fontSize: 20.0),),
              Text("Batch: ${UserDetails.batch}", style: TextStyle(fontSize: 20.0),),
            ],
          )


      ),
    );
  }
}
