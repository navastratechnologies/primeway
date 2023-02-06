import 'dart:developer';
import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:primewayskills_app/controllers/referrel_controller.dart';
import 'package:primewayskills_app/view/helpers/alert_deialogs.dart';
import 'package:primewayskills_app/view/helpers/colors.dart';
import 'package:primewayskills_app/view/helpers/helping_widgets.dart';
import 'package:primewayskills_app/view/helpers/responsive_size_helper.dart';

class ReferAndEarnScreen extends StatefulWidget {
  final String userNumber;
  const ReferAndEarnScreen({
    super.key,
    required this.userNumber,
  });

  @override
  State<ReferAndEarnScreen> createState() => _ReferAndEarnScreenState();
}

class _ReferAndEarnScreenState extends State<ReferAndEarnScreen> {
  math.Random random = math.Random.secure();

  String referralId = '';
  String referralCharge = '';

  Future getRefferalCharges() async {
    FirebaseFirestore.instance
        .collection('refer_charge')
        .doc("gzCPY5vpI3OBXWX22dKZ")
        .get()
        .then(
      (value) {
        setState(
          () {
            referralCharge = value.get('refer_charge');
          },
        );
        log('refer id is $referralId');
      },
    );
  }

  Future getRefferalCode() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userNumber)
        .get()
        .then(
      (value) {
        setState(
          () {
            referralId = value.get('referrel_id');
          },
        );
        log('refer id is $referralId');
      },
    );
  }

  @override
  void initState() {
    getRefferalCode();
    getRefferalCharges();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black.withOpacity(0.6),
        ),
        backgroundColor: whiteColor,
        title: Text(
          'Refer & Earn',
          style: TextStyle(
            fontSize: maxSize,
            color: Colors.black.withOpacity(0.6),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 10,
                ),
                child: Center(
                  child: Lottie.asset('assets/json/refer.json'),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Text(
                      "Refer to your friend and Get reward of $rupeeSign$referralCharge",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Share this link with your friends and after they install, both of you will get $rupeeSign$referralCharge PrimeCoins as reward.",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black.withOpacity(0.2),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    InkWell(
                      onTap: () {
                        Clipboard.setData(
                          ClipboardData(
                            text: referralId,
                          ),
                        ).then(
                          (_) {
                            alertDialogWidget(
                              context,
                              primeColor2,
                              "Referral code copied to clipboard",
                            );
                          },
                        );
                      },
                      child: Container(
                        width: 150,
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              referralId.toUpperCase(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(width: 10),
                            SizedBox(
                              width: 25,
                              height: 25,
                              child: Image.asset('assets/copy.png'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(
                      thickness: 1,
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Container(
                              padding: const EdgeInsets.all(10),
                              height: displayHeight(context) / 2.1,
                              width: displayWidth(context),
                              decoration: BoxDecoration(
                                color: whiteColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: primeColor.withOpacity(0.2),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      headingWidgetMethod('Invitation Rules'),
                                      MaterialButton(
                                        shape: const CircleBorder(),
                                        color: purpleColor,
                                        onPressed: () => Navigator.pop(context),
                                        child: FaIcon(
                                          FontAwesomeIcons.xmark,
                                          color: whiteColor,
                                          size: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Divider(
                                    thickness: 1.2,
                                    color: Colors.blueGrey.withOpacity(0.1),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Lottie.asset(
                                        'assets/json/share.json',
                                        height: 80,
                                        width: 80,
                                      ),
                                      const SizedBox(width: 10),
                                      referalTextWidget(
                                        'Invite Friends',
                                        'Share your unique refferal link',
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Lottie.asset(
                                        'assets/json/register.json',
                                        height: 80,
                                        width: 80,
                                      ),
                                      const SizedBox(width: 10),
                                      referalTextWidget(
                                        'Friend Register',
                                        'Friend register from your link or use your refferal code.',
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Lottie.asset(
                                        'assets/json/refer.json',
                                        height: 80,
                                        width: 80,
                                      ),
                                      const SizedBox(width: 10),
                                      referalTextWidget(
                                        'Refferal Reward',
                                        'You will get refferal reward from us in your wallet.',
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Column(
                        children: [
                          Text(
                            "To understand how referrel works.",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.black.withOpacity(0.2),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 5),
                          InkWell(
                            child: Text(
                              "View Invitation Rules",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: primeColor2,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.copy_rounded,
                                color: Colors.black.withOpacity(0.4),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: 80,
                                child: Text(
                                  'Copy Link',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black.withOpacity(0.4),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                FontAwesomeIcons.checkDouble,
                                color: Colors.black.withOpacity(0.4),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: 100,
                                child: Text(
                                  'Friend Registered Successfully',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black.withOpacity(0.4),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                FontAwesomeIcons.coins,
                                color: Colors.black.withOpacity(0.4),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: 80,
                                child: Text(
                                  'Earn Cash Rewards',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black.withOpacity(0.4),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    MaterialButton(
                      color: primeColor,
                      minWidth: MediaQuery.of(context).size.width,
                      height: 45,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      onPressed: () {
                        buidDynamicLinkForReferral(
                          referralId,
                          widget.userNumber,
                          "share",
                          context,
                        );
                      },
                      child: Text(
                        'Refer Friend',
                        style: TextStyle(
                          color: whiteColor,
                          fontWeight: FontWeight.bold,
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
  }

  referalTextWidget(head, subhead) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          head,
          style: TextStyle(
            color: Colors.black.withOpacity(0.4),
            fontSize: 12,
            letterSpacing: 1,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          width: displayWidth(context) / 1.5,
          child: Text(
            subhead,
            style: const TextStyle(
              fontSize: 12,
              letterSpacing: 1,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
