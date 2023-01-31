import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:primewayskills_app/view/dashboard/homePage_screens/collaboration_internal_screen.dart';
import 'package:primewayskills_app/view/helpers/colors.dart';
import 'package:primewayskills_app/view/helpers/loader.dart';
import 'package:primewayskills_app/view/helpers/responsive_size_helper.dart';

class CreaterProgramScreen extends StatefulWidget {
  final String categorey;
  final String userNumber;

  const CreaterProgramScreen({
    Key? key,
    required this.categorey,
    required this.userNumber,
  }) : super(key: key);

  @override
  State<CreaterProgramScreen> createState() => _CreaterProgramScreenState();
}

class _CreaterProgramScreenState extends State<CreaterProgramScreen> {
  final CollectionReference collaboration =
      FirebaseFirestore.instance.collection('collaboration');

  final CollectionReference creatorProgramCategory =
      FirebaseFirestore.instance.collection('creator_program_category');

  String category = '';

  @override
  void initState() {
    setState(() {
      category = widget.categorey;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black.withOpacity(0.6),
        ),
        backgroundColor: whiteColor,
        title: Text(
          "Creator Programs",
          style: TextStyle(
            fontSize: maxSize,
            color: Colors.black.withOpacity(0.6),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 20),
                StreamBuilder(
                  stream: creatorProgramCategory.snapshots(),
                  builder:
                      (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                    if (streamSnapshot.hasData) {
                      return SizedBox(
                        height: 50,
                        width: displayWidth(context),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: streamSnapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot documentSnapshot =
                                streamSnapshot.data!.docs[index];
                            return Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        category = documentSnapshot['category'];
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 16,
                                      ),
                                      decoration: BoxDecoration(
                                        color: category.toUpperCase() ==
                                                documentSnapshot['category']
                                                    .toString()
                                                    .toUpperCase()
                                            ? purpleColor
                                            : whiteColor,
                                        border: Border.all(
                                          width: 1,
                                          color: category.toUpperCase() ==
                                                  documentSnapshot['category']
                                                      .toString()
                                                      .toUpperCase()
                                              ? purpleColor
                                              : primeColor2,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        documentSnapshot['category'],
                                        style: TextStyle(
                                          color: category.toUpperCase() ==
                                                  documentSnapshot['category']
                                                      .toString()
                                                      .toUpperCase()
                                              ? whiteColor
                                              : primeColor2,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      );
                    }
                    return Container();
                  },
                ),
                StreamBuilder(
                    stream: collaboration.snapshots(),
                    builder:
                        (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                      if (streamSnapshot.hasData) {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: streamSnapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final DocumentSnapshot documentSnapshot =
                                streamSnapshot.data!.docs[index];
                            if (documentSnapshot['categories']
                                .toString()
                                .toUpperCase()
                                .contains(
                                  category.toUpperCase(),
                                )) {
                              return Padding(
                                padding: const EdgeInsets.all(12),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CollaborationInternalScreen(
                                          collabId: documentSnapshot.id,
                                          userNumber: widget.userNumber,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    shadowColor: Colors.black.withOpacity(0.4),
                                    color: whiteColor,
                                    elevation: 5,
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              height: 10,
                                              width: 4,
                                              decoration: BoxDecoration(
                                                color: documentSnapshot[
                                                            'status'] ==
                                                        "1"
                                                    ? primeColor2
                                                    : primeColor,
                                              ),
                                            ),
                                            const SizedBox(width: 15),
                                            Text(
                                              documentSnapshot['status'] == "1"
                                                  ? 'Applications Open'
                                                  : 'Application Closed',
                                              style: TextStyle(
                                                color: documentSnapshot[
                                                            'status'] ==
                                                        "1"
                                                    ? purpleColor
                                                    : primeColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(14),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Container(
                                                height: 50,
                                                width: width / 3.5,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.black
                                                        .withOpacity(0.2),
                                                  ),
                                                ),
                                                child: Image(
                                                  image: NetworkImage(
                                                    documentSnapshot['image'],
                                                  ),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width: width / 2,
                                                    child: Text(
                                                      documentSnapshot[
                                                          'titles'],
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  SizedBox(
                                                    width: width / 2,
                                                    child: Text(
                                                      documentSnapshot[
                                                                  'requirement_type'] ==
                                                              "insta"
                                                          ? "${documentSnapshot['required_followers_from']} to ${documentSnapshot['required_followers_to']} followers"
                                                          : "${documentSnapshot['required_followers_from']} to ${documentSnapshot['required_followers_to']} subscribers",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 13,
                                                        color: Colors.black
                                                            .withOpacity(0.3),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Row(
                                                    children: [
                                                      FaIcon(
                                                        documentSnapshot[
                                                                    'requirement_type'] ==
                                                                "insta"
                                                            ? FontAwesomeIcons
                                                                .instagram
                                                            : FontAwesomeIcons
                                                                .youtube,
                                                        color: primeColor,
                                                        size: 16,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 6),
                                                        child: Container(
                                                          height: 10,
                                                          width: 1.5,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.2),
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        documentSnapshot[
                                                                    'collaboration_type']
                                                                .toString()[0]
                                                                .toUpperCase() +
                                                            documentSnapshot[
                                                                    'collaboration_type']
                                                                .toString()
                                                                .substring(1),
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 12,
                                                          letterSpacing: 0.3,
                                                          color: Colors.black
                                                              .withOpacity(0.4),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        documentSnapshot['status'] == "0"
                                            ? Container()
                                            : Container(
                                                height: 50,
                                                width: width,
                                                padding:
                                                    const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  color: primeColor2
                                                      .withOpacity(0.3),
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(10),
                                                    bottomRight:
                                                        Radius.circular(10),
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'Apply to get Shortlisted',
                                                      style: TextStyle(
                                                        fontSize: minSize - 1,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        letterSpacing: 0.2,
                                                      ),
                                                    ),
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5),
                                                      decoration: BoxDecoration(
                                                        color: primeColor2,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Center(
                                                        child: Icon(
                                                          Icons
                                                              .arrow_forward_ios,
                                                          color: whiteColor,
                                                          size: 10,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              // return Padding(
                              //   padding: const EdgeInsets.all(20),
                              //   child: Column(
                              //     children: [
                              //       Lottie.asset('assets/json/not_found.json'),
                              //       SizedBox(
                              //         width: displayWidth(context) / 1.5,
                              //         child: Text(
                              //           'Not Found Any Collaboration related to category you selected',
                              //           style: TextStyle(
                              //             color: Colors.black.withOpacity(0.6),
                              //             fontWeight: FontWeight.bold,
                              //             letterSpacing: 1,
                              //           ),
                              //           textAlign: TextAlign.center,
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // );
                              return Container();
                            }
                          },
                        );
                      }
                      return const LoaderWidget();
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
