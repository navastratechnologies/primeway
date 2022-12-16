import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:primewayskills_app/view/dashboard/courses_screens/add_to_cart_screen.dart';
import 'package:primewayskills_app/view/dashboard/courses_screens/widgets/course_chapter_screen.dart';
import 'package:primewayskills_app/view/dashboard/courses_screens/widgets/course_discussion_screen.dart';
import 'package:primewayskills_app/view/drawer/sidebar.dart';
import 'package:primewayskills_app/view/helpers/colors.dart';

class CourseDetailScreen extends StatefulWidget {
  final String userNumber;
  final String userName;
  final String userAddress;
  final String userProfileImage;
  final String userPayment;
  final String userEmail;
  final String userWalletId;
  final String courseName;
  final String courseId;
  const CourseDetailScreen(
      {super.key,
      required this.courseName,
      required this.courseId,
      required this.userNumber,
      required this.userName,
      required this.userAddress,
      required this.userProfileImage,
      required this.userPayment,
      required this.userEmail,
      required this.userWalletId});

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  final CollectionReference chapters = FirebaseFirestore.instance
      .collection('courses')
      .doc()
      .collection('chapters');

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: whiteColor,
        drawer: NavigationDrawer(
          userAddress: widget.userAddress,
          userEmail: widget.userEmail,
          userName: widget.userName,
          userNumber: widget.userNumber,
          userPayment: widget.userPayment,
          userProfileImage: widget.userProfileImage,
          userWalletId: widget.userWalletId,
        ),
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.black.withOpacity(0.6),
          ),
          backgroundColor: whiteColor,
          title: Text(
            widget.courseName,
            style: TextStyle(
              fontSize: maxSize,
              color: Colors.black.withOpacity(0.6),
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddToCartScreen(
                      userAddress: widget.userAddress,
                      userEmail: widget.userEmail,
                      userName: widget.userName,
                      userNumber: widget.userNumber,
                      userPayment: widget.userPayment,
                      userProfileImage: widget.userProfileImage,
                      userWalletId: widget.userWalletId,
                      courseName: widget.courseName,
                      courseId: widget.courseId,
                    ),
                  ),
                );
              },
              child: SizedBox(
                width: 40,
                height: 100,
                child: Stack(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddToCartScreen(
                              userAddress: widget.userAddress,
                              userEmail: widget.userEmail,
                              userName: widget.userName,
                              userNumber: widget.userNumber,
                              userPayment: widget.userPayment,
                              userProfileImage: widget.userProfileImage,
                              userWalletId: widget.userWalletId,
                              courseName: widget.courseName,
                              courseId: widget.courseId,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.shopping_cart_rounded,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5, right: 5),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: primeColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Text(
                            '2',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          bottom: TabBar(
            indicatorColor: primeColor,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorWeight: 3,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
            labelColor: Colors.black.withOpacity(0.5),
            tabs: const [
              Tab(
                text: 'Chapters',
              ),
              Tab(
                text: 'Discussions',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            CourseChapterScreen(
              courseId: widget.courseId,
              courseName: widget.courseName,
              userAddress: widget.userAddress,
              userEmail: widget.userEmail,
              userName: widget.userName,
              userNumber: widget.userNumber,
              userPayment: widget.userPayment,
              userProfileImage: widget.userProfileImage,
              userWalletId: widget.userWalletId,
            ),
            CourseDiscussionScreen(
              courseId: widget.courseId,
              courseName: widget.courseName,
              userAddress: widget.userAddress,
              userEmail: widget.userEmail,
              userName: widget.userName,
              userNumber: widget.userNumber,
              userPayment: widget.userPayment,
              userProfileImage: widget.userProfileImage,
              userWalletId: widget.userWalletId,
            ),
          ],
        ),
        bottomNavigationBar: Container(
          width: MediaQuery.of(context).size.width,
          height: 70,
          decoration: BoxDecoration(
            color: whiteColor,
            boxShadow: [
              BoxShadow(
                color: primeColor.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              MaterialButton(
                color: purpleColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onPressed: () {},
                child: Text(
                  'Add To Cart',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: whiteColor,
                    fontSize: 16,
                  ),
                ),
              ),
              MaterialButton(
                color: primeColor2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onPressed: () {},
                child: Text(
                  'Buy Now',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: whiteColor,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
