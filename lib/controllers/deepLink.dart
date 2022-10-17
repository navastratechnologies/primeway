// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, file_names

import 'dart:math';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

class DeepLinkService {
  DeepLinkService._();
  static DeepLinkService? _instance;
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  static DeepLinkService? get instance {
    _instance ??= DeepLinkService._();
    return _instance;
  }

  ValueNotifier<String> referrerCode = ValueNotifier<String>('');

  final dynamicLink = FirebaseDynamicLinks.instance;

  Future<void> handleDynamicLinks() async {
    //Get initial dynamic link if app is started using the link
    final data = await dynamicLink.getInitialLink();
    if (data != null) {
      handleDeepLink(data);
    }

    //handle foreground
    dynamicLink.onLink.listen((event) {
      handleDeepLink(event);
    }).onError((v) {
      debugPrint('Failed: $v');
    });
  }

  String docId = '1234567890';
  String url = 'https://prime.page.link';

  buildDynamicLinks(String url, String titles, String docId, referCode) async {
    final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse("https://prime.page.link/NLtk/$docId?code=$referCode"),
      uriPrefix: "https://prime.page.link",
      androidParameters:
          const AndroidParameters(packageName: "com.example.primeway"),
      socialMetaTagParameters: const SocialMetaTagParameters(
        title: 'REFER A FRIEND & EARN',
        description: 'Earn 1,500 P-Coins on every referral',
      ),
    );
    final dynamicLink =
        await FirebaseDynamicLinks.instance.buildLink(dynamicLinkParams);

    // log('url is $dynamicLink');

    Share.share(
      dynamicLink.toString(),
    );
  }

  Future<void> handleDeepLink(PendingDynamicLinkData data) async {
    final Uri deepLink = data.link;
    var isRefer = deepLink.pathSegments.contains('refer');
    if (isRefer) {
      var code = deepLink.queryParameters['code'];
      if (code != null) {
        referrerCode.value = code;
        debugPrint('ReferrerCode $referrerCode');
        referrerCode.notifyListeners();
      }
    }
  }
}

class CodeGenerator {
  static Random random = Random();

  static String generateCode(String prefix) {
    var id = random.nextInt(92143543) + 09451234356;
    return '$prefix-${id.toString().substring(0, 8)}';
  }
}

// class RewardState extends ChangeNotifier {
//   final userRepo = UserRepository.instance;
// }