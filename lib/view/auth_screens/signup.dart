import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:primewayskills_app/view/helpers/colors.dart';
import 'package:primewayskills_app/view/helpers/responsive_size_helper.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'dart:math' as math;
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

  final CollectionReference<Map<String, dynamic>> users =
      FirebaseFirestore.instance.collection('users');

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
          .then((value) {
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
            .collection('users')
            .doc(refferalUserIdController.text)
            .collection('refferal')
            .add(
          {
            "refferal_point": referralCharges.toString(),
            "user_id": widget.phone,
            "user_name":
                "${firstNameController.text} ${lastNameController.text}",
          },
        );
        log('total refferal is $totalRefferalEarnings $totalRefferalEarningInc');
      });
    }
  }

  Future<void> createUserChapterCollection() async {
    users.doc(widget.phone).collection('courses').doc().set({
      'author_name': '',
      'courses_id': '',
      'image': '',
      'name': '',
    });
  }

  Future<void> createUserRefferalCollection() async {
    users.doc(widget.phone).collection('refferal').doc().set({
      'user_id': '',
      'user_name': '',
      'refferal_point': '',
    });
  }

  Future<void> createWalletCollection() async {
    FirebaseFirestore.instance.collection('wallet').doc(widget.phone).set({
      'account_holder_name': '',
      'account_number': '',
      'bank_name': '',
      'earned_pcoins': '',
      'ifsc_code': '',
      'status': '',
      'total_withdrawal': '',
      'user_id': widget.phone,
      'user_name': "${firstNameController.text} ${lastNameController.text}",
      'wallet_balance': '',
      'withdrawal_req': '',
      'account_type': '',
    });
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

  _listenSmsCode() async {
    await SmsAutoFill().listenForCode();
  }

  @override
  void initState() {
    _listenSmsCode();
    checkRefferalData();
    getReferalCharge();
    super.initState();
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
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
                        "Welcome to PrimeWaySkills",
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
                const Text(
                  "Change",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: Colors.red,
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
                    authClass.signInwithPhoneNumber2(widget.phone, widget.verId,
                        otpController.text, context);
                    createUserCollection();
                    createUserChapterCollection();
                    createUserRefferalCollection();
                    createWalletCollection();
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
      log('refferal data is ${referrelController.text} ${refferalUserIdController.text}');
    }
  }
}
