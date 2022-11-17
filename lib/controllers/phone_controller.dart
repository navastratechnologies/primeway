// ignore_for_file: unused_local_variable, avoid_print, use_build_context_synchronously, unnecessary_null_comparison, unused_element

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:primewayskills_app/view/auth_screens/address.dart';
import 'package:primewayskills_app/view/auth_screens/otpLoginScreen.dart';
import 'package:primewayskills_app/view/auth_screens/signup.dart';
import 'package:primewayskills_app/view/dashboard/dashboard.dart';

const storage = FlutterSecureStorage();

class AuthClass {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> verifyPhoneNumber(String phoneNumber, String onlyPhone,
      BuildContext context, Function setData) async {
    verificationCompleted(PhoneAuthCredential phoneAuthCredential) async {
      // showSnackBar(context, "Verification Completed");
    }

    verificationFailed(FirebaseAuthException exception) {
      showSnackBar(context, exception.toString());
    }

    codeSent(String verificationID, [int? forceResnedingtoken]) {
      showSnackBar(context, "Verification Code sent on the phone number");
      setData(verificationID);

      if (verificationID != null) {
        log('user is here ');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpLoginScreen(
              phone: onlyPhone,
              verId: verificationID,
              phoneNumber: phoneNumber,
            ),
          ),
        );
      } else {
        log('user is not here ');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SignUpScreen(
              phone: onlyPhone,
              verId: verificationID,
              phoneNumber: phoneNumber,
            ),
          ),
        );
      }
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
      showSnackBar(context, e.toString());
    }
  }

  Future<void> verifyPhoneNumber2(String phoneNumber, String onlyPhone,
      BuildContext context, Function setData) async {
    verificationCompleted(PhoneAuthCredential phoneAuthCredential) async {
      // showSnackBar(context, "Verification Completed");
    }

    verificationFailed(FirebaseAuthException exception) {
      showSnackBar(context, exception.toString());
    }

    codeSent(String verificationID, [int? forceResnedingtoken]) {
      showSnackBar(context, "Verification Code sent on the phone number");
      setData(verificationID);

      if (verificationID != null) {
        log('user is here ');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SignUpScreen(
              phone: onlyPhone,
              verId: verificationID,
              phoneNumber: phoneNumber,
            ),
          ),
        );
      } else {
        log('user is not here ');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SignUpScreen(
              phone: onlyPhone,
              verId: verificationID,
              phoneNumber: phoneNumber,
            ),
          ),
        );
      }
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
      showSnackBar(context, e.toString());
    }
  }

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
              phoneNumber: phoneNumber,
              phone: phoneNumber,
              verId: verificationId,
            ),
          ),
        );
        Fluttertoast.showToast(
          msg: "your are new user",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 100,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
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
      showSnackBar(context, e.toString());
    }
  }

  Future<void> signInwithPhoneNumber2(String phoneNumber, String verificationId,
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
            builder: (context) => EditAddressPage(
              phoneNumber: phoneNumber,
            ),
          ),
        );
        // Fluttertoast.showToast(
        //   msg: "your are new user",
        //   toastLength: Toast.LENGTH_SHORT,
        //   gravity: ToastGravity.BOTTOM,
        //   timeInSecForIosWeb: 100,
        //   backgroundColor: Colors.red,
        //   textColor: Colors.white,
        //   fontSize: 16.0,
        // );
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
      showSnackBar(context, e.toString());
    }
  }

  void showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> signOut({BuildContext? context}) async {
    try {
      await auth.signOut();
      await storage.delete(key: "phoneuserid");
    } catch (e) {
      final snackBar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context!).showSnackBar(snackBar);
    }
  }

  Future<UserCredential> signInWithGoogle(context) async {
    // Trigger the authentication flow

    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    User? user = userCredential.user;
    if (userCredential.additionalUserInfo!.isNewUser) {
      Fluttertoast.showToast(
        msg: "your are new user",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 100,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      log('if is new');
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Dashboard(),
        ),
      );
      log('else is old');
    }

    log('user is $userCredential');
    return FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<UserCredential> signInWithFacebook(context) async {
    // Trigger the sign-in flow

    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // Once signed in, return the UserCredential
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithCredential(facebookAuthCredential);

    User? user = userCredential.user;
    if (userCredential.additionalUserInfo!.isNewUser) {
      Fluttertoast.showToast(
        msg: "your are new user",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 100,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Dashboard(),
        ),
      );
    }

    log('user is $userCredential');

    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }
}

void storeTokenAndData(username) async {
  print("storing token and data");
  await storage.write(key: "token", value: username.toString());
}

Future<String?> getToken() async {
  return await storage.read(key: "token");
}
