import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetails {
  static String uid = '2HwXMU2F15azIXQiTklezKV7cIB2';
  static String email = '';

  static String username = '';
  static String fullname = '';
  static String uniid = '';
  static String faculty = '';
  static String sex = '';
  static String dob = '';
  static String role = '';
  static String contact = '';

  static String doa = '';
  static String batch = '';
  static String degree = '';

  static String doj = '2015-06-21';

  static Future<void> getDetails() async {
    try {
      DocumentSnapshot documentSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      username = documentSnapshot.get('username').toString();
      fullname = documentSnapshot.get('fullname').toString();
      uniid = documentSnapshot.get('uniid').toString();
      faculty = documentSnapshot.get('faculty').toString();
      sex = documentSnapshot.get('sex').toString();
      dob = documentSnapshot.get('dob').toString();
      role = documentSnapshot.get('role').toString();
      contact = documentSnapshot.get('contact').toString();
      doa = documentSnapshot.get('doa').toString();
      batch = documentSnapshot.get('batch').toString();
      degree = documentSnapshot.get('degree').toString();
      doj = documentSnapshot.get('doj').toString();


      print(username);
      print(fullname);
      print(uniid);
      print(faculty);
      print(sex);
      print(dob);
      print(role);
      print(contact);
      print(doa);
      print(batch);
      print(degree);
      print(doj);

    } catch (e) {
      print(e);
    }
  }
}
