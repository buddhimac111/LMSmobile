import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lms/main.dart';
// import 'package:lms/sidebar/sidebar.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'profile_view.dart';
import 'timetable.dart';
import 'modules.dart';
import 'batches.dart';
import 'results.dart';
import 'services/userManage.dart';

class homePage extends StatefulWidget {
  const homePage({
    Key? key,
  }) : super(key: key);

  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  final Color navigationBarColor = Colors.white;
  int selectedIndex = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    /// [AnnotatedRegion<SystemUiOverlayStyle>] only for android black navigation bar. 3 button navigation control (legacy)

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: navigationBarColor,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        // drawer: const Sidebar(),
        appBar: AppBar(
          title: Text('UniLearn'),
          backgroundColor: customColors.primary,
          leading: Container(
            padding: EdgeInsets.all(5.0),
            child: Image.asset('assets/images/logobl.png'),
          ),
          actions: [
            Container(
              padding: EdgeInsets.only(right: 15.0),
              child: PopupMenuButton<String>(
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                      value: 'faq',
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Expanded(
                            child: Text(
                              'Faq',
                              textAlign: TextAlign.left,
                            ),
                          ),
                          SizedBox(width: 6),
                          Icon(
                            Icons.help,
                            color: customColors.primary,
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'logout',
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Expanded(
                            child: Text(
                              'Log Out',
                              textAlign: TextAlign.left,
                            ),
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Icon(
                            Icons.logout,
                            color: customColors.primary,
                          ),
                        ],
                      ),
                    ),
                  ];
                },
                onSelected: (String value) async {
                  // Handle menu item selection here
                  if (value == 'logout') {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                            title: Text('Logout'),
                            content: Text('Are you sure you want to logout?'),
                            actions: [
                              TextButton(
                                child: Text("Yes"),
                                onPressed: () async {
                                  try {
                                    await FirebaseAuth.instance.signOut();
                                    Navigator.pushNamed(context, '/landing');
                                  } catch (e) {
                                    print(e);
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text("Error"),
                                            content: Text(
                                                "logout failed maybe network error"),
                                            actions: [
                                              TextButton(
                                                child: Text("ok"),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              )
                                            ],
                                          );
                                        });
                                  }
                                },
                              ),
                              TextButton(
                                child: Text("No"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              )
                            ]);
                      },
                    );
                  }
                  if (value == 'faq') {
                    Navigator.pushNamed(context, '/faq');
                    print("FAQ");
                  }
                },
                child: Icon(Icons.more_vert),
              ),
            ),
          ],
        ),
        // backgroundColor: Colors.grey,
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          children: <Widget>[
            if (UserDetails.role == 'Student') StudentsHome(),
            if (UserDetails.role == 'Lecturer') LectuersHome(),
            if (UserDetails.role == 'Student') ResultsPage(),
            timetable(),
            ProfileDetails(),
            // ProfileDetails(),
          ],
        ),
        bottomNavigationBar: WaterDropNavBar(
          backgroundColor: navigationBarColor,
          waterDropColor: customColors.primary,
          onItemSelected: (int index) {
            setState(() {
              selectedIndex = index;
            });
            pageController.animateToPage(selectedIndex,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutQuad);
          },
          selectedIndex: selectedIndex,
          barItems: <BarItem>[
            BarItem(
              filledIcon: Icons.auto_stories_rounded,
              outlinedIcon: Icons.auto_stories_outlined,
            ),
            if (UserDetails.role == 'Student')
              BarItem(
                filledIcon: Icons.school_rounded,
                outlinedIcon: Icons.school_outlined,
              ),
            BarItem(
              filledIcon: Icons.calendar_month_rounded,
              outlinedIcon: Icons.calendar_month_outlined,
            ),
            BarItem(
              filledIcon: Icons.person_rounded,
              outlinedIcon: Icons.person_outline,
            ),
          ],
        ),
      ),
    );
  }
}
