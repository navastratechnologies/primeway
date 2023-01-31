// ignore_for_file: unused_field

import 'package:flutter/material.dart';

class CourseDocumentScreen extends StatefulWidget {
  final String courseId;
  final String documentId;
  final String documentTitle;
  final String documentUrl;
  final String documentDescription;
  final String userNumber;
  final String userName;
  final String userAddress;
  final String userProfileImage;
  final String userPayment;
  final String userEmail;
  final String userWalletId;
  final String courseName;

  const CourseDocumentScreen({
    super.key,
    required this.courseId,
    required this.documentId,
    required this.documentTitle,
    required this.documentUrl,
    required this.documentDescription,
    required this.userNumber,
    required this.userName,
    required this.userAddress,
    required this.userProfileImage,
    required this.userPayment,
    required this.userEmail,
    required this.userWalletId,
    required this.courseName,
  });

  @override
  State<CourseDocumentScreen> createState() => _CourseDocumentScreenState();
}

class _CourseDocumentScreenState extends State<CourseDocumentScreen> {
  bool showControls = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
          // body: PdfView(widget.documentUrl),
          // body: SingleChildScrollView(
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [

          //       SizedBox(
          //         height: displayHeight(context) / 3,
          //         width: displayWidth(context),
          //         child: HtmlWidget(widget.documentUrl),
          //       ),

          //       Padding(
          //         padding:
          //             const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
          //         child: Text(
          //           widget.documentTitle,
          //           style: const TextStyle(
          //             fontWeight: FontWeight.bold,
          //             fontSize: 18,
          //           ),
          //         ),
          //       ),
          //       DefaultTabController(
          //         length: 2,
          //         initialIndex: 0,
          //         child: SizedBox(
          //           height: MediaQuery.of(context).size.height / 1.6,
          //           width: MediaQuery.of(context).size.width,
          //           child: Column(
          //             children: [
          //               TabBar(
          //                 indicatorColor: primeColor,
          //                 labelColor: Colors.black,
          //                 tabs: const [
          //                   Tab(
          //                     text: 'Discussions',
          //                   ),
          //                   Tab(
          //                     text: 'Description',
          //                   ),
          //                 ],
          //               ),
          //               Expanded(
          //                 child: TabBarView(
          //                   children: [
          //                     CourseDiscussionScreen(
          //                       courseId: widget.courseId,
          //                       courseName: widget.courseName,
          //                       userAddress: widget.userAddress,
          //                       userEmail: widget.userEmail,
          //                       userName: widget.userName,
          //                       userNumber: widget.userNumber,
          //                       userPayment: widget.userPayment,
          //                       userProfileImage: widget.userProfileImage,
          //                       userWalletId: widget.userWalletId,
          //                     ),
          //                     Padding(
          //                       padding: const EdgeInsets.all(20),
          //                       child: Text(widget.documentDescription),
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          ),
    );
  }
}
