// ignore_for_file: avoid_print, file_names, unnecessary_null_comparison, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:primewayskills_app/controllers/phone_controller.dart';
import 'package:primewayskills_app/view/auth_screens/loginHomeScreen.dart';
import 'package:primewayskills_app/view/helpers/alert_deialogs.dart';
import 'package:primewayskills_app/view/helpers/colors.dart';
import 'package:primewayskills_app/view/helpers/loader.dart';

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  TextEditingController phoneController = TextEditingController();
  final storage = const FlutterSecureStorage();
  final FirebaseAuth auth = FirebaseAuth.instance;
  AuthClass authClass = AuthClass();
  String verificationIdFinal = "";
  String phonenumber = '';

  String verificationID = "";

  bool showLoader = false;

  Future<void> checkNumber() async {
    var a = await FirebaseFirestore.instance
        .collection('users')
        .doc(phoneController.text)
        .get();
    if (a.exists && phoneController.text.isNotEmpty) {
      String countryCode = '+91';
      phonenumber = '$countryCode${phoneController.text}';
      authClass.verifyPhoneNumber(
        phonenumber,
        phoneController.text,
        context,
        setData,
      );
    } else if (phoneController.text.isNotEmpty) {
      String countryCode = '+91';
      phonenumber = '$countryCode${phoneController.text}';
      authClass.verifyPhoneNumber2(
        phonenumber,
        phoneController.text,
        context,
        setData,
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
                    builder: (context) => const LoginHomeScreen(),
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
                  child: Lottie.asset('assets/json/sanyasi_baba.json'),
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
                          'Enter your phone number to continue.',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black.withOpacity(0.2),
                            // fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 40),
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.black.withOpacity(0.1),
                                width: 2,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 100,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Icon(
                                      Icons.phone_android,
                                      color: Colors.black.withOpacity(0.2),
                                    ),
                                    Image.asset(
                                      'assets/india-flag.png',
                                      height: 30,
                                      width: 30,
                                    ),
                                    Text(
                                      '+91',
                                      style: TextStyle(
                                        color: Colors.black.withOpacity(0.3),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 1.67,
                                child: TextFormField(
                                  controller: phoneController,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Enter Phone Number',
                                    hintStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(10),
                                  ],
                                ),
                              ),
                            ],
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
                          if (phoneController.text.isNotEmpty) {
                            FocusManager.instance.primaryFocus?.unfocus();
                            setState(() {
                              showLoader = true;
                            });
                            checkNumber();
                          } else {
                            alertDialogWidget(
                              context,
                              primeColor,
                              'Please enter phone number to continue',
                            );
                          }
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
