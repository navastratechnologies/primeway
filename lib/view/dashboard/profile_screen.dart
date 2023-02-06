// ignore_for_file: avoid_print, avoid_function_literals_in_foreach_calls

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:primewayskills_app/view/appbar_screens/profile_edit_screen.dart';
import 'package:primewayskills_app/view/drawer/sidebar.dart';
import 'package:primewayskills_app/view/helpers/colors.dart';
import 'package:primewayskills_app/view/helpers/helping_widgets.dart';
import 'package:primewayskills_app/view/helpers/responsive_size_helper.dart';
import 'package:primewayskills_app/view/profile_screen/affiliate_screen.dart';
import 'package:primewayskills_app/view/profile_screen/profile_tile_widget.dart';
import 'package:primewayskills_app/view/profile_screen/purchase_history_screen.dart';
import 'package:primewayskills_app/view/profile_screen/refer_and_earn_screen.dart';
import 'package:primewayskills_app/view/profile_screen/wallet_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String userNumber;
  final String userName;
  final String userAddress;
  final String userProfileImage;
  final String userPayment;
  final String userEmail;
  final String userWalletId;
  const ProfileScreen(
      {Key? key,
      required this.userNumber,
      required this.userName,
      required this.userAddress,
      required this.userProfileImage,
      required this.userPayment,
      required this.userEmail,
      required this.userWalletId})
      : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool showAffiliate = false;
  String docId = '';

  Future<void> checkCollection() async {
    FirebaseFirestore.instance
        .collection('affilate_dashboard')
        .doc('NkcdMPSuI3SSIpJ2uLuv')
        .collection('affiliate_users')
        .doc(widget.userNumber)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          docId = documentSnapshot.id;
          showAffiliate = true;
        });
        log('Document id: ${documentSnapshot.id}');
      } else {
        setState(() {
          showAffiliate = false;
        });
        log('Document does not exist on the database');
      }
    });
  }

  @override
  void initState() {
    checkCollection();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      drawer: NavigationDrawer(
        userAddress: widget.userAddress,
        userEmail: widget.userEmail,
        userName: widget.userName,
        userNumber: widget.userNumber,
        userPayment: widget.userPayment,
        userProfileImage: widget.userProfileImage,
        userWalletId: widget.userWalletId,
      ),
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .where('user_Id', isEqualTo: widget.userNumber)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 5,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          primeColor,
                          primeColor.withOpacity(0.1),
                          primeColor.withOpacity(0.3),
                        ],
                      ),
                    ),
                    child: AppBar(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      iconTheme: IconThemeData(
                        color: Colors.black.withOpacity(0.6),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: streamSnapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot documentSnapshot =
                            streamSnapshot.data!.docs[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      primeColor.withOpacity(0.1),
                                      primeColor,
                                      primeColor.withOpacity(0.3),
                                    ],
                                  ),
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(40),
                                    bottomLeft: Radius.circular(40),
                                  ),
                                ),
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: primeColor,
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              documentSnapshot['profile_pic']),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            Center(
                              child: Text(
                                documentSnapshot['name'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black.withOpacity(0.6),
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Center(
                              child: SizedBox(
                                width: displayWidth(context) / 1.2,
                                child: Text(
                                  documentSnapshot['description'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Colors.black.withOpacity(0.3),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Stack(
                              children: [
                                Column(
                                  children: [
                                    const SizedBox(height: 20),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 10,
                                        right: 10,
                                        top: 20,
                                        bottom: 10,
                                      ),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        padding: const EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          color: whiteColor,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withOpacity(0.06),
                                              blurRadius: 10,
                                              spreadRadius: 1,
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            headingWidgetMethod('Activities'),
                                            const SizedBox(height: 5),
                                            Text(
                                              "${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day} ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: Colors.black
                                                    .withOpacity(0.3),
                                              ),
                                            ),
                                            const SizedBox(height: 30),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  children: [
                                                    Icon(
                                                      Icons.bar_chart_rounded,
                                                      color: primeColor2,
                                                    ),
                                                    Container(
                                                      height: 2,
                                                      width: 20,
                                                      decoration: BoxDecoration(
                                                        color: purpleColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        StreamBuilder(
                                                          stream: FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'users')
                                                              .doc(widget
                                                                  .userNumber)
                                                              .collection(
                                                                  'myCollabs')
                                                              .snapshots(),
                                                          builder: (context,
                                                              AsyncSnapshot<
                                                                      QuerySnapshot>
                                                                  collabsSnapshot) {
                                                            if (collabsSnapshot
                                                                .hasData) {
                                                              return paragraphWidgetMethodForResourcesBold(
                                                                collabsSnapshot
                                                                    .data!
                                                                    .docs
                                                                    .length
                                                                    .toString(),
                                                              );
                                                            }
                                                            return paragraphWidgetMethodForResourcesBold(
                                                              '0',
                                                            );
                                                          },
                                                        ),
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              3,
                                                          child:
                                                              headingWidgetMethodForResources(
                                                            'Collabs Participated',
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(width: 5),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        StreamBuilder(
                                                          stream: FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'users')
                                                              .doc(widget
                                                                  .userNumber)
                                                              .collection(
                                                                  'myCollabs')
                                                              .where(
                                                                  'completed',
                                                                  isEqualTo:
                                                                      'true')
                                                              .snapshots(),
                                                          builder: (context,
                                                              AsyncSnapshot<
                                                                      QuerySnapshot>
                                                                  collabsSnapshot) {
                                                            if (collabsSnapshot
                                                                .hasData) {
                                                              return paragraphWidgetMethodForResourcesBold(
                                                                collabsSnapshot
                                                                    .data!
                                                                    .docs
                                                                    .length
                                                                    .toString(),
                                                              );
                                                            }
                                                            return paragraphWidgetMethodForResourcesBold(
                                                              '0',
                                                            );
                                                          },
                                                        ),
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              3,
                                                          child:
                                                              headingWidgetMethodForResources(
                                                            'Collabs Completed',
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 40),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .directions_run_rounded,
                                                      color: primeColor2,
                                                    ),
                                                    Container(
                                                      height: 2,
                                                      width: 20,
                                                      decoration: BoxDecoration(
                                                        color: purpleColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        paragraphWidgetMethodForResourcesBold(
                                                          documentSnapshot[
                                                                      'total_refferals']
                                                                  .toString()
                                                                  .isEmpty
                                                              ? '0'
                                                              : documentSnapshot[
                                                                  'total_refferals'],
                                                        ),
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              3,
                                                          child:
                                                              headingWidgetMethodForResources(
                                                            'Total Refferals',
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(width: 5),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        StreamBuilder(
                                                          stream: FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'users')
                                                              .doc(widget
                                                                  .userNumber)
                                                              .collection(
                                                                  'refferal')
                                                              .snapshots(),
                                                          builder: (context,
                                                              AsyncSnapshot<
                                                                      QuerySnapshot>
                                                                  collabsSnapshot) {
                                                            if (collabsSnapshot
                                                                .hasData) {
                                                              return paragraphWidgetMethodForResourcesBold(
                                                                collabsSnapshot
                                                                    .data!
                                                                    .docs
                                                                    .length
                                                                    .toString(),
                                                              );
                                                            }
                                                            return paragraphWidgetMethodForResourcesBold(
                                                              '0',
                                                            );
                                                          },
                                                        ),
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              3,
                                                          child:
                                                              headingWidgetMethodForResources(
                                                            'Users by Refferels',
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 40),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  children: [
                                                    Icon(
                                                      Icons.wallet_rounded,
                                                      color: primeColor2,
                                                    ),
                                                    Container(
                                                      height: 2,
                                                      width: 20,
                                                      decoration: BoxDecoration(
                                                        color: purpleColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        paragraphWidgetMethodForResourcesBold(
                                                          documentSnapshot[
                                                                      'earning_by_refferals']
                                                                  .toString()
                                                                  .isEmpty
                                                              ? "0"
                                                              : documentSnapshot[
                                                                  'earning_by_refferals'],
                                                        ),
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              3,
                                                          child:
                                                              headingWidgetMethodForResources(
                                                            'P Coins Earned',
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(width: 5),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        StreamBuilder(
                                                          stream: FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'wallet')
                                                              .where('user_id',
                                                                  isEqualTo: widget
                                                                      .userNumber)
                                                              .snapshots(),
                                                          builder: (context,
                                                              AsyncSnapshot<
                                                                      QuerySnapshot>
                                                                  walletSnapshot) {
                                                            if (walletSnapshot
                                                                .hasData) {
                                                              for (var i = 0;
                                                                  i <
                                                                      walletSnapshot
                                                                          .data!
                                                                          .docs
                                                                          .length;
                                                                  i++) {
                                                                DocumentSnapshot
                                                                    walletDocSnapshot =
                                                                    walletSnapshot
                                                                        .data!
                                                                        .docs[i];
                                                                return paragraphWidgetMethodForResourcesBold(
                                                                  walletDocSnapshot[
                                                                              'total_withdrawal']
                                                                          .toString()
                                                                          .isEmpty
                                                                      ? '${rupeeSign}0'
                                                                      : "$rupeeSign${walletDocSnapshot['total_withdrawal']}",
                                                                );
                                                              }
                                                            }
                                                            return paragraphWidgetMethodForResourcesBold(
                                                              '0',
                                                            );
                                                          },
                                                        ),
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              3,
                                                          child:
                                                              headingWidgetMethodForResources(
                                                            'Withdrawals',
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => WalletScreen(
                                            userNumber: widget.userNumber,
                                          ),
                                        ),
                                      ),
                                      child: const ProfileTileWidget(
                                        heading: 'Wallet',
                                        icons: FontAwesomeIcons.wallet,
                                      ),
                                    ),
                                    showAffiliate
                                        ? InkWell(
                                            onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AffiliateScreen(
                                                  userAddress:
                                                      widget.userAddress,
                                                  userEmail: widget.userEmail,
                                                  userName: widget.userName,
                                                  userNumber: widget.userNumber,
                                                  userPayment:
                                                      widget.userPayment,
                                                  userProfileImage:
                                                      widget.userProfileImage,
                                                  userWalletId:
                                                      widget.userWalletId,
                                                ),
                                              ),
                                            ),
                                            child: const ProfileTileWidget(
                                              heading: 'Affiliate Dashboard',
                                              icons: FontAwesomeIcons
                                                  .affiliatetheme,
                                            ),
                                          )
                                        : Container(),
                                    InkWell(
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ReferAndEarnScreen(
                                            userNumber: widget.userNumber,
                                          ),
                                        ),
                                      ),
                                      child: const ProfileTileWidget(
                                        heading: 'Refer & Earn',
                                        icons: FontAwesomeIcons.bullhorn,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PurchaseHistoryScreen(
                                            userNumber: widget.userNumber,
                                            userName: widget.userName,
                                            userAddress: widget.userAddress,
                                            userProfileImage:
                                                widget.userProfileImage,
                                            userPayment: widget.userPayment,
                                            userEmail: widget.userEmail,
                                            userWalletId: widget.userWalletId,
                                          ),
                                        ),
                                      ),
                                      child: const ProfileTileWidget(
                                        heading: 'Purchase History',
                                        icons: FontAwesomeIcons.clockRotateLeft,
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: Container(
                                      height: 90,
                                      width: 90,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            primeColor2,
                                            whiteColor,
                                          ],
                                        ),
                                      ),
                                      child: documentSnapshot[
                                                      'instagram_username']
                                                  .toString()
                                                  .isEmpty &&
                                              documentSnapshot[
                                                      'instagram_username']
                                                  .toString()
                                                  .isEmpty
                                          ? MaterialButton(
                                              onPressed: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProfileEditScreen(
                                                    userNumber:
                                                        widget.userNumber,
                                                  ),
                                                ),
                                              ),
                                              child: Icon(Icons.add_rounded,
                                                  color: whiteColor, size: 50),
                                            )
                                          : Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  documentSnapshot[
                                                              'instagram_username']
                                                          .toString()
                                                          .isEmpty
                                                      ? documentSnapshot[
                                                          'youtube_subscribers']
                                                      : documentSnapshot[
                                                          'instagram_followers'],
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 22,
                                                    color: whiteColor,
                                                  ),
                                                ),
                                                Text(
                                                  documentSnapshot[
                                                              'instagram_username']
                                                          .toString()
                                                          .isEmpty
                                                      ? "Subscribers On Youtube"
                                                      : "Followers On Instagram",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10,
                                                    color: whiteColor,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
