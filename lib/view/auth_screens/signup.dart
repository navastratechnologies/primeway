import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:primewayskills_app/view/auth_screens/address.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../../controllers/phone_controller.dart';

class SignUpScreen extends StatefulWidget {
  final String phoneNumber;
  final String phone, verId;
  const SignUpScreen(
      {super.key,
      required this.phoneNumber,
      required this.phone,
      required this.verId});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String phonenumber = '';
  AuthClass authClass = AuthClass();
  String verificationIdFinal = "";

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  final CollectionReference<Map<String, dynamic>> users =
      FirebaseFirestore.instance.collection('users');

  Future<void> createUserCollection() async {
    users.doc(widget.phoneNumber).set({
      'user_Id': widget.phoneNumber,
      'name': "${firstNameController.text} ${lastNameController.text}",
      'email': emailController.text,
      'phone_number': widget.phoneNumber,
      'address': '',
      'affilate_id': '',
      'approval_status': '',
      'earning_by_refferals': '',
      'payments': '',
      'photo_url': '',
      'profile_pic': '',
      'social_account': '',
      'total_refferals': '',
      'wallet_id': widget.phoneNumber,
      'front_document': '',
      'back_document': '',
      'document_type': '',
    });
  }

  Future<void> createUserChapterCollection() async {
    users.doc(widget.phoneNumber).collection('courses').doc().set({
      'author_name': '',
      'courses_id': '',
      'image': '',
      'name': '',
    });
  }

  Future<void> createUserRefferalCollection() async {
    users.doc(widget.phoneNumber).collection('refferal').doc().set({
      'user_id': '',
      'user_name': '',
      'refferal_point': '',
    });
  }

  Future<void> createWalletCollection() async {
    FirebaseFirestore.instance
        .collection('wallet')
        .doc(widget.phoneNumber)
        .set({
      'account_holder_name': '',
      'account_number': '',
      'bank_name': '',
      'earned_pcoins': '',
      'ifsc_code': '',
      'status': '',
      'total_withdrawal': '',
      'user_id': widget.phoneNumber,
      'user_name': "${firstNameController.text} ${lastNameController.text}",
      'wallet_balance': '',
      'withdrawal_req': '',
      'account_type': '',
    });
  }

  _listenSmsCode() async {
    await SmsAutoFill().listenForCode();
  }

  @override
  void initState() {
    _listenSmsCode();
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
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Sign Up",
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 15, top: 10),
            child: Text(
              "Sign Up",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 15, top: 10),
            child: Text(
              "Welcome to PrimeWaySkills",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: Colors.grey),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 15, top: 10),
            child: Text(
              "please help us know more about you.",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: Colors.grey),
            ),
          ),
          const SizedBox(
            height: 10,
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
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: firstNameController,
                  decoration: const InputDecoration(
                    labelText: 'Enter first name',
                    border: InputBorder.none,
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
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: lastNameController,
                  decoration: const InputDecoration(
                    labelText: 'Enter Last name',
                    border: InputBorder.none,
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
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Enter Email id',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 60,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 15, top: 10),
            child: Text(
              "Verify Your Mobile Number",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
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
                "+91- ${widget.phoneNumber}",
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
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: otpController,
                  decoration: const InputDecoration(
                    labelText: 'Enter 6 digit OTP',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              MaterialButton(
                onPressed: () {},
              ),
              const Padding(
                padding: EdgeInsets.only(right: 15),
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
            padding: const EdgeInsets.all(15),
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 1,
                  )
                ],
              ),
              child: InkWell(
                onTap: () {
                  authClass.signInwithPhoneNumber2(
                      widget.phone, widget.verId, otpController.text, context);
                  createUserCollection();
                  createUserChapterCollection();
                  createUserRefferalCollection();
                  createWalletCollection();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditAddressPage(
                        phoneNumber: widget.phoneNumber,
                        // name:
                        //     '${firstNameController.text} ${lastNameController.text}',
                      ),
                    ),
                  );
                },
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
        ],
      ),
    );
  }

  void setData(String verificationId) {
    setState(() {
      verificationIdFinal = verificationId;
    });
  }
}
