import 'package:flutter/material.dart';
import 'package:primewayskills_app/view/dashboard/courses_screens/widgets/course_chapter_screen.dart';
import 'package:primewayskills_app/view/dashboard/courses_screens/widgets/course_discussion_screen.dart';
import 'package:primewayskills_app/view/drawer/sidebar.dart';
import 'package:primewayskills_app/view/helpers/colors.dart';

class CourseDetailScreen extends StatefulWidget {
  final String name;
  final String courseId;
  const CourseDetailScreen(
      {super.key, required this.name, required this.courseId});

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
        drawer: const NavigationDrawer(),
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.black.withOpacity(0.6),
          ),
          backgroundColor: whiteColor,
          title: Text(
            widget.name,
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
