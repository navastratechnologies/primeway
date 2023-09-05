import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:primewayskills_app/view/helpers/colors.dart';
import 'package:primewayskills_app/view/helpers/helping_widgets.dart';
import 'package:primewayskills_app/view/helpers/responsive_size_helper.dart';
import 'package:primewayskills_app/view/profile_screen/affiliate_screens/affilieate_sales_history_screen.dart';

class AffiliateSalesScreen extends StatefulWidget {
  final String userNumber;
  const AffiliateSalesScreen({super.key, required this.userNumber});

  @override
  State<AffiliateSalesScreen> createState() => _AffiliateSalesScreenState();
}

class _AffiliateSalesScreenState extends State<AffiliateSalesScreen> {
  String approvedAffiliate = '';
  String completeAffiliate = '';
  String pendingAffiliate = '';
  String successlAffiliate = '';
  String todayEarning = '';
  String totalAffiliate = '';

  Future<void> getAffilateDashboard() async {
    FirebaseFirestore.instance
        .collection('affilate_dashboard')
        .doc('NkcdMPSuI3SSIpJ2uLuv')
        .collection('affiliate_users')
        .doc(widget.userNumber)
        .get()
        .then((value) {
      log('affiliate is ${value.get('approved_affiliate')}');
      setState(() {
        approvedAffiliate = value.get('approved_affiliate');
        completeAffiliate = value.get('complete_affiliate');
        pendingAffiliate = value.get('pending_affiliate');
        successlAffiliate = value.get('successful_affiliate');
        todayEarning = value.get('today_earning');
        totalAffiliate = value.get('total_affiliate');
      });
    });
  }

  @override
  void initState() {
    getAffilateDashboard();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: whiteColor,
      body: SingleChildScrollView(
        child: SizedBox(
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
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('affilate_dashboard')
                        .doc('NkcdMPSuI3SSIpJ2uLuv')
                        .collection('affiliate_users')
                        .where('user_Id', isEqualTo: widget.userNumber)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot documentSnapshot =
                                snapshot.data!.docs[index];
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  width: width / 4,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        '$rupeeSign ${documentSnapshot['pending_affiliate']}',
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        '$rupeeSign ${documentSnapshot['complete_affiliate']}',
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        '$rupeeSign ${documentSnapshot['approved_affiliate']}',
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
                            );
                          },
                        );
                      }
                      return Row(
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
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: displayHeight(context) / 2,
                  width: displayWidth(context),
                  child: Stack(
                    children: [
                      Lottie.asset(
                        'assets/json/spiral.json',
                        reverse: true,
                        height: displayHeight(context) / 2,
                        width: displayWidth(context),
                        fit: BoxFit.contain,
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('affilate_dashboard')
                                  .doc('NkcdMPSuI3SSIpJ2uLuv')
                                  .collection('affiliate_users')
                                  .where('user_Id',
                                      isEqualTo: widget.userNumber)
                                  .snapshots(),
                              builder: (context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasData) {
                                  return SizedBox(
                                    height: 60,
                                    child: ListView.builder(
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder: (context, index) {
                                        return Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            '$rupeeSign ${snapshot.data!.docs[index]['today_earning']}',
                                            style: TextStyle(
                                              fontSize: 60,
                                              fontWeight: FontWeight.bold,
                                              color: primeColor,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                }
                                return Text(
                                  '$rupeeSign 00',
                                  style: TextStyle(
                                    fontSize: 60,
                                    fontWeight: FontWeight.bold,
                                    color: primeColor,
                                  ),
                                );
                              },
                            ),
                            Text(
                              "Today's Earning",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: primeColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                salesCards("Weekly Earning"),
                const SizedBox(height: 20),
                salesCards("Monthly Earning"),
                const SizedBox(height: 20),
                salesCards("Quaterly Earning"),
                const SizedBox(height: 20),
                salesCards("Yearly Earning"),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AffiliateSalesHistoryScreen(
                          userNumber: widget.userNumber,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: width,
                    height: 100,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: primeColor2.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            headingWidgetMethod('View History'),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: primeColor,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: primeColor2.withOpacity(0.6),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    'Go to History page',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: whiteColor.withOpacity(0.5),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 16,
                                    color: whiteColor,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Image.asset(
                          'assets/history.png',
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container salesCards(heading) {
    var width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
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
            heading,
          ),
          const SizedBox(height: 20),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('affilate_dashboard')
                .doc('NkcdMPSuI3SSIpJ2uLuv')
                .collection('affiliate_users')
                .where('user_Id', isEqualTo: widget.userNumber)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                return SizedBox(
                  height: 70,
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot documentSnapshot =
                          snapshot.data!.docs[index];
                      return Text(
                        heading.toString().contains('Today')
                            ? "$rupeeSign ${documentSnapshot['today_earning']}"
                            : heading.toString().contains('Weekly')
                                ? "$rupeeSign ${documentSnapshot['weekly_earning']}"
                                : heading.toString().contains('Monthly')
                                    ? "$rupeeSign ${documentSnapshot['monthly_earning']}"
                                    : heading.toString().contains('Quaterly')
                                        ? "$rupeeSign ${documentSnapshot['quaterly_earning']}"
                                        : "$rupeeSign ${documentSnapshot['annualy_earning']}",
                        style: TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          color: primeColor2,
                        ),
                      );
                    },
                  ),
                );
              }
              return Text(
                "$rupeeSign 00",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: primeColor2,
                ),
                textAlign: TextAlign.center,
              );
            },
          ),
        ],
      ),
    );
  }
}
