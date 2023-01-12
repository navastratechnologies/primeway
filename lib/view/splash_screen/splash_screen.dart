import 'dart:developer';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:primewayskills_app/controllers/phone_controller.dart';
import 'package:primewayskills_app/view/auth_screens/loginHomeScreen.dart';
import 'package:primewayskills_app/view/dashboard/courses_screens/affiliate_course_screen.dart';
import 'package:primewayskills_app/view/dashboard/dashboard.dart';
import 'package:primewayskills_app/view/helpers/colors.dart';

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
    return AnimatedSplashScreen(
      splash: Lottie.asset('assets/loading.json'),
      nextScreen: screen,
      backgroundColor: primeColor,
      splashIconSize: 250,
      splashTransition: SplashTransition.sizeTransition,
      pageTransitionType: PageTransitionType.leftToRightWithFade,
    );
  }

  checkLogin() async {
    String? token = await getToken();
    if (token != null) {
      setState(() {
        screen = const Dashboard();
      });
    } else {
      setState(() {
        screen = const LoginHomeScreen();
      });
    }
  }
}

class DynamicLinkClass {
  Future initDynamicLinks(BuildContext context) async {
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) async {
      String dynamicReferrerId = "${dynamicLinkData.link.queryParameters["userId"]}";
      String dynamicCourseId = "${dynamicLinkData.link.queryParameters["courseId"]}";

      log("initial link $dynamicReferrerId $dynamicCourseId");
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => AffiliateCourseDetailScreen(
            courseId: dynamicCourseId,
            userNumber: dynamicReferrerId,
          ),
        ),
        (route) => false,
      );
    }).onError((error) {
      log('initial link onLink error ${error.message}');
    });
  }
}
