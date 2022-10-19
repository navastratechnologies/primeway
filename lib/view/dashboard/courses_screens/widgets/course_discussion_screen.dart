import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:primewayskills_app/view/helpers/colors.dart';

class CourseDiscussionScreen extends StatefulWidget {
  final String courseId;
  const CourseDiscussionScreen({super.key, required this.courseId});

  @override
  State<CourseDiscussionScreen> createState() => _CourseDiscussionScreenState();
}

class _CourseDiscussionScreenState extends State<CourseDiscussionScreen> {
  TextEditingController massegeController = TextEditingController();

  final CollectionReference discussion =
      FirebaseFirestore.instance.collection('discussion');
  String userName = 'Shindhu';
  String userImage =
      'https://images.unsplash.com/photo-1666017685005-64e7d56aa4f4?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80';
  String userId = '123456780';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                // padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: primeColor.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: massegeController,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection('courses')
                            .doc(widget.courseId)
                            .collection('discussion')
                            .add({
                          'user_massege': massegeController.text,
                          'user_name': userName,
                          'user_image': userImage,
                          'user_time':
                              '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day} ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}',
                          'user_id': userId,
                        }).whenComplete(() {
                          setState(() {
                            massegeController.clear();
                            FocusManager.instance.primaryFocus?.unfocus();
                          });
                        });
                      },
                      icon: const Icon(Icons.send_sharp),
                    ),
                    border: InputBorder.none,
                    hintText: 'Ask your Queries',
                    prefixIcon: const Icon(Icons.person_rounded),
                  ),
                ),
              ),
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('courses')
                  .doc(widget.courseId)
                  .collection('discussion')
                  .orderBy('user_time', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (streamSnapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: streamSnapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final DocumentSnapshot documentSnapshot =
                          streamSnapshot.data!.docs[index];
                      // Timestamp timestamp = documentSnapshot['user_time'];
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                color: primeColor.withOpacity(0.1),
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      documentSnapshot['user_image'] == null
                                          ? Icon(
                                              Icons.person_rounded,
                                              size: 30,
                                              color:
                                                  Colors.black.withOpacity(0.4),
                                            )
                                          : Container(
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                    documentSnapshot[
                                                        'user_image'],
                                                  ),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                      const SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            documentSnapshot['user_name'],
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            documentSnapshot['user_time'],
                                            // timestamp.toDate().toString(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12,
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: Colors.black.withOpacity(0.4),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: Text(
                                  documentSnapshot['user_massege'],
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.4),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
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
          ],
        ),
      ),
    );
  }
}
