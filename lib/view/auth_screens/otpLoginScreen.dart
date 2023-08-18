// ignore_for_file: unnecessary_null_comparison, file_names

import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:primewayskills_app/controllers/phone_controller.dart';
import 'package:primewayskills_app/view/auth_screens/phoneLoginScreen.dart';
import 'package:primewayskills_app/view/auth_screens/signup.dart';
import 'package:primewayskills_app/view/dashboard/dashboard.dart';
import 'package:primewayskills_app/view/helpers/alert_deialogs.dart';
import 'package:primewayskills_app/view/helpers/colors.dart';
import 'package:primewayskills_app/view/helpers/loader.dart';
import 'package:primewayskills_app/view/helpers/responsive_size_helper.dart';
// import 'package:sms_autofill/sms_autofill.dart';

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

  bool showLoader = false;

  StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>();
  String currentText = '';

  Future<void> signInwithPhoneNumber(String phoneNumber, String verificationId,
      String smsCode, BuildContext context) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);

      UserCredential userCredential =
          await auth.signInWithCredential(credential);
      // showSnackBar(context, "logged In");
      User? user = userCredential.user;
      if (userCredential.additionalUserInfo!.isNewUser) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SignUpScreen(
              phone: phoneNumber,
              verId: verificationId,
            ),
          ),
        );
      } else {
        storeTokenAndData(phoneNumber);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Dashboard(),
          ),
        );
      }
      log('user is $userCredential');
    } catch (e) {
      alertDialogWidget(
        context,
        primeColor,
        e.toString(),
      );
      setState(() {
        showLoader = false;
      });
    }
  }

  Future<void> verifyPhoneNumber(String phoneNumber, String onlyPhone,
      BuildContext context, Function setData) async {
    verificationCompleted(PhoneAuthCredential phoneAuthCredential) async {
      // showSnackBar(context, "Verification Completed");
    }

    verificationFailed(FirebaseAuthException exception) {
      alertDialogWidget(context, primeColor, exception.toString());
    }

    codeSent(String verificationID, [int? forceResnedingtoken]) {
      alertDialogWidget(
        context,
        primeColor2,
        "Verification Code sent on +91$phoneNumber",
      );
      setData(verificationID);

      setState(() {
        showLoader = false;
      });
    }

    codeAutoRetrievalTimeout(String verificationID) {}
    try {
      await auth.verifyPhoneNumber(
        timeout: const Duration(seconds: 120),
        phoneNumber: phoneNumber,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );
    } catch (e) {
      alertDialogWidget(
        context,
        primeColor,
        e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: Padding(
              padding: const EdgeInsets.all(10),
              child: InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PhoneLoginScreen(),
                  ),
                ),
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
                        // PinFieldAutoFill(
                        //   controller: otpController,
                        //   codeLength: 6,
                        //   autoFocus: true,
                        //   decoration: UnderlineDecoration(
                        //     textStyle:   TextStyle(
                        //       color: Colors.black,
                        //       fontWeight: FontWeight.bold,
                        //     ),
                        //     lineHeight: 2,
                        //     lineStrokeCap: StrokeCap.round,
                        //     bgColorBuilder: PinListenColorBuilder(
                        //       Colors.grey.shade100,
                        //       Colors.grey.shade100,
                        //     ),
                        //     colorBuilder:   FixedColorBuilder(
                        //       Colors.transparent,
                        //     ),
                        //   ),
                        // ),
                        SizedBox(
                          width: displayWidth(context) / 1.3,
                          child: PinCodeTextField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please Fill OTP";
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                            length: 6,
                            obscureText: false,
                            animationType: AnimationType.fade,
                            cursorColor: Colors.black,
                            pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              borderRadius: BorderRadius.circular(5),
                              fieldHeight: 45,
                              fieldWidth: 40,
                              activeFillColor: Colors.white,
                              inactiveFillColor: Colors.grey.withOpacity(0.3),
                              borderWidth: 0,
                              selectedFillColor: Colors.grey.withOpacity(0.3),
                            ),
                            animationDuration:
                                const Duration(milliseconds: 300),
                            // backgroundColor: Colors.blue.shade50,
                            enableActiveFill: true,
                            errorAnimationController: errorController,
                            controller: otpController,
                            onCompleted: (v) {
                              print("Completed");
                            },
                            onChanged: (value) {
                              print(value);
                              setState(() {
                                currentText = value;
                              });
                            },
                            beforeTextPaste: (text) {
                              print("Allowing to paste $text");
                              return true;
                            },
                            appContext: context,
                          ),
                        ),

                        const SizedBox(height: 5),
                        Align(
                          alignment: Alignment.topRight,
                          child: MaterialButton(
                            color: primeColor2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            onPressed: () {
                              if (widget.phone != "") {
                                var phonenumber = '+91${widget.phone}';
                                setState(() {
                                  showLoader = true;
                                });
                                authClass.verifyPhoneNumber(
                                  phonenumber,
                                  widget.phone!,
                                  context,
                                  setData,
                                );
                              }
                            },
                            child: Text(
                              'Resend Code',
                              style: TextStyle(
                                color: whiteColor,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
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
                            setState(() {
                              showLoader = true;
                            });
                            signInwithPhoneNumber(widget.phone!, widget.verId!,
                                otpController.text, context);
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
        ),
        showLoader ? const LoaderWidget() : Container(),
      ],
    );
  }

  void setData(String verificationId) {
    setState(() {
      verificationIdFinal = verificationId;
    });
  }
}
