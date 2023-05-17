import 'package:flutter/material.dart';
import 'package:lms/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'services/userManage.dart';

class landing extends StatefulWidget {
  const landing({Key? key}) : super(key: key);

  @override
  State<landing> createState() => _landingState();
}

class _landingState extends State<landing> {
  bool _isLoading = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future login() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);
      print(userCredential.user!.uid);

      UserDetails.uid = userCredential.user!.uid;
      UserDetails.email = userCredential.user!.email.toString();
      await UserDetails.getDetails();
      Navigator.pushNamed(context, '/home');
      setState(() {
        _isLoading = false;
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() {
          _isLoading = false;
        });
        print('No user found for that email.');
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Invalid Email"),
                content: Text("No user found for that email."),
                actions: [
                  TextButton(
                    child: Text("Close"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that email.');
        setState(() {
          _isLoading = false;
        });
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Invalid Password"),
                content: Text("Wrong password provided for that Email."),
                actions: [
                  TextButton(
                    child: Text("Close"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customColors.landingBackground,
      body: Center(
        child: Container(
            margin: const EdgeInsets.all(40.0),
            width: 500.0,
            height: 350.0,
            child: Wrap(
              children: [
                Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                    color: customColors.landingText,
                  ),
                ),
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 20.0),
                    ),
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: customColors.landingText),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: customColors.landingText),
                        ),
                        labelText: 'Username',
                        labelStyle: TextStyle(
                          color: customColors.landingText,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20.0),
                    ),
                    TextField(
                      obscureText: true,
                      controller: passwordController,
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: customColors.landingText),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: customColors.landingText),
                        ),
                        labelText: 'Password',
                        labelStyle: TextStyle(
                          color: customColors.landingText,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 50.0),
                    ),
                    SizedBox(
                      width: 300.0,
                      height: 40.0,
                      child: ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            _isLoading = true;
                          });

                          login();
                          // print(usernameController.text);
                          // print(passwordController.text);
                        },
                        child: _isLoading
                            ? CircularProgressIndicator()
                            : Text("Login", style: TextStyle(fontSize: 20.0)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: customColors.landingText,
                          foregroundColor: customColors
                              .landingBackground, // Background color
                        ),
                      ),
                    )
                  ],
                )
              ],
            )),
      ),
    );
  }
}
