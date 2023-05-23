import 'package:flutter/material.dart';
import 'services/userManage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ProfileDetails extends StatefulWidget {
  const ProfileDetails({Key? key}) : super(key: key);

  @override
  State<ProfileDetails> createState() => _ProfileState();
}

class _ProfileState extends State<ProfileDetails> {
  String backgroundImageUrl = '';
  bool imgLoading = true;

  Future<void> fetchImage() async {
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref(
        'profileImages/${UserDetails.uniid}.jpg'); // Replace 'images/tt.jpg' with your image path in Firebase Storage
    backgroundImageUrl = await ref.getDownloadURL();
    setState(() {});
    imgLoading = false;// Update the state to reflect the fetched image URL
  }

  @override
  void initState() {
    super.initState();
    fetchImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 115,
                  width: 115,
                  child: FutureBuilder<void>(
                    future: precacheImage(NetworkImage(backgroundImageUrl), context),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else {
                        return CircleAvatar(
                          backgroundImage: NetworkImage(backgroundImageUrl),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  child: Text(
                    UserDetails.fullname,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              thickness: 1,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ProfileDetailRow(
                    title: 'University ID', value: "${UserDetails.uniid}"),
                ProfileDetailRow(
                    title: 'Academic Role', value: '${UserDetails.role}'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ProfileDetailRow(
                    title: 'Faculty', value: '${UserDetails.faculty}'),
                if (UserDetails.role == 'Student')
                  ProfileDetailRow(
                      title: 'Date Of Admission', value: '${UserDetails.doa}'),
                if (UserDetails.role == 'Lecturer')
                  ProfileDetailRow(
                      title: 'Date Of Joined', value: '${UserDetails.doj}'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ProfileDetailRow(title: 'Sex', value: '${UserDetails.sex}'),
                ProfileDetailRow(
                    title: 'Date Of Birth', value: '${UserDetails.dob}'),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            ProfileDetailColumn(
                title: 'Full Name', value: '${UserDetails.fullname}'),
            ProfileDetailColumn(
                title: 'Username', value: '${UserDetails.username}'),
            ProfileDetailColumn(title: 'Email', value: '${UserDetails.email}'),
            if (UserDetails.role == 'Student')
              ProfileDetailColumn(
                  title: 'Batch', value: '${UserDetails.batch}'),
            if (UserDetails.role == 'Student')
              ProfileDetailColumn(
                  title: 'Degree', value: '${UserDetails.degree}'),
            ProfileDetailColumn(
                title: 'Contact Number', value: '${UserDetails.contact}'),
          ],
        ),
      ),
    );
  }
}

class ProfileDetailRow extends StatelessWidget {
  const ProfileDetailRow({Key? key, required this.title, required this.value})
      : super(key: key);

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.black, fontSize: 15.0),
              ),
              const SizedBox(height: 10.0),
              Text(value, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 10.0),
              SizedBox(
                width: MediaQuery.of(context).size.width / 3,
                child: const Divider(
                  thickness: 1.0,
                ),
              ),
            ],
          ),
          const Icon(
            Icons.lock_outline,
            size: 10.0,
          ),
        ],
      ),
    );
  }
}

class ProfileDetailColumn extends StatelessWidget {
  const ProfileDetailColumn(
      {Key? key, required this.title, required this.value})
      : super(key: key);

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Colors.black,
                    fontSize: 15.0,
                  ),
            ),
            const SizedBox(height: 10.0),
            Text(value, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 10.0),
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.1,
              child: const Divider(
                thickness: 1.0,
              ),
            )
          ],
        ),
        const Icon(
          Icons.lock_outline,
          size: 10.0,
        ),
      ],
    );
  }
}
