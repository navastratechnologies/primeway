// ignore_for_file: avoid_print, avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:primewayskills_app/view/dashboard/courses_screens/widgets/course_video_screen.dart';
import 'package:primewayskills_app/view/helpers/alert_deialogs.dart';
import 'package:primewayskills_app/view/helpers/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class CourseChapterScreen extends StatefulWidget {
  final String courseId;
  final String userNumber;
  final String userName;
  final String userAddress;
  final String userProfileImage;
  final String userPayment;
  final String userEmail;
  final String userWalletId;
  final String courseName;
  final String pageType;
  final String isLive;

  const CourseChapterScreen({
    super.key,
    required this.courseId,
    required this.userNumber,
    required this.userName,
    required this.userAddress,
    required this.userProfileImage,
    required this.userPayment,
    required this.userEmail,
    required this.userWalletId,
    required this.courseName,
    required this.pageType,
    required this.isLive,
  });

  @override
  State<CourseChapterScreen> createState() => _CourseChapterScreenState();
}

class _CourseChapterScreenState extends State<CourseChapterScreen> {
  String totalVideo = '';
  String videoCount = '';
  List data = [];

  Future<void> _launchUrl(url) async {
    if (!await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  // Future<void> downloadFile(String url, String fileName) async {
  //   var status = await Permission.storage.status;
  //   if (status.isDenied || status.isRestricted) {
  //     await Permission.storage.request();
  //   }
  //   var directory = await getExternalStorageDirectory();
  //   var downloadDirectory = Directory(
  //       "${directory!.parent.parent.parent.parent.path}/Prime-Courses");
  //   if (!await downloadDirectory.exists()) {
  //     downloadDirectory.create();
  //   }
  //   var file = File('$downloadDirectory/${fileName.replaceAll(' ', '-')}.mp4');
  //   var response = await http.get(Uri.parse(url));
  //   await file.writeAsBytes(response.bodyBytes);
  //   if (await file.exists()) {
  //     log('file is downloaded ${file.path}');
  //     await file.open();
  //   } else {
  //     log('file is not downloaded');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('courses')
            .doc(widget.courseId)
            .collection('chapters')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: ExpansionTile(
                    leading: Icon(
                      Icons.fact_check_rounded,
                      color: primeColor2,
                    ),
                    title: Text(
                      documentSnapshot.id,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_drop_down_rounded,
                      color: primeColor2,
                    ),
                    subtitle: Text(
                      "${documentSnapshot['video_count']} Videos",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: Colors.black.withOpacity(0.3),
                      ),
                    ),
                    children: [
                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('courses')
                            .doc(widget.courseId)
                            .collection('chapters')
                            .doc(documentSnapshot.id)
                            .collection('videos')
                            .snapshots(),
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot> streamSnapshot1) {
                          if (streamSnapshot1.hasData) {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: streamSnapshot1.data!.docs.length,
                              itemBuilder: (context, index) {
                                final DocumentSnapshot documentSnapshot1 =
                                    streamSnapshot1.data!.docs[index];
                                return Padding(
                                  padding: const EdgeInsets.all(14),
                                  child: InkWell(
                                    onTap: widget.isLive != "true"
                                        ? () => alertDialogWidget(
                                            context,
                                            primeColor,
                                            "Video can't be played. Please contact support for help")
                                        : widget.pageType != "my_course"
                                            ? () => alertDialogWidget(
                                                context,
                                                primeColor,
                                                "Please purchase to view contents")
                                            : () => documentSnapshot1['url']
                                                        .toString()
                                                        .contains('pdf') ||
                                                    documentSnapshot1['url']
                                                        .toString()
                                                        .contains('doc') ||
                                                    documentSnapshot1['url']
                                                        .toString()
                                                        .contains('docx') ||
                                                    documentSnapshot1['url']
                                                        .toString()
                                                        .contains('png') ||
                                                    documentSnapshot1['url']
                                                        .toString()
                                                        .contains('jpg') ||
                                                    documentSnapshot1['url']
                                                        .toString()
                                                        .contains('jpeg')
                                                ? _launchUrl(
                                                    documentSnapshot1['url'])
                                                // Navigator.push(
                                                //     context,
                                                //     MaterialPageRoute(
                                                //       builder: (context) =>
                                                //           CourseDocumentScreen(
                                                //         documentId:
                                                //             documentSnapshot1.id,
                                                //         documentUrl:
                                                //             '<iframe src="${documentSnapshot1['url']}" title="" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>',
                                                //         documentTitle:
                                                //             documentSnapshot1['title'],
                                                //         documentDescription:
                                                //             documentSnapshot1[
                                                //                 'description'],
                                                //         courseId: widget.courseId,
                                                //         courseName: widget.courseName,
                                                //         userAddress: widget.userAddress,
                                                //         userEmail: widget.userEmail,
                                                //         userName: widget.userName,
                                                //         userNumber: widget.userNumber,
                                                //         userPayment: widget.userPayment,
                                                //         userProfileImage:
                                                //             widget.userProfileImage,
                                                //         userWalletId:
                                                //             widget.userWalletId,
                                                //       ),
                                                //     ),
                                                //   )

                                                : Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          CourseVideoScreen(
                                                        videoId:
                                                            documentSnapshot1
                                                                .id,
                                                        videoUrl:
                                                            documentSnapshot1[
                                                                'url'],
                                                        videoTitle:
                                                            documentSnapshot1[
                                                                'title'],
                                                        videoDescription:
                                                            documentSnapshot1[
                                                                'description'],
                                                        courseId:
                                                            widget.courseId,
                                                        courseName:
                                                            widget.courseName,
                                                        userAddress:
                                                            widget.userAddress,
                                                        userEmail:
                                                            widget.userEmail,
                                                        userName:
                                                            widget.userName,
                                                        userNumber:
                                                            widget.userNumber,
                                                        userPayment:
                                                            widget.userPayment,
                                                        userProfileImage: widget
                                                            .userProfileImage,
                                                        userWalletId:
                                                            widget.userWalletId,
                                                      ),
                                                    ),
                                                  ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(3),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.black
                                                    .withOpacity(0.2),
                                              ),
                                              child: Icon(
                                                widget.pageType != "my_course"
                                                    ? Icons.lock_rounded
                                                    : widget.isLive != "true"
                                                        ? Icons.error_rounded
                                                        : documentSnapshot1[
                                                                        'url']
                                                                    .toString()
                                                                    .contains(
                                                                        'png') ||
                                                                documentSnapshot1[
                                                                        'url']
                                                                    .toString()
                                                                    .contains(
                                                                        'jpg') ||
                                                                documentSnapshot1[
                                                                        'url']
                                                                    .toString()
                                                                    .contains(
                                                                        'jpeg')
                                                            ? Icons.image
                                                            : documentSnapshot1['url'].toString().contains('pdf') ||
                                                                    documentSnapshot1[
                                                                            'url']
                                                                        .toString()
                                                                        .contains(
                                                                            'doc') ||
                                                                    documentSnapshot1[
                                                                            'url']
                                                                        .toString()
                                                                        .contains(
                                                                            'docx')
                                                                ? Icons
                                                                    .description_rounded
                                                                : documentSnapshot1['url']
                                                                            .toString()
                                                                            .contains(
                                                                                'mp3') ||
                                                                        documentSnapshot1['url']
                                                                            .toString()
                                                                            .contains(
                                                                                'wav') ||
                                                                        documentSnapshot1['url']
                                                                            .toString()
                                                                            .contains(
                                                                                'aac') ||
                                                                        documentSnapshot1['url']
                                                                            .toString()
                                                                            .contains(
                                                                                'flac')
                                                                    ? Icons
                                                                        .audiotrack_rounded
                                                                    : Icons
                                                                        .play_arrow,
                                                size: 16,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  documentSnapshot1['title'],
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                    color: Colors.black
                                                        .withOpacity(0.5),
                                                  ),
                                                ),
                                                const SizedBox(height: 3),
                                                documentSnapshot1['duration']
                                                        .toString()
                                                        .isEmpty
                                                    ? const SizedBox()
                                                    : Text(
                                                        documentSnapshot1[
                                                            'duration'],
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 12,
                                                          color: Colors.black
                                                              .withOpacity(0.3),
                                                        ),
                                                      ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
