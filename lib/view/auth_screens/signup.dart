import 'dart:developer';
import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:primewayskills_app/controllers/notification_controller.dart';
import 'package:primewayskills_app/view/auth_screens/address.dart';
import 'package:primewayskills_app/view/helpers/colors.dart';
import 'package:primewayskills_app/view/helpers/responsive_size_helper.dart';

// import 'package:sms_autofill/sms_autofill.dart';

import '../../controllers/phone_controller.dart';

class SignUpScreen extends StatefulWidget {
  final String phone, verId;
  const SignUpScreen({
    super.key,
    required this.phone,
    required this.verId,
  });

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String phonenumber = '';
  AuthClass authClass = AuthClass();
  String verificationIdFinal = "";

  TextEditingController refferalUserIdController = TextEditingController();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController referrelController = TextEditingController();

  math.Random random = math.Random();

  String randomString = '';

  String reffererToken = '';

  final CollectionReference<Map<String, dynamic>> users =
      FirebaseFirestore.instance.collection('users');

  Future<void> signInwithPhoneNumber2(String phoneNumber, String verificationId,
      String smsCode, BuildContext context) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      // showSnackBar(context, "logged In");
      User? user = userCredential.user;
      createUserCollection();
      // createUserChapterCollection();
      // createUserRefferalCollection();
      createWalletCollection();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditAddressPage(
            phoneNumber: widget.phone,
            pageType: "new",
          ),
        ),
      );
      log('user is $userCredential');
    } catch (e) {
      log("reg error is ${e.toString()}");
    }
  }

  var formatter = DateFormat('MM/dd/yyyy hh:mm a');

  Future<void> createUserCollection() async {
    const availableChars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    randomString = List.generate(
      5,
      (index) => availableChars[random.nextInt(
        availableChars.length,
      )],
    ).join();
    users.doc(widget.phone).set({
      'user_Id': widget.phone,
      'name': "${firstNameController.text} ${lastNameController.text}",
      'email': emailController.text,
      'phone_number': widget.phone,
      'address': '',
      'affilate_id': '',
      'approval_status': '',
      'earning_by_refferals': '0',
      'payments': '',
      'photo_url': '',
      'profile_pic': '',
      'social_account': '',
      'total_refferals': '0',
      'wallet_id': widget.phone,
      'front_document': '',
      'back_document': '',
      'document_type': '',
      'language': '',
      'secondry_phone_number': '',
      'description': '',
      'gender': '',
      'date_of_brith': '',
      'instagram_followers': '',
      'instagram_username': '',
      'instagram_website': '',
      'instagram_bio': '',
      'instagram_image': '',
      'instagram_following': '',
      'referrel_id': "PWCT$randomString",
      'account_number': "0",
      'bank_name': "",
      'bank_document': '',
      'ifsc': "",
      "categories": "",
      'account_holder_name': "",
      'account_type': "",
      'youtube_subscribers': "0",
      'youtube_username': "",
      "insta_image_price": "0",
      "insta_video_price": "0",
      "insta_carousel_price": "0",
      "insta_story_price": "0",
      "insta_reels_price": "0",
      "youtube_video_price": "0",
      "youtube_short_price": "0",
      "refferer_id": refferalUserIdController.text.toString(),
    });
    storage.delete(key: 'referralUserId');
    storage.delete(key: 'referralId');
    storeTokenAndData(widget.phone);
    if (referrelController.text.isNotEmpty &&
        refferalUserIdController.text.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(refferalUserIdController.text)
          .get()
          .then(
        (value) {
          var totalRefferalEarnings = value.get('earning_by_refferals');
          int totalRefferalEarningInc =
              int.parse(totalRefferalEarnings) + int.parse(referralCharges);
          FirebaseFirestore.instance
              .collection('users')
              .doc(refferalUserIdController.text)
              .update({
            "earning_by_refferals": totalRefferalEarningInc.toString(),
          });
          FirebaseFirestore.instance
              .collection('affilate_dashboard')
              .doc('NkcdMPSuI3SSIpJ2uLuv')
              .collection('affiliate_users')
              .doc(refferalUserIdController.text)
              .get()
              .then(
            (value) {
              double todayEarning = double.parse(value.get('today_earning'));
              double weeklyEarning = double.parse(value.get('weekly_earning'));
              double monthlyEarning =
                  double.parse(value.get('monthly_earning'));
              double quaterlyEarning =
                  double.parse(value.get('quaterly_earning'));
              double annualyEarning =
                  double.parse(value.get('annualy_earning'));
              double totalEarningToday =
                  todayEarning + double.parse(referralCharges);
              double totalEarningWeekly =
                  weeklyEarning + double.parse(referralCharges);
              double totalEarningMonthly =
                  monthlyEarning + double.parse(referralCharges);
              double totalEarningQuaterly =
                  quaterlyEarning + double.parse(referralCharges);
              double totalEarningAnnualy =
                  annualyEarning + double.parse(referralCharges);
              FirebaseFirestore.instance
                  .collection('affilate_dashboard')
                  .doc('NkcdMPSuI3SSIpJ2uLuv')
                  .collection('affiliate_users')
                  .doc(refferalUserIdController.text)
                  .update(
                {
                  'today_earning': totalEarningToday.toString(),
                  'weekly_earning': totalEarningWeekly.toString(),
                  'monthly_earning': totalEarningMonthly.toString(),
                  'quaterly_earning': totalEarningQuaterly.toString(),
                  'annualy_earning': totalEarningAnnualy.toString(),
                },
              );
            },
          );
          FirebaseFirestore.instance
              .collection('users')
              .doc(widget.phone)
              .update({
            "earning_by_refferals": referralCharges.toString(),
          });
          FirebaseFirestore.instance
              .collection('wallet')
              .doc(widget.phone)
              .update(
            {
              'refferer_id': refferalUserIdController.text.toString(),
              'wallet_balance': referralCharges.toString(),
            },
          );
          FirebaseFirestore.instance
              .collection('users')
              .doc(refferalUserIdController.text)
              .collection('refferal')
              .add(
            {
              "refferal_point": referralCharges.toString(),
              "user_id": widget.phone,
              "user_name":
                  "${firstNameController.text} ${lastNameController.text}",
              "date":
                  "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year} ${DateTime.now().hour}:${DateTime.now().minute}",
            },
          );
          FirebaseFirestore.instance
              .collection('wallet')
              .doc(refferalUserIdController.text)
              .collection('refferal')
              .add(
            {
              "refferal_point": referralCharges.toString(),
              "date":
                  "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year} ${DateTime.now().hour}:${DateTime.now().minute}",
            },
          );
          log('total refferal is $totalRefferalEarnings $totalRefferalEarningInc');
        },
      );
      double refferalUserWalletbalance = 0.0;
      FirebaseFirestore.instance
          .collection('wallet')
          .doc(refferalUserIdController.text)
          .get()
          .then(
        (value) {
          setState(() {
            refferalUserWalletbalance = double.parse(
              value.get('wallet_balance').toString(),
            );
            refferalUserWalletbalance = refferalUserWalletbalance +
                double.parse(
                  referralCharges,
                );
            FirebaseFirestore.instance
                .collection('wallet')
                .doc(refferalUserIdController.text)
                .update(
              {
                'wallet_balance': refferalUserWalletbalance.toString(),
              },
            );
          });
        },
      );
      sendPushMessage(
        reffererToken,
        "${firstNameController.text} joined Primeway Plus from your link. You have received $referralCharges PrimeCoins in your wallet",
        "Congrats!!!",
      );
    }
  }

  // Future<void> createUserChapterCollection() async {
  //   users.doc(widget.phone).collection('courses').doc().set({
  //     'author_name': '',
  //     'courses_id': '',
  //     'image': '',
  //     'name': '',
  //   });
  // }

  // Future<void> createUserRefferalCollection() async {
  //   users.doc(widget.phone).collection('refferal').doc().set({
  //     'user_id': '',
  //     'user_name': '',
  //     'refferal_point': '',
  //   });
  // }

  Future<void> createWalletCollection() async {
    FirebaseFirestore.instance.collection('wallet').doc(widget.phone).set({
      'account_holder_name': '',
      'account_number': '',
      'bank_name': '',
      'earned_pcoins': '',
      'ifsc_code': '',
      'status': '',
      'total_withdrawal': '0',
      'user_id': widget.phone,
      'user_name': "${firstNameController.text} ${lastNameController.text}",
      'wallet_balance': '0',
      'withdrawal_req': '0',
      'account_type': '',
    });
    if (referrelController.text.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('wallet')
          .doc(widget.phone)
          .collection('transactions')
          .add(
        {
          'status': 'true',
          'date_time': formatter.format(DateTime.now()).toString(),
          'type': 'added',
          'coins': referralCharges,
          'reason': 'received p coins by using referral code',
        },
      );
      FirebaseFirestore.instance
          .collection('wallet')
          .doc(refferalUserIdController.text)
          .collection('transactions')
          .add(
        {
          'status': 'true',
          'date_time': formatter.format(DateTime.now()).toString(),
          'type': 'added',
          'coins': referralCharges,
          'reason':
              'received p coins after your reffered user ${firstNameController.text} downloaded and registered on our app.',
        },
      );
    }
  }

  String referralCharges = '';

  Future getReferalCharge() async {
    FirebaseFirestore.instance
        .collection('refer_charge')
        .doc("gzCPY5vpI3OBXWX22dKZ")
        .get()
        .then(
      (value) {
        setState(
          () {
            referralCharges = value.get('refer_charge');
          },
        );
      },
    );
  }

  // _listenSmsCode() async {
  //   await SmsAutoFill().listenForCode();
  // }

  @override
  void initState() {
    // _listenSmsCode();
    checkRefferalData();
    getReferalCharge();
    super.initState();
  }

  @override
  void dispose() {
    // SmsAutoFill().unregisterListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: displayWidth(context),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    primeColor,
                    primeColor.withOpacity(0.8),
                    primeColor.withOpacity(0.6),
                    primeColor.withOpacity(0.4),
                    primeColor.withOpacity(0.2),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15, top: 10),
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: whiteColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, top: 10),
                      child: Text(
                        "Welcome to PrimeWay Plus",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: whiteColor,
                          shadows: [
                            Shadow(
                              color: Colors.grey.withOpacity(0.4),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, top: 10),
                      child: Text(
                        "please help us know more about you.",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: whiteColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 10, right: 15),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 1,
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                  child: TextField(
                    controller: firstNameController,
                    decoration: InputDecoration(
                      labelText: 'Enter first name',
                      border: InputBorder.none,
                      labelStyle: TextStyle(
                        color: Colors.black.withOpacity(0.4),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 10, right: 15),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 1,
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                  child: TextField(
                    controller: lastNameController,
                    decoration: InputDecoration(
                      labelText: 'Enter Last name',
                      border: InputBorder.none,
                      labelStyle: TextStyle(
                        color: Colors.black.withOpacity(0.4),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 10, right: 15),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 1,
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Enter Email id',
                      border: InputBorder.none,
                      labelStyle: TextStyle(
                        color: Colors.black.withOpacity(0.4),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 30),
              child: Text(
                "Verify Your Mobile Number",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black.withOpacity(0.6),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const SizedBox(
                  width: 15,
                ),
                const Text(
                  "A 6 digit OTP has been sent to",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  "+91- ${widget.phone}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Text(
                    "Change",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 10, right: 15),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 1,
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                  child: TextField(
                    controller: otpController,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(6),
                    ],
                    decoration: InputDecoration(
                      labelText: 'Enter 6 digit OTP',
                      border: InputBorder.none,
                      labelStyle: TextStyle(
                        color: Colors.black.withOpacity(0.4),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MaterialButton(
                  onPressed: () {},
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    "Resend OTP",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 10, right: 15),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 1,
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                  child: TextField(
                    controller: referrelController,
                    enabled: referrelController.text.isEmpty ? true : false,
                    decoration: InputDecoration(
                      labelText: 'Enter Referrel Code (Optional)',
                      border: InputBorder.none,
                      labelStyle: TextStyle(
                        color: Colors.black.withOpacity(0.4),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Center(
                child: InkWell(
                  onTap: () {
                    signInwithPhoneNumber2(widget.phone, widget.verId,
                        otpController.text, context);
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width / 1.4,
                    decoration: BoxDecoration(
                      color: primeColor2,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 1,
                        )
                      ],
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Verify",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void setData(String verificationId) {
    setState(() {
      verificationIdFinal = verificationId;
    });
  }

  checkRefferalData() async {
    String? refferalId = await getReferralId();
    String? refferalUser = await getReferralUserId();
    if (refferalId != null && refferalUser != null) {
      setState(() {
        referrelController.text = refferalId;
        refferalUserIdController.text = refferalUser;
      });
      FirebaseFirestore.instance
          .collection('user_token')
          .doc(refferalUserIdController.text)
          .get()
          .then(
        (value) {
          setState(() {
            reffererToken = value.get('token');
          });
          log('refer token is $reffererToken');
        },
      );
      log('refferal data is $reffererToken ${referrelController.text} ${refferalUserIdController.text} $refferalUser');
    }
  }
}
