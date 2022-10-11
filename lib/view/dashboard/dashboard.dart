import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:primewayskills_app/view/appbar_screens/notification_screen.dart';
import 'package:primewayskills_app/view/appbar_screens/profile_edit_screen.dart';
import 'package:primewayskills_app/view/dashboard/collaboration_screen.dart';
import 'package:primewayskills_app/view/dashboard/home_screen.dart';
import 'package:primewayskills_app/view/dashboard/profile_screen.dart';
import 'package:primewayskills_app/view/drawer/sidebar.dart';
import 'package:primewayskills_app/view/helpers/colors.dart';

class Dashboard extends StatefulWidget {
  final String userName;
  final String userId;
  const Dashboard({Key? key,  required this.userName, required this.userId}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentIndex = 0;
  late PageController _pagecontroller;
  @override
  void initState() {
    super.initState();
    _pagecontroller = PageController();
  }

  @override
  void dispose() {
    _pagecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavigationDrawer(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: whiteColor),
        backgroundColor: whiteColor,
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Hi, ',
                style: TextStyle(
                  fontSize: maxSize,
                  color: whiteColor.withOpacity(0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextSpan(
                text: widget.userName,
                style: TextStyle(
                  fontSize: maxSize,
                  color: whiteColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.person,
              color: whiteColor,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileEditScreen(userId: '', userName: '',),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.notifications,
              color: whiteColor,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SizedBox.expand(
        child: PageView(
          controller: _pagecontroller,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          children: const [
            Homescreen(),
            CollaborationScreen(),
            ProfileScreen(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        showElevation: true,
        backgroundColor: primeColor,
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() {
            _pagecontroller.jumpToPage(index);
          });
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            activeColor: Colors.grey,
            title: Text(
              "Home",
              style: TextStyle(
                color: whiteColor,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            icon: Icon(
              Icons.home,
              color: whiteColor,
            ),
          ),
          BottomNavyBarItem(
            activeColor: Colors.grey,
            title: Text(
              "Collabration",
              style: TextStyle(
                color: whiteColor,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            icon: Icon(
              Icons.meeting_room,
              color: whiteColor,
            ),
          ),
          BottomNavyBarItem(
            activeColor: Colors.grey,
            title: Text(
              "Profile",
              style: TextStyle(
                color: whiteColor,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            icon: Icon(
              Icons.manage_accounts,
              color: whiteColor,
            ),
          ),
        ],
      ),
    );
  }
}
