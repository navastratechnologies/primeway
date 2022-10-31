import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:primewayskills_app/view/helpers/colors.dart';
import 'package:primewayskills_app/view/helpers/helping_widgets.dart';

class AffiliateLinksScreen extends StatefulWidget {
  const AffiliateLinksScreen({super.key});

  @override
  State<AffiliateLinksScreen> createState() => _AffiliateLinksScreenState();
}

class _AffiliateLinksScreenState extends State<AffiliateLinksScreen> {
  final CollectionReference course =
      FirebaseFirestore.instance.collection('courses');
  @override
  Widget build(BuildContext context) {
    // var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: whiteColor,
      body: StreamBuilder(
          stream: course.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      width: width,
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 50,
                                  width: width / 4,
                                  child: Image(
                                    image:
                                        NetworkImage(documentSnapshot['image']),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: width / 1.75,
                                      child:
                                          paragraphWidgetMethodForResourcesBoldTitle(
                                        documentSnapshot['name'],
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      width: width / 1.74,
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: primeColor,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: primeColor2.withOpacity(0.1),
                                            blurRadius: 10,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        documentSnapshot['affilate_link'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: whiteColor.withOpacity(0.5),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width: width,
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: primeColor2,
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                MaterialButton(
                                  padding: const EdgeInsets.all(2),
                                  onPressed: () {},
                                  child: Row(
                                    children: [
                                      Text(
                                        'Copy Link',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: whiteColor.withOpacity(0.5),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(width: 5),
                                      Icon(
                                        Icons.copy_rounded,
                                        color: whiteColor,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ),
                                MaterialButton(
                                  padding: const EdgeInsets.all(2),
                                  onPressed: () {},
                                  child: Row(
                                    children: [
                                      Text(
                                        'Share Link',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: whiteColor.withOpacity(0.5),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(width: 5),
                                      Icon(
                                        Icons.share_rounded,
                                        color: whiteColor,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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
          }),
    );
  }
}
