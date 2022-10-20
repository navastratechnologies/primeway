import 'package:flutter/material.dart';
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
      {super.key, required this.courseName, required this.courseId, required this.userNumber, required this.userName, required this.userAddress, required this.userProfileImage, required this.userPayment, required this.userEmail, required this.userWalletId});

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  // final CollectionReference course =
  //     FirebaseFirestore.instance.collection('courses');

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: whiteColor,
        drawer:  NavigationDrawer(userAddress: widget.userAddress,
                            userEmail: widget.userEmail,
                            userName: widget.userName,
                            userNumber: widget.userNumber,
                            userPayment: widget.userPayment,
                            userProfileImage: widget.userProfileImage,
                            userWalletId: widget.userWalletId,),
        
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
        body:  TabBarView(
          children: [
            CourseChapterScreen(
              courseId: widget.courseId,
            ),
             CourseDiscussionScreen(courseId: widget.courseId),
          ],
        ),
      ),
    );
  }
}
