// ignore_for_file: avoid_print, avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:primewayskills_app/view/dashboard/courses_screens/widgets/course_video_screen.dart';
import 'package:primewayskills_app/view/helpers/colors.dart';

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

  const CourseChapterScreen(
      {super.key,
      required this.courseId,
      required this.userNumber,
      required this.userName,
      required this.userAddress,
      required this.userProfileImage,
      required this.userPayment,
      required this.userEmail,
      required this.userWalletId,
      required this.courseName});

  @override
  State<CourseChapterScreen> createState() => _CourseChapterScreenState();
}

class _CourseChapterScreenState extends State<CourseChapterScreen> {
  String totalVideo = '';
  String videoCount = '';
  List data = [];
  // String id = 'chapter1';

  // final firestoreInstance = FirebaseFirestore.instance;

  // void retrieveSubCol() {
  //   firestoreInstance.collection('courses').get().then((value) {
  //     for (var result in value.docs) {
  //       firestoreInstance
  //           .collection('courses')
  //           .doc(widget.courseId)
  //           .collection('chapters')
  //           .get()
  //           .then((subcol) {
  //         for (var element in subcol.docs) {
  //           // log('data is ${element.data()}');
  //         }
  //       });
  //     }
  //   });
  // }

  //     .doc()
  //     .parent
  //     .firestore
  //     .collection('chapters');

  //     Future<void> getUserProfileData() async {
  //   FirebaseFirestore.instance
  //       .collection('users')
  //       .doc()
  //       .get()
  //       .then((value) {
  //     log('name is ${value.get('name')}');
  //     setState(() {
  //       name = value.get('name');
  //       address = value.get('address');
  //       profileImage = value.get('profile_pic');
  //       payment = value.get('payments');
  //       number = value.get('phone_number');
  //       email = value.get('email');
  //     });
  //   });
  // }

  // Future<void> getTransCount() async {
  //   FirebaseFirestore.instance
  //       .collection('courses')
  //       .doc(widget.courseId)
  //       .collection('chapters')
  //       .doc(id)
  //       .collection('videos')
  //       // .doc()
  //       // .collection('video')
  //       .get()
  //       .then((QuerySnapshot snapshot) {
  //     log('total is ${snapshot.docs.length}');
  //     setState(() {
  //       videoCount = '${snapshot.docs.length}';
  //     });
  //   });
  // }

  // @override
  // void initState() {
  //   getTransCount();
  //   super.initState();
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
                      leading: const Icon(Icons.fact_check_rounded),
                      title: Text(
                        documentSnapshot.id,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
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
                                        onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                CourseVideoScreen(
                                              videoId: documentSnapshot1.id,
                                              videoUrl:
                                                  documentSnapshot1['url'],
                                              videoTitle:
                                                  documentSnapshot1['title'],
                                              videoDescription:
                                                  documentSnapshot1[
                                                      'description'],
                                              courseId: widget.courseId,
                                              courseName: widget.courseName,
                                              userAddress: widget.userAddress,
                                              userEmail: widget.userEmail,
                                              userName: widget.userName,
                                              userNumber: widget.userNumber,
                                              userPayment: widget.userPayment,
                                              userProfileImage:
                                                  widget.userProfileImage,
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
                                                  padding:
                                                      const EdgeInsets.all(3),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.black
                                                        .withOpacity(0.2),
                                                  ),
                                                  child: const Icon(
                                                    Icons.play_arrow,
                                                    size: 16,
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      documentSnapshot1.id,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 14,
                                                        color: Colors.black
                                                            .withOpacity(0.5),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 3),
                                                    Text(
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
                                            Icon(
                                              Icons.downloading_rounded,
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            }),
                      ],
                    ),
                  );
                },
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
