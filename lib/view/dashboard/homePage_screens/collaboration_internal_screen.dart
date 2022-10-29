// ignore_for_file: avoid_print, invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'dart:developer';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:primewayskills_app/view/complete_profile_screens/complete_profile_screen.dart';
import 'package:primewayskills_app/view/helpers/colors.dart';
import 'package:primewayskills_app/view/helpers/helping_widgets.dart';
import 'package:share/share.dart';

class CollaborationInternalScreen extends StatefulWidget {
  final String heading,
      image,
      paragraph,
      followerDetails,
      brandlogo,
      categories,
      collaborationtype,
      language,
      titles,
      productCategorey;
  final String userNumber;
  final String userName;
  final String userAddress;
  final String userProfileImage;
  final String userPayment;
  final String userEmail;
  final String userWalletId;
  const CollaborationInternalScreen(
      {Key? key,
      required this.heading,
      required this.image,
      required this.paragraph,
      required this.followerDetails,
      required this.brandlogo,
      required this.categories,
      required this.language,
      required this.collaborationtype,
      required this.titles,
      required this.productCategorey,
      required this.userNumber,
      required this.userName,
      required this.userAddress,
      required this.userProfileImage,
      required this.userPayment,
      required this.userEmail,
      required this.userWalletId})
      : super(key: key);

  @override
  State<CollaborationInternalScreen> createState() =>
      _CollaborationInternalScreenState();
}

class DeepLinkService {
  DeepLinkService._();
  static DeepLinkService? _instance;
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  static DeepLinkService? get instance {
    _instance ??= DeepLinkService._();
    return _instance;
  }

  ValueNotifier<String> referrerCode = ValueNotifier<String>('');
  String url = 'https://centurus.page.link';

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

  buildDynamicLinks(String url, String titles, String docId, referCode) async {
    final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse("https://prime.page.link/TG78/$docId?code=$referCode"),
      uriPrefix: "https://centurus.page.link",
      androidParameters:
          const AndroidParameters(packageName: "com.example.primeway"),
      socialMetaTagParameters: const SocialMetaTagParameters(
        // imageUrl: ,
        title: 'REFER A FRIEND & EARN',
        description: 'Earn 1,500 P-Coins on every referral',
      ),
    );
    final dynamicLink =
        await FirebaseDynamicLinks.instance.buildLink(dynamicLinkParams);

    log('url is $dynamicLink');

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

// class CodeGenerator {
//   static Random random = Random();

//   static String generateCode(String prefix) {
//     var id = random.nextInt(92143543) + 09451234356;
//     return '$prefix-${id.toString().substring(0, 8)}';
//   }
// }

// class RewardState extends ChangeNotifier {
//   final userRepo = UserRepository.instance;
// }

class _CollaborationInternalScreenState
    extends State<CollaborationInternalScreen> {
  String url = 'https://centurus.page.link';

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primeColor,
        title: Text(
          widget.titles,
          style: TextStyle(
            fontSize: maxSize,
            color: whiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: height / 4,
              width: width,
              decoration: BoxDecoration(
                color: primeColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                image: DecorationImage(
                  image: NetworkImage(
                    widget.image,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Applications Open',
                        style: TextStyle(
                          color: whiteColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.instagram,
                            color: primeColor,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            widget.followerDetails,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          DeepLinkService._().buildDynamicLinks(
                              url, widget.titles, widget.userNumber, '0000');
                        },
                        child: SizedBox(
                          width: 35,
                          child: FaIcon(
                            FontAwesomeIcons.shareNodes,
                            color: primeColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.titles,
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.4),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  // SizedBox(
                  //     height: 50,
                  //     width: 100,
                  //     child: Image.network(
                  //       widget.heading,
                  //       fit: BoxFit.cover,
                  //     )),
                  const SizedBox(height: 20),
                  Text(
                    widget.paragraph,
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.4),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 30),
                  headingWidgetMethod('Application Criteria'),
                  const SizedBox(height: 20),
                  Container(
                    width: width,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black.withOpacity(0.2),
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.peopleGroup,
                              color: Colors.black.withOpacity(0.4),
                              size: 17,
                            ),
                            const SizedBox(width: 20),
                            Text(
                              widget.followerDetails,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green,
                          ),
                          child: Icon(
                            Icons.check,
                            color: whiteColor,
                            size: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: width,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black.withOpacity(0.2),
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 35,
                              child: FaIcon(
                                FontAwesomeIcons.person,
                                color: Colors.black.withOpacity(0.4),
                                size: 17,
                              ),
                            ),
                            Text(
                              widget.categories,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: primeColor,
                          ),
                          child: Icon(
                            Icons.close,
                            color: whiteColor,
                            size: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: width,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black.withOpacity(0.2),
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 35,
                              child: FaIcon(
                                FontAwesomeIcons.language,
                                color: Colors.black.withOpacity(0.4),
                                size: 17,
                              ),
                            ),
                            Text(
                              widget.language,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: primeColor,
                          ),
                          child: Icon(
                            Icons.close,
                            color: whiteColor,
                            size: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  headingWidgetMethod('Additional Requirements'),
                  const SizedBox(height: 20),
                  listOrderWidget('Foodie'),
                  const SizedBox(height: 14),
                  listOrderWidget('Overseas Students'),
                  const SizedBox(height: 14),
                  listOrderWidget('Travel'),
                  const SizedBox(height: 14),
                  listOrderWidget('Food Bloggers'),
                  const SizedBox(height: 14),
                  listOrderWidget("Recipe's"),
                  const SizedBox(height: 14),
                  listOrderWidget('Ready to eat food reviews'),
                  const SizedBox(height: 14),
                  listOrderWidget('Food Reviews'),
                  const SizedBox(height: 14),
                  listOrderWidget('Should have followers between 1and 307.5M'),
                  const SizedBox(height: 30),
                  headingWidgetMethod('Help & Support'),
                  const SizedBox(height: 10),
                  Text(
                    'In case of any queries, checkout the FAQs or contact us',
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.4),
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.envelope,
                            color: primeColor,
                            size: maxSize,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Email',
                            style: TextStyle(
                              color: primeColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Container(
                        height: 20,
                        width: 2,
                        color: primeColor,
                      ),
                      const SizedBox(width: 20),
                      Row(
                        children: [
                          Icon(
                            Icons.contact_support_outlined,
                            color: primeColor,
                            size: maxSize,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'FAQs',
                            style: TextStyle(
                              color: primeColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 70,
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CompleteProfileScreen(
                        userNumber: widget.userNumber,
                        userAddress: widget.userAddress,
                        userEmail: widget.userEmail,
                        userName: widget.userName,
                        userPayment: widget.userPayment,
                        userProfileImage: widget.userProfileImage,
                        userWalletId: widget.userWalletId),
                  ),
                );
              },
              child: Container(
                height: 50,
                width: width / 1.5,
                decoration: BoxDecoration(
                  color: primeColor,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'Complete Your Profile To Apply',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: maxSize - 3,
                      color: whiteColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
