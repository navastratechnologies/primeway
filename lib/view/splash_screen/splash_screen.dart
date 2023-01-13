import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:primewayskills_app/controllers/phone_controller.dart';
import 'package:primewayskills_app/view/auth_screens/loginHomeScreen.dart';
import 'package:primewayskills_app/view/helpers/colors.dart';
import 'package:primewayskills_app/view/helpers/responsive_size_helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Widget screen = const LoginHomeScreen();
  DynamicLinkClass dynamic = DynamicLinkClass();

  @override
  void initState() {
    dynamic.initDynamicLinks(context);
    checkLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: displayHeight(context),
        width: displayWidth(context),
        decoration: BoxDecoration(
          color: primeColor,
        ),
        child: Center(
          child: Lottie.asset('assets/loading.json'),
        ),
      ),
    );
  }

  checkLogin() async {
    String? token = await getToken();
    if (token != null) {
      context.go('/homeScreen/');
    } else {
      context.go('/loginScreen/');
    }
  }
}

class DynamicLinkClass {
  Future initDynamicLinks(BuildContext context) async {
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) async {
      String dynamicReferrerId =
          "${dynamicLinkData.link.queryParameters["userId"]}";
      String dynamicCourseId =
          "${dynamicLinkData.link.queryParameters["courseId"]}";

      String dynamicreferralCode =
          "${dynamicLinkData.link.queryParameters["referrelId"]}";

      log("initial link $dynamicReferrerId $dynamicCourseId $dynamicreferralCode");
      if (dynamicCourseId.isEmpty ||
          dynamicCourseId == "" ||
          dynamicCourseId == "null") {
        storeReffererData(
          dynamicReferrerId,
          dynamicreferralCode,
        );
        FirebaseFirestore.instance
            .collection('users')
            .doc(dynamicReferrerId)
            .get()
            .then((value) {
          var totalRefferals = value.get('total_refferals');
          int totalRefferalInc = int.parse(totalRefferals) + 1;
          FirebaseFirestore.instance
              .collection('users')
              .doc(dynamicReferrerId)
              .update({
            "total_refferals": totalRefferalInc.toString(),
          });
          log('total refferal is $totalRefferals $totalRefferalInc');
        });
        context.go('/loginScreen/');
        log('dynamic url is courseid empty');
      } else {
        log('dynamic url is courseid not empty');
        context
            .go('/affiliateCourseScreen/$dynamicCourseId/$dynamicReferrerId');
      }
    }).onError((error) {
      log('initial link onLink error ${error.message}');
    });
  }
}
