import 'package:flutter/material.dart';
import 'package:primewayskills_app/view/dashboard/courses_screens/widgets/course_chapter_screen.dart';
import 'package:primewayskills_app/view/dashboard/courses_screens/widgets/course_discussion_screen.dart';
import 'package:primewayskills_app/view/drawer/sidebar.dart';
import 'package:primewayskills_app/view/helpers/colors.dart';

class CourseDetailScreen extends StatefulWidget {
  const CourseDetailScreen({super.key});

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: whiteColor,
        drawer: const NavigationDrawer(),
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.black.withOpacity(0.6),
          ),
          backgroundColor: whiteColor,
          title: Text(
            'Course Name',
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
        body: const TabBarView(
          children: [
            CourseChapterScreen(),
            CourseDiscussionScreen(),
          ],
        ),
      ),
    );
  }
}
