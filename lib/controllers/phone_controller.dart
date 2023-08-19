// ignore_for_file: unused_local_variable, avoid_print, use_build_context_synchronously, unnecessary_null_comparison, unused_element

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:primewayskills_app/view/auth_screens/otpLoginScreen.dart';
import 'package:primewayskills_app/view/auth_screens/signup.dart';
import 'package:primewayskills_app/view/dashboard/dashboard.dart';
import 'package:primewayskills_app/view/helpers/alert_deialogs.dart';
import 'package:primewayskills_app/view/helpers/colors.dart';

const storage = FlutterSecureStorage();

class AuthClass {
  final FirebaseAuth auth = FirebaseAuth.instance;

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
        "Verification Code sent on the phone number",
      );
      setData(verificationID);

      if (verificationID != null) {
        log('user is here ');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpLoginScreen(
              phone: onlyPhone,
              verId: verificationID,
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
      alertDialogWidget(
        context,
        primeColor,
        e.toString(),
      );
    }
  }

  Future<void> verifyPhoneNumber2(String phoneNumber, String onlyPhone,
      BuildContext context, Function setData) async {
    verificationCompleted(PhoneAuthCredential phoneAuthCredential) async {
      // showSnackBar(context, "Verification Completed");
    }

    verificationFailed(FirebaseAuthException exception) {
      alertDialogWidget(
        context,
        primeColor,
        exception.toString(),
      );
    }

    codeSent(String verificationID, [int? forceResnedingtoken]) {
      alertDialogWidget(
        context,
        primeColor2,
        "Verification Code sent on Verification Code sent on +91$phoneNumber",
      );
      setData(verificationID);

      if (verificationID != null) {
        log('user is here ');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SignUpScreen(
              phone: onlyPhone,
              verId: verificationID,
            ),
          ),
        );
      } else {
        // log('user is not here ');
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => SignUpScreen(
        //       phone: onlyPhone,
        //       verId: verificationID,
        //       phoneNumber: phoneNumber,
        //     ),
        //   ),
        // );
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
    }
  }

  // Future<void> signInwithPhoneNumber2(String phoneNumber, String verificationId,
  //     String smsCode, BuildContext context) async {
  //   try {
  //     PhoneAuthCredential credential = PhoneAuthProvider.credential(
  //         verificationId: verificationId, smsCode: smsCode);

  //     UserCredential userCredential =
  //         await auth.signInWithCredential(credential);
  //     // showSnackBar(context, "logged In");
  //     User? user = userCredential.user;
  //     if (userCredential.additionalUserInfo!.isNewUser) {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => EditAddressPage(
  //             phoneNumber: phoneNumber,
  //           ),
  //         ),
  //       );
  //       // Fluttertoast.showToast(
  //       //   msg: "your are new user",
  //       //   toastLength: Toast.LENGTH_SHORT,
  //       //   gravity: ToastGravity.BOTTOM,
  //       //   timeInSecForIosWeb: 100,
  //       //   backgroundColor: Colors.red,
  //       //   textColor: Colors.white,
  //       //   fontSize: 16.0,
  //       // );
  //     } else {
  //       storeTokenAndData(phoneNumber);
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => const Dashboard(),
  //         ),
  //       );
  //     }
  //     log('user is $userCredential');
  //   } catch (e) {
  //     showSnackBar(context, e.toString());
  //   }
  // }

  void showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> signOut({BuildContext? context}) async {
    try {
      await auth.signOut();
      await storage.delete(key: "phoneuserid");
      alertDialogWidget(
        context,
        purpleColor,
        'Sign Out Successfully',
      );
    } catch (e) {
      alertDialogWidget(
        context,
        primeColor,
        e.toString(),
      );
    }
  }

  // Future<UserCredential> signInWithGoogle(context) async {
  //   // Trigger the authentication flow

  //   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  //   // Obtain the auth details from the request
  //   final GoogleSignInAuthentication? googleAuth =
  //       await googleUser?.authentication;

  //   // Create a new credential
  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth?.accessToken,
  //     idToken: googleAuth?.idToken,
  //   );

  //   // Once signed in, return the UserCredential
  //   UserCredential userCredential =
  //       await FirebaseAuth.instance.signInWithCredential(credential);

  //   User? user = userCredential.user;
  //   FirebaseFirestore.instance
  //       .collection('users')
  //       .where('email', isEqualTo: userCredential.user!.email)
  //       .get()
  //       .then(
  //     (value) {
  //       if (value.docs.isNotEmpty) {
  //         log('user is old');
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => const Dashboard(),
  //           ),
  //         );
  //       } else {
  //         log('user is new');
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => const SignUpScreen(
  //               phone: 'phoneNumber',
  //               verId: 'verificationId',
  //             ),
  //           ),
  //         );
  //       }
  //     },
  //   );
  //   if (userCredential.additionalUserInfo!.isNewUser) {
  //     Fluttertoast.showToast(
  //       msg: "your are new user",
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.BOTTOM,
  //       timeInSecForIosWeb: 100,
  //       backgroundColor: Colors.red,
  //       textColor: Colors.white,
  //       fontSize: 16.0,
  //     );
  //     log('if is new');
  //   } else {
  //     log('else is old');
  //   }

  //   // log('user is $userCredential');
  //   return FirebaseAuth.instance.signInWithCredential(credential);
  // }

  // Future<UserCredential> signInWithFacebook(context) async {
  //   // Trigger the sign-in flow

  //   final LoginResult loginResult = await FacebookAuth.instance.login();

  //   // Create a credential from the access token
  //   final OAuthCredential facebookAuthCredential =
  //       FacebookAuthProvider.credential(loginResult.accessToken!.token);

  //   // Once signed in, return the UserCredential
  //   UserCredential userCredential = await FirebaseAuth.instance
  //       .signInWithCredential(facebookAuthCredential);

  //   User? user = userCredential.user;
  //   if (userCredential.additionalUserInfo!.isNewUser) {
  //     // Fluttertoast.showToast(
  //     //   msg: "your are new user",
  //     //   toastLength: Toast.LENGTH_SHORT,
  //     //   gravity: ToastGravity.BOTTOM,
  //     //   timeInSecForIosWeb: 100,
  //     //   backgroundColor: Colors.red,
  //     //   textColor: Colors.white,
  //     //   fontSize: 16.0,
  //     // );
  //   } else {
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => const Dashboard(),
  //       ),
  //     );
  //   }

  //   log('user is $userCredential');

  //   return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  // }

  // String generateNonce([int length = 32]) {
  //   const charset =
  //       '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
  //   final random = math.Random.secure();
  //   return List.generate(length, (_) => charset[random.nextInt(charset.length)])
  //       .join();
  // }

  // /// Returns the sha256 hash of [input] in hex notation.
  // String sha256ofString(String input) {
  //   final bytes = utf8.encode(input);
  //   final digest = sha256.convert(bytes);
  //   return digest.toString();
  // }

  // Future<UserCredential> signInWithApple(BuildContext context) async {
  //   // To prevent replay attacks with the credential returned from Apple, we
  //   // include a nonce in the credential request. When signing in with
  //   // Firebase, the nonce in the id token returned by Apple, is expected to
  //   // match the sha256 hash of `rawNonce`.
  //   final rawNonce = generateNonce();
  //   final nonce = sha256ofString(rawNonce);

  //   // Request credential for the currently signed in Apple account.
  //   final appleCredential = await SignInWithApple.getAppleIDCredential(
  //     scopes: [
  //       AppleIDAuthorizationScopes.email,
  //       AppleIDAuthorizationScopes.fullName,
  //     ],
  //     nonce: nonce,
  //   );

  //   // Create an `OAuthCredential` from the credential returned by Apple.
  //   final oauthCredential = OAuthProvider("apple.com").credential(
  //     idToken: appleCredential.identityToken,
  //     rawNonce: rawNonce,
  //   );

  //   // Sign in the user with Firebase. If the nonce we generated earlier does
  //   // not match the nonce in `appleCredential.identityToken`, sign in will fail.
  //   return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  // }
}

void storeTokenAndData(username) async {
  print("storing token and data");
  await storage.write(key: "token", value: username.toString());
}

void storeReffererData(userId, referralId) async {
  await storage.write(key: "referralUserId", value: userId.toString());
  await storage.write(key: "referralId", value: referralId.toString());
  log("refferal token stored ${userId.toString()} ${referralId.toString()}");
}

Future<String?> getToken() async {
  return await storage.read(key: "token");
}

Future<String?> getReferralUserId() async {
  return await storage.read(key: "referralUserId");
}

Future<String?> getReferralId() async {
  return await storage.read(key: "referralId");
}
