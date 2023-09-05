import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:primewayskills_app/view/helpers/colors.dart';
import 'package:primewayskills_app/view/helpers/helping_widgets.dart';
import 'package:primewayskills_app/view/helpers/responsive_size_helper.dart';
import 'package:primewayskills_app/view/profile_screen/affiliate_screens/affiliate_chat_screen.dart';

class AffiliateReferScreen extends StatefulWidget {
  final String userNumber;
  const AffiliateReferScreen({super.key, required this.userNumber});

  @override
  State<AffiliateReferScreen> createState() => _AffiliateReferScreenState();
}

class _AffiliateReferScreenState extends State<AffiliateReferScreen>
    with WidgetsBindingObserver {
  String totalRefferals = '0';

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(
      () {
        log('app is $state');
        if (state == AppLifecycleState.hidden ||
            state == AppLifecycleState.inactive ||
            state == AppLifecycleState.paused) {
          FirebaseFirestore.instance
              .collection('users')
              .doc(widget.userNumber)
              .update(
            {
              'isLive': 'false',
            },
          );
        } else {
          FirebaseFirestore.instance
              .collection('users')
              .doc(widget.userNumber)
              .update(
            {
              'isLive': 'true',
            },
          );
        }
      },
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: whiteColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 20,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blueGrey[50],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .snapshots(),
                          builder:
                              (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                snapshot.data!.docs
                                    .where((element) =>
                                        element['refferer_id'] ==
                                        widget.userNumber)
                                    .length
                                    .toString(),
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber,
                                ),
                                textAlign: TextAlign.center,
                              );
                            }
                            return const Text(
                              "0",
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.amber,
                              ),
                              textAlign: TextAlign.center,
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Total Team (Refferals)',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      headingWidgetMethodForResources('Team'),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          height: 1.5,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('users').snapshots(),
                builder:
                    (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                  if (streamSnapshot.hasData) {
                    return ListView.builder(
                      itemCount: streamSnapshot.data!.docs.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final DocumentSnapshot documentSnapshot =
                            streamSnapshot.data!.docs[index];
                        if (documentSnapshot['refferer_id'] ==
                            widget.userNumber) {
                          return InkWell(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AffiliateChatScreen(
                                  myNumber: widget.userNumber,
                                  userNumber: documentSnapshot['phone_number'],
                                  userName: documentSnapshot['name'],
                                ),
                              ),
                            ),
                            child: Padding(
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
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: displayWidth(context),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            documentSnapshot['name'],
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          StreamBuilder(
                                            stream: FirebaseFirestore.instance
                                                .collection('users')
                                                .snapshots(),
                                            builder: (context,
                                                AsyncSnapshot<QuerySnapshot>
                                                    snapshot) {
                                              if (snapshot.hasData) {
                                                return SizedBox(
                                                  height: 30,
                                                  width: 80,
                                                  child: ListView.builder(
                                                    itemCount: snapshot
                                                        .data!.docs.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      if (snapshot.data!
                                                                  .docs[index]
                                                              ['user_Id'] ==
                                                          documentSnapshot[
                                                              'user_Id']) {
                                                        return Row(
                                                          children: [
                                                            Text(
                                                              snapshot.data!.docs[
                                                                              index]
                                                                          [
                                                                          'isLive'] ==
                                                                      'true'
                                                                  ? "active"
                                                                  : 'offline',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: snapshot
                                                                            .data!
                                                                            .docs[index]['isLive'] ==
                                                                        'true'
                                                                    ? Colors.green
                                                                    : primeColor,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                width: 10),
                                                            Icon(
                                                              Icons
                                                                  .favorite_rounded,
                                                              color: snapshot
                                                                          .data!
                                                                          .docs[index]['isLive'] ==
                                                                      'true'
                                                                  ? Colors.green
                                                                  : primeColor,
                                                            ),
                                                          ],
                                                        );
                                                      }
                                                      return Container();
                                                    },
                                                  ),
                                                );
                                              }
                                              return const Row(
                                                children: [
                                                  Text(
                                                    "active",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Icon(
                                                    Icons.favorite_rounded,
                                                    color: Colors.green,
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    const Divider(),
                                    const SizedBox(height: 5),
                                    Container(
                                      width: displayWidth(context) / 2.5,
                                      decoration: BoxDecoration(
                                        color: purpleColor,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 3,
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Earnings:',
                                            style: TextStyle(
                                              color: whiteColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          StreamBuilder(
                                            stream: FirebaseFirestore.instance
                                                .collection(
                                                    'affilate_dashboard')
                                                .doc('NkcdMPSuI3SSIpJ2uLuv')
                                                .collection('affiliate_users')
                                                .where('user_Id',
                                                    isEqualTo: documentSnapshot[
                                                        'user_Id'])
                                                .snapshots(),
                                            builder: (context,
                                                AsyncSnapshot<QuerySnapshot>
                                                    snapshot) {
                                              if (snapshot.hasData) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 3),
                                                  child: SizedBox(
                                                    height: 20,
                                                    width: 50,
                                                    child: ListView.builder(
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      itemCount: snapshot
                                                          .data!.docs.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        if (snapshot.data!
                                                                    .docs[index]
                                                                ['user_Id'] ==
                                                            documentSnapshot[
                                                                'user_Id']) {
                                                          return Text(
                                                            '$rupeeSign${snapshot.data!.docs[index]['annualy_earning']}',
                                                            style: TextStyle(
                                                              color: whiteColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          );
                                                        }
                                                        return Container();
                                                      },
                                                    ),
                                                  ),
                                                );
                                              }
                                              return Text(
                                                '${rupeeSign}00',
                                                style: TextStyle(
                                                  color: whiteColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                        return Container();
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
