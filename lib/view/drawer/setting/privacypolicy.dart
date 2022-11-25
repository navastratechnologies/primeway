import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:primewayskills_app/view/helpers/colors.dart';

class PrivacyPloicyScreen extends StatefulWidget {
  final String userNumber;
  final String userName;
  final String userAddress;
  final String userProfileImage;
  final String userPayment;
  final String userEmail;
  final String userWalletId;
  const PrivacyPloicyScreen(
      {super.key,
      required this.userNumber,
      required this.userName,
      required this.userAddress,
      required this.userProfileImage,
      required this.userPayment,
      required this.userEmail,
      required this.userWalletId});

  @override
  State<PrivacyPloicyScreen> createState() => _PrivacyPloicyScreenState();
}

class _PrivacyPloicyScreenState extends State<PrivacyPloicyScreen> {
  String userPrivacy = '';
  final CollectionReference privacyPolicy =
      FirebaseFirestore.instance.collection('privacy_policy');

  Future<void> updateUserPrivacy(privacy) async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userNumber)
        .update({
      'privacy_policy': privacy,
    });
  }

  Future<void> getPrivacyData() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userNumber)
        .get()
        .then((value) {
      setState(() {
        userPrivacy = value.get('privacy_policy');
      });
      log('message : $userPrivacy');
    });
  }

  @override
  void initState() {
    getPrivacyData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                "Privacy Policy",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                "Last updated Nov 5th 2022",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.3)),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            StreamBuilder(
                stream: privacyPolicy.snapshots(),
                builder:
                    (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                  if (streamSnapshot.hasData) {
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      // scrollDirection: Axis.vertical,
                      itemCount: streamSnapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final DocumentSnapshot documentSnapshot =
                            streamSnapshot.data!.docs[index];
                        return Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      documentSnapshot['heading'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      documentSnapshot['description'],
                                      style: TextStyle(
                                        color: Colors.black.withOpacity(0.4),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(height: 10);
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
      bottomNavigationBar: userPrivacy == 'accepted'
          ? null
          : Container(
              padding: const EdgeInsets.all(14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width / 3,
                      decoration: BoxDecoration(
                        color: primeColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: primeColor,
                            spreadRadius: 1,
                          )
                        ],
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "DECLINE",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      updateUserPrivacy('accepted');
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width / 3,
                      decoration: BoxDecoration(
                        color: primeColor2,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: primeColor2,
                            spreadRadius: 1,
                          )
                        ],
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "ACCEPT",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
