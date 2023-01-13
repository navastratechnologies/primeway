import 'dart:developer';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:primewayskills_app/view/helpers/colors.dart';
import 'package:primewayskills_app/view/helpers/responsive_size_helper.dart';
import 'package:share/share.dart';

buidDynamicLinkForReferral(referrelId, userId, functionType, context) async {
  String url = 'https://primewaycollab.page.link';
  final dynamicLinkParams = DynamicLinkParameters(
    link: Uri.parse("$url?userId=$userId&referrelId=$referrelId"),
    uriPrefix: url,
    androidParameters: const AndroidParameters(
      packageName: "com.primeway.app",
      minimumVersion: 0,
    ),
    iosParameters: const IOSParameters(
      bundleId: "com.primeway.app",
      appStoreId: "123456789",
      minimumVersion: "1.0.1",
    ),
    socialMetaTagParameters: SocialMetaTagParameters(
      title: "Hi! Use my refer code $referrelId to download Primeway App. You will get 2 PrimeCoins on sign-up and 2 PrimeCoins on first successful purchase. App download link - ",
      imageUrl: Uri.parse("https://firebasestorage.googleapis.com/v0/b/primeway-e0f3f.appspot.com/o/files%2Fanimation_500_lcud31s1.gif?alt=media&token=3df050d9-93f0-42f7-b5cf-09f8522ddecd"),
    ),
  );

  final dynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(
    dynamicLinkParams,
  );

  log('dynamic link is ${dynamicLink.shortUrl.toString()}');

  if (functionType == "share") {
    Share.share(
      dynamicLink.shortUrl.toString(),
    );
  } else {
    Clipboard.setData(
      ClipboardData(
        text: dynamicLink.shortUrl.toString(),
      ),
    ).then(
      (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            width: displayWidth(context) / 1.5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            behavior: SnackBarBehavior.floating,
            // margin: const EdgeInsets.all(14),
            backgroundColor: primeColor2,
            elevation: 0,
            content: Text(
              "Referrel link copied to clipboard",
              style: TextStyle(
                color: whiteColor,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }
}
