import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'profile_view.dart';
import 'timetable.dart';
import 'modules.dart';

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
        appBar: AppBar(
          title: Text('Home'),
          backgroundColor: Colors.deepPurple,
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
                    PopupMenuItem<String>(
                      value: 'faq',
                      child: Text('FAQs'),
                    ),
                    PopupMenuItem<String>(
                      value: 'logout',
                      child: Text('Logout'),
                    ),
                  ];
                },
                onSelected: (String value) async {
                  // Handle menu item selection here
                  if (value == 'logout') {
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
                              content: Text("logout failed maybe network error"),
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
                  }
                  if (value == 'faq') {
                    // Navigator.pushNamed(context, '/faq');
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
            MyStorageScreen(),
            Container(
              alignment: Alignment.center,
              child: Icon(
                Icons.favorite_rounded,
                size: 56,
                color: Colors.red[400],
              ),
            ),
            timetable(),
            ProfileDetails(),
            // ProfileDetails(),
          ],
        ),
        bottomNavigationBar: WaterDropNavBar(
          backgroundColor: navigationBarColor,
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
              filledIcon: Icons.house_rounded,
              outlinedIcon: Icons.roofing_rounded,
            ),
            BarItem(
                filledIcon: Icons.favorite_rounded,
                outlinedIcon: Icons.favorite_border_rounded),
            BarItem(
              filledIcon: Icons.today_rounded,
              outlinedIcon: Icons.calendar_month_rounded,
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
