import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:primewayskills_app/view/dashboard/home.dart';
import 'package:primewayskills_app/view/drawer/sidebar.dart';
import 'package:primewayskills_app/view/helpers/carousel.dart';
import 'package:primewayskills_app/view/helpers/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        // home: CarouselDemo());


        home: Scaffold(
          drawer: NavigationDrawer(),
          appBar: AppBar(
            iconTheme: IconThemeData(color: primeColor),
            elevation: 0,
            backgroundColor: Colors.white,
            title: Text(
              "primewayskills",
              style: TextStyle(
                color: primeColor,
                fontSize: 18,
                shadows: <Shadow>[
                  Shadow(
                    color: Colors.grey,
                    
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.person,
                  color: primeColor,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(
                  Icons.notifications,
                  color: primeColor,
                ),
                onPressed: () {},
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
              children: [
                Homescreen(),
                Container(
                  color: whiteColor,
                ),
                Container(
                  color: whiteColor,
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavyBar(
            showElevation: true,
            backgroundColor: Colors.white,
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
                      color: primeColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                ),
                icon: Icon(
                  Icons.home,
                  color: primeColor,
                ),


                
              ),
              BottomNavyBarItem(
                activeColor: Colors.grey,
                title: Text(
                  "Collabration",
                  style: TextStyle(
                      color: primeColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                ),
                icon: Icon(Icons.meeting_room, color: primeColor),
              ),
              BottomNavyBarItem(
                activeColor: Colors.grey,
                title: Text(
                  "Profile",
                  style: TextStyle(
                      color: primeColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                ),
                icon: Icon(Icons.manage_accounts, color: primeColor),

              ),
            ],
          ),
        ));
  
  }
}
