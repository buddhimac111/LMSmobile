import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'landing.dart';
import 'home.dart';
import 'faq.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class customColors {

  static const primary = Color(0xFF5E6BD8);
  static const secondary = Color(0xFFE0E0E0);
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);


  static const landingBackground = Color(0xFF5E6BD8);
  static const landingText = Color(0xFFFFFFFF);

  static const fileListText = Color(0xFF5E6BD8);
  static const fileListBackground = Color(0xFFE0E0E0);

  static const alertBackground = Color(0xFFFFFFFF);
  static const alertText = Color(0xFF5E6BD8);



}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: homePage(),
      home: landing(),
      //   home: ResultsPage(),
      routes: {
        '/landing': (context) => landing(),
        '/home': (context) => homePage(),
        '/faq': (context) => FAQPage(),

      }
    );
  }
}

