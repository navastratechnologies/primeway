import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:primewayskills_app/view/dashboard/courses_screens/course_detail_screen.dart';
import 'package:primewayskills_app/view/helpers/colors.dart';

class CoursesScreen extends StatefulWidget {
  final String userNumber;
  final String userName;
  final String userAddress;
  final String userProfileImage;
  final String userPayment;
  final String userEmail;
  final String userWalletId;
  const CoursesScreen(
      {super.key,
      required this.userNumber,
      required this.userName,
      required this.userAddress,
      required this.userProfileImage,
      required this.userPayment,
      required this.userEmail,
      required this.userWalletId});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  final CollectionReference course =
      FirebaseFirestore.instance.collection('courses');

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: whiteColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: TabBar(
            indicatorColor: primeColor,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorWeight: 3,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
            labelColor: Colors.black.withOpacity(0.5),
            tabs: const [
              Tab(
                text: 'Courses',
              ),
              Tab(
                text: 'My Courses',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            StreamBuilder(
                stream: course.snapshots(),
                builder:
                    (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                  if (streamSnapshot.hasData) {
                    return ListView.builder(
                      itemCount: streamSnapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final DocumentSnapshot documentSnapshot =
                            streamSnapshot.data!.docs[index];
                        return Padding(
                          padding: const EdgeInsets.all(10),
                          child: InkWell(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CourseDetailScreen(
                                    userAddress: widget.userAddress,
                                    userEmail: widget.userEmail,
                                    userName: widget.userName,
                                    userNumber: widget.userNumber,
                                    userPayment: widget.userPayment,
                                    userProfileImage: widget.userProfileImage,
                                    userWalletId: widget.userWalletId,
                                    courseName: documentSnapshot['name'],
                                    courseId: documentSnapshot.id),
                              ),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: whiteColor,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: primeColor.withOpacity(0.1),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                            color:
                                                Colors.black.withOpacity(0.2),
                                            width: 2,
                                          ),
                                        ),
                                        child: Text(
                                          'COURSE',
                                          style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.6),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(2),
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.green,
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          const Text(
                                            'LIVE NOW',
                                            style: TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.8,
                                            child: Text(
                                              documentSnapshot['name'],
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.person_rounded,
                                                color: Colors.black
                                                    .withOpacity(0.6),
                                                size: 16,
                                              ),
                                              const SizedBox(width: 5),
                                              Text(
                                                documentSnapshot['author_name'],
                                                style: TextStyle(
                                                  color: Colors.black
                                                      .withOpacity(0.4),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 20),
                                          Text(
                                            'Rs. ${documentSnapshot['base_ammount']}',
                                            style: const TextStyle(
                                              color: Colors.amber,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        height: 60,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          color: primeColor,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                documentSnapshot['image']),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.userNumber)
                    .collection('courses')
                    // .doc()
                    // .collection('chapters')
                    .snapshots(),
                builder:
                    (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                  if (streamSnapshot.hasData) {
                    return ListView.builder(
                      itemCount: streamSnapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final DocumentSnapshot documentSnapshot =
                            streamSnapshot.data!.docs[index];
                        return Padding(
                          padding: const EdgeInsets.all(10),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CourseDetailScreen(
                                      userAddress: widget.userAddress,
                                      userEmail: widget.userEmail,
                                      userName: widget.userName,
                                      userNumber: widget.userNumber,
                                      userPayment: widget.userPayment,
                                      userProfileImage: widget.userProfileImage,
                                      userWalletId: widget.userWalletId,
                                      courseName: documentSnapshot['name'],
                                      courseId: documentSnapshot['courses_id']),
                                ),
                              );
                              log('userAddress: ${documentSnapshot['courses_id']}');
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: whiteColor,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: primeColor.withOpacity(0.1),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                            color:
                                                Colors.black.withOpacity(0.2),
                                            width: 2,
                                          ),
                                        ),
                                        child: Text(
                                          'COURSE',
                                          style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.6),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(2),
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.green,
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          const Text(
                                            'LIVE NOW',
                                            style: TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.8,
                                            child: Text(
                                              documentSnapshot['name'],
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.person_rounded,
                                                color: Colors.black
                                                    .withOpacity(0.6),
                                                size: 16,
                                              ),
                                              const SizedBox(width: 5),
                                              Text(
                                                documentSnapshot['author_name'],
                                                style: TextStyle(
                                                  color: Colors.black
                                                      .withOpacity(0.4),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Container(
                                        height: 60,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          color: primeColor,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                documentSnapshot['image']),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
