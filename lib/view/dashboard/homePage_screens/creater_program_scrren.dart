import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:primewayskills_app/view/dashboard/homePage_screens/collaboration_internal_screen.dart';
import 'package:primewayskills_app/view/helpers/colors.dart';

class CreaterProgramScreen extends StatefulWidget {
  final String titles, categorey;
  final String userNumber;
  final String userName;
  final String userAddress;
  final String userProfileImage;
  final String userPayment;
  final String userEmail;
  final String userWalletId;
  final String userLanguage;
  final String userFollowers;

  const CreaterProgramScreen(
      {Key? key,
      required this.titles,
      required this.categorey,
      required this.userNumber,
      required this.userName,
      required this.userAddress,
      required this.userProfileImage,
      required this.userPayment,
      required this.userEmail,
      required this.userWalletId,
      required this.userLanguage, required this.userFollowers})
      : super(key: key);

  @override
  State<CreaterProgramScreen> createState() => _CreaterProgramScreenState();
}

class _CreaterProgramScreenState extends State<CreaterProgramScreen> {
  final CollectionReference collaboration =
      FirebaseFirestore.instance.collection('collaboration');

  bool explorePage = false;
  bool appliedPage = false;
  bool shortlistedPage = false;

  @override
  void initState() {
    setState(() {
      collaboration.where('categorey', isEqualTo: widget.categorey);
      log('log is ${widget.categorey}');
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
          widget.titles,
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
                const SizedBox(height: 10),
                SizedBox(
                  height: 50,
                  width: width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            explorePage = true;
                            appliedPage = false;
                            shortlistedPage = false;
                          });
                          log('log is $explorePage $appliedPage $shortlistedPage');
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            color: explorePage ? primeColor : whiteColor,
                            border: Border.all(
                              width: 2,
                              color: primeColor,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Explore | 148',
                            style: TextStyle(
                              color: explorePage ? whiteColor : primeColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            explorePage = false;
                            appliedPage = true;
                            shortlistedPage = false;
                          });
                          log('log is $explorePage $appliedPage $shortlistedPage');
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            color: appliedPage ? primeColor : whiteColor,
                            border: Border.all(
                              width: 2,
                              color: primeColor,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Applied',
                            style: TextStyle(
                              color: appliedPage ? whiteColor : primeColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            explorePage = false;
                            appliedPage = false;
                            shortlistedPage = true;
                          });
                          log('log is $explorePage $appliedPage $shortlistedPage');
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            color: shortlistedPage ? primeColor : whiteColor,
                            border: Border.all(
                              width: 2,
                              color: primeColor,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Shortlisted',
                            style: TextStyle(
                              color: shortlistedPage ? whiteColor : primeColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                StreamBuilder(
                    stream: collaboration
                        .where('categories', isEqualTo: widget.categorey)
                        .snapshots(),
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
                            return Padding(
                              padding: const EdgeInsets.all(12),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CollaborationInternalScreen(
                                        heading: documentSnapshot['brand_logo'],
                                        image: documentSnapshot['image'],
                                        paragraph:
                                            documentSnapshot['descreption'],
                                        followerDetails: documentSnapshot[
                                            'required_followers'],
                                        brandlogo:
                                            documentSnapshot['brand_logo'],
                                        categories:
                                            documentSnapshot['categories'],
                                        collaborationtype: documentSnapshot[
                                            'collaboration_type'],
                                        language: documentSnapshot['language'],
                                        titles: documentSnapshot['titles'],
                                        productCategorey: documentSnapshot[
                                            'product_categorey'],
                                        userNumber: widget.userNumber,
                                        userAddress: widget.userAddress,
                                        userEmail: widget.userEmail,
                                        userName: widget.userName,
                                        userPayment: widget.userPayment,
                                        userProfileImage:
                                            widget.userProfileImage,
                                        userWalletId: widget.userWalletId,
                                        userLanguage: widget.userLanguage, userFollowers: widget.userFollowers,
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
                                            decoration: const BoxDecoration(
                                              color: Colors.green,
                                            ),
                                          ),
                                          const SizedBox(width: 15),
                                          const Text(
                                            'Applications Open',
                                            style: TextStyle(
                                              color: Colors.green,
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
                                                  width: width / 2.5,
                                                  child: Text(
                                                    documentSnapshot['titles'],
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
                                                        'required_followers'],
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
                                                FaIcon(
                                                  FontAwesomeIcons.instagram,
                                                  color: primeColor,
                                                  size: 16,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: 50,
                                        width: width,
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.green.withOpacity(0.3),
                                          borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Apply to get Shortlisted',
                                              style: TextStyle(
                                                  fontSize: minSize - 1),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.all(5),
                                              decoration: const BoxDecoration(
                                                color: Colors.green,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  Icons.arrow_forward_ios,
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
                          },
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
