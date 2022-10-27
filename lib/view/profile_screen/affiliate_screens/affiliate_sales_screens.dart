import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:primewayskills_app/view/helpers/colors.dart';
import 'package:primewayskills_app/view/helpers/helping_widgets.dart';

class AffiliateSalesScreen extends StatefulWidget {
  final String userNumber;
  final String userName;
  final String userAddress;
  final String userProfileImage;
  final String userPayment;
  final String userEmail;
  final String userWalletId;
  const AffiliateSalesScreen(
      {super.key,
      required this.userNumber,
      required this.userName,
      required this.userAddress,
      required this.userProfileImage,
      required this.userPayment,
      required this.userEmail,
      required this.userWalletId});

  @override
  State<AffiliateSalesScreen> createState() => _AffiliateSalesScreenState();
}

class _AffiliateSalesScreenState extends State<AffiliateSalesScreen> {
  String approvedAffiliate = '';
  String completeAffiliate = '';
  String pendingAffiliate = '';
  String successfulAffiliate = '';
  String totalAffiliate = '';
  String userId = '12345678990';
  String today = '';

  Future<void> getaffilate() async {
    FirebaseFirestore.instance
        .collection('affilate_dashboard')
        .doc('NkcdMPSuI3SSIpJ2uLuv')
        .collection('affiliate_users')
        .doc(widget().userNumber)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          approvedAffiliate = documentSnapshot.get('approved_affiliate');
          completeAffiliate = documentSnapshot.get('complete_affiliate');
          pendingAffiliate = documentSnapshot.get('pending_affiliate');
          successfulAffiliate = documentSnapshot.get('successful_affiliate');
          totalAffiliate = documentSnapshot.get('total_affiliate');
          // approvedAffiliate = documentSnapshot.get('approved_affiliate');
          today = documentSnapshot.get('today_earning');
        });
        log('Document data: ${documentSnapshot.data()}');
      } else {
        log('Document does not exist on the database ');
      }
    });
  }

  @override
  void initState() {
    getaffilate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: whiteColor,
      body: SizedBox(
        height: height,
        width: width,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blueGrey[50],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: width / 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '$rupeeSign $pendingAffiliate',
                            style: TextStyle(
                              fontSize: maxSize + 2,
                              fontWeight: FontWeight.bold,
                              color: Colors.amber,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Pending',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.amber,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: width / 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '$rupeeSign $completeAffiliate',
                            style: TextStyle(
                              fontSize: maxSize + 2,
                              fontWeight: FontWeight.bold,
                              color: primeColor2,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Completed',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: primeColor2,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: width / 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '$rupeeSign $approvedAffiliate',
                            style: TextStyle(
                              fontSize: maxSize + 2,
                              fontWeight: FontWeight.bold,
                              color: purpleColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Approved',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: purpleColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: width / 2.2,
                    padding: const EdgeInsets.all(10),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        headingWidgetMethodForResources('Total Transactions'),
                        const SizedBox(height: 10),
                        Text(
                          totalAffiliate,
                          style: TextStyle(
                            fontSize: maxSize,
                            fontWeight: FontWeight.bold,
                            color: primeColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: width / 2.2,
                    padding: const EdgeInsets.all(10),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        headingWidgetMethodForResources(
                          'Successful Transactions',
                        ),
                        const SizedBox(height: 10),
                        Text(
                          successfulAffiliate,
                          style: TextStyle(
                            fontSize: maxSize,
                            fontWeight: FontWeight.bold,
                            color: primeColor2,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: width,
                height: height / 3,
                child: Stack(
                  children: [
                    Lottie.asset(
                      'assets/json/spiral.json',
                      width: width,
                      height: height / 3,
                      fit: BoxFit.cover,
                      repeat: true,
                      reverse: true,
                      animate: true,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 60),
                          Text(
                            '$rupeeSign $today',
                            style: TextStyle(
                              fontSize: 40,
                              color: primeColor,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.4),
                                  blurRadius: 100,
                                ),
                              ],
                            ),
                          ),
                          Text(
                            "Today's Earning",
                            style: TextStyle(
                              fontSize: 12,
                              color: primeColor,
                              fontWeight: FontWeight.bold,
                            ),
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
      ),
    );
  }
}
