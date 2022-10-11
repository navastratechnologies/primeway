// ignore_for_file: unnecessary_null_comparison, file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:primewayskills_app/controllers/phone_controller.dart';
import 'package:primewayskills_app/view/dashboard/dashboard.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../complete_profile_screens/complete_profile_screen.dart';

class OtpLoginScreen extends StatefulWidget {
  final String? phone, verId;
  const OtpLoginScreen({super.key, this.phone, this.verId});

  @override
  State<OtpLoginScreen> createState() => _OtpLoginScreenState();
}

class _OtpLoginScreenState extends State<OtpLoginScreen> {
  TextEditingController otpController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;

  String verificationID = "";
  String verificationIdFinal = "";
  AuthClass authClass = AuthClass();

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
        leading: Padding(
          padding: const EdgeInsets.all(10),
          child: InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 18,
                  color: Colors.black.withOpacity(0.4),
                ),
              ),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black.withOpacity(0.6),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 160,
              bottom: 60,
            ),
            child: Center(
              child: Lottie.asset('assets/json/waiting.json'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    Text(
                      'Welcome to Primway!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black.withOpacity(0.6),
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Enter otp received on number to continue.',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black.withOpacity(0.2),
                        // fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 40),
                    PinFieldAutoFill(
                      controller: otpController,
                      codeLength: 6,
                      autoFocus: true,
                      decoration: UnderlineDecoration(
                        textStyle: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        lineHeight: 2,
                        lineStrokeCap: StrokeCap.square,
                        bgColorBuilder: PinListenColorBuilder(
                          Colors.grey.shade200,
                          Colors.grey.shade200,
                        ),
                        colorBuilder: const FixedColorBuilder(
                          Colors.transparent,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: MaterialButton(
                    minWidth: 0,
                    height: 0,
                    color: Colors.red[900],
                    padding: const EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    onPressed: () {
                      if (otpController != null) {
                        authClass.signInwithPhoneNumber(widget.phone!,
                            widget.verId!, otpController.text, context);
                        // verifyOTP();
                      } else {}
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Continue',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.red[700],
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void verifyOTP() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: widget.verId.toString(),
      smsCode: otpController.text,
    );

    await auth.signInWithCredential(credential).then(
      (value) {
        setState(() {
          user = FirebaseAuth.instance.currentUser;
        });
      },
    ).whenComplete(
      () {
        if (user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const Dashboard(
                userId: '',
                userName: '',
              ),
            ),
          );
        } else {
          Fluttertoast.showToast(
            msg: "your are new user",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 100,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const CompleteProfileScreen(),
            ),
          );
        }
      },
    );
  }

  void setData(String verificationId) {
    setState(() {
      verificationIdFinal = verificationId;
    });
  }
}
