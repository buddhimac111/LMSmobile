import 'package:flutter/material.dart';
import 'package:lms/main.dart';

class landing extends StatefulWidget {
  const landing({Key? key}) : super(key: key);

  @override
  State<landing> createState() => _landingState();
}

class _landingState extends State<landing> {
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
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: customColors.landingText),
                        ),
                        focusedBorder: OutlineInputBorder(
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
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                          BorderSide(color: customColors.landingText),
                        ),
                        focusedBorder: OutlineInputBorder(
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
                          onPressed: () {
                            print("object printed");
                          },

                        child: Text('Login',style: TextStyle(fontSize: 20.0),),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: customColors.landingText,
                          foregroundColor: customColors.landingBackground, // Background color
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

// import 'package:flutter/material.dart';
// import 'text_form.dart';
// import 'button.dart';
//
// class landing extends StatefulWidget {
//   const landing({Key? key}) : super(key: key);
//
//   @override
//   State<landing> createState() => _landingState();
//
// }
//
// class _landingState extends State<landing> {
//
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Container(
//           width: double.infinity,
//           padding: const EdgeInsets.all(15.0),
//           height: MediaQuery.of(context).size.height,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               SizedBox(height: 20),
//               Text(
//                 'Login to your account',
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 16,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               const SizedBox(height: 15),
//               TextFormGlobal(
//                 controller: emailController,
//                 text: 'Email',
//                 obscure: false,
//                 textInputType: TextInputType.emailAddress,
//               ),
//               const SizedBox(height: 15),
//               TextFormGlobal(
//                 controller: passwordController,
//                 text: 'Password',
//                 textInputType: TextInputType.text,
//                 obscure: true,
//               ),
//               const SizedBox(height: 15),
//               Button(
//                 emailController: emailController,
//                 passwordController: passwordController,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
