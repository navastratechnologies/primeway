// ignore_for_file: unused_local_variable, avoid_print

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:primewayskills_app/view/auth_screens/otpLoginScreen.dart';

class AuthClass {
  final storage = const FlutterSecureStorage();
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
      // ignore: unnecessary_null_comparison
      if (verificationID != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpLoginScreen(
              phone: onlyPhone,
              verId: verificationID,
            ),
          ),
        );
      }
    }

    codeAutoRetrievalTimeout(String verificationID) {}
    try {
      await auth.verifyPhoneNumber(
        timeout: const Duration(seconds: 60),
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

  void storeTokenAndData(username, email, gender) async {
    print("storing token and data");
    await storage.write(key: "token", value: username.toString());
    await storage.write(key: "email", value: email.toString());
    await storage.write(key: "gender", value: gender.toString());
  }

  Future<UserCredential> signInWithGoogle() async {
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

    log('user is $userCredential');

    return FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // Once signed in, return the UserCredential
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithCredential(facebookAuthCredential);

    log('user is $userCredential');

    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }
}
