import 'package:flutter/material.dart';
import 'package:primewayskills_app/view/appbar_screens/notification_screen.dart';
import 'package:primewayskills_app/view/appbar_screens/profile_edit_screen.dart';
import 'package:primewayskills_app/view/dashboard/collaboration_screen.dart';
import 'package:primewayskills_app/view/dashboard/course_screen.dart';
import 'package:primewayskills_app/view/dashboard/home_screen.dart';
import 'package:primewayskills_app/view/dashboard/profile_screen.dart';
import 'package:primewayskills_app/view/drawer/sidebar.dart';
import 'package:primewayskills_app/view/helpers/colors.dart';

class Dashboard extends StatefulWidget {
  final String userName;
  final String userId;
  const Dashboard({Key? key, required this.userName, required this.userId})
      : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final int _currentIndex = 0;

  bool showHome = true;
  bool showCollab = false;
  bool showProfile = false;
  bool showCourses = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavigationDrawer(),
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black.withOpacity(0.6),
        ),
        backgroundColor: whiteColor,
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Hi, ',
                style: TextStyle(
                  fontSize: maxSize,
                  color: Colors.black.withOpacity(0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextSpan(
                text: widget.userName,
                style: TextStyle(
                  fontSize: maxSize,
                  color: Colors.black.withOpacity(0.6),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          InkWell(
            child: Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: whiteColor,
                boxShadow: [
                  BoxShadow(
                    color: primeColor.withOpacity(0.4),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Icon(
                Icons.person,
                color: Colors.black.withOpacity(0.6),
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileEditScreen(
                    userId: '',
                    userName: '',
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 10),
          InkWell(
            child: Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: whiteColor,
                boxShadow: [
                  BoxShadow(
                    color: primeColor.withOpacity(0.4),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Icon(
                Icons.notifications,
                color: Colors.black.withOpacity(0.6),
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationScreen(),
                ),
              );
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: showHome
          ? const Homescreen()
          : showCollab
              ? const CollaborationScreen()
              : showCourses
                  ? const CoursesScreen()
                  : const ProfileScreen(),
      bottomNavigationBar: SizedBox(
        height: 80,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 4,
          ),
          child: Column(
            children: [
              Container(
                height: 60,
                decoration: BoxDecoration(
                  color: primeColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        setState(() {
                          showHome = true;
                          showCollab = false;
                          showCourses = false;
                          showProfile = false;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.home_rounded,
                            color: showHome
                                ? whiteColor.withOpacity(0.4)
                                : whiteColor,
                            size: showHome ? 30 : 25,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'HOME',
                            style: TextStyle(
                              color: showHome
                                  ? whiteColor.withOpacity(0.4)
                                  : whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        setState(() {
                          showHome = false;
                          showCollab = true;
                          showCourses = false;
                          showProfile = false;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.workspaces_rounded,
                            color: showCollab
                                ? whiteColor.withOpacity(0.4)
                                : whiteColor,
                            size: showCollab ? 30 : 25,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'COLLABS',
                            style: TextStyle(
                              color: showCollab
                                  ? whiteColor.withOpacity(0.4)
                                  : whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        setState(() {
                          showHome = false;
                          showCollab = false;
                          showCourses = true;
                          showProfile = false;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.library_books_rounded,
                            color: showCourses
                                ? whiteColor.withOpacity(0.4)
                                : whiteColor,
                            size: showCourses ? 30 : 25,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'LIBRARY',
                            style: TextStyle(
                              color: showCourses
                                  ? whiteColor.withOpacity(0.4)
                                  : whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        setState(() {
                          showHome = false;
                          showCollab = false;
                          showCourses = false;
                          showProfile = true;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person_rounded,
                            color: showProfile
                                ? whiteColor.withOpacity(0.4)
                                : whiteColor,
                            size: showProfile ? 30 : 25,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'PROFILE',
                            style: TextStyle(
                              color: showProfile
                                  ? whiteColor.withOpacity(0.4)
                                  : whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
