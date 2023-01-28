// ignore_for_file: avoid_print, invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:primewayskills_app/controllers/deepLink.dart';
import 'package:primewayskills_app/view/appbar_screens/profile_edit_screen.dart';
import 'package:primewayskills_app/view/collab_apply_screens/view_brief_screen.dart';
import 'package:primewayskills_app/view/helpers/colors.dart';
import 'package:primewayskills_app/view/helpers/helping_widgets.dart';
import 'package:primewayskills_app/view/helpers/responsive_size_helper.dart';

class CollaborationInternalScreen extends StatefulWidget {
  final String userNumber, collabId;
  const CollaborationInternalScreen({
    Key? key,
    required this.userNumber,
    required this.collabId,
  }) : super(key: key);

  @override
  State<CollaborationInternalScreen> createState() =>
      _CollaborationInternalScreenState();
}

class _CollaborationInternalScreenState
    extends State<CollaborationInternalScreen> {
  String url = 'https://primeway.page.link';

  int profileCompletionPercentage = 0;

  // collab values
  String title = '';
  String image = '';
  String brandLogo = '';
  int followersFrom = 0;
  int followersTo = 0;
  String description = '';
  String contentLanguage = '';
  List contentLanguageList = [];
  String categories = '';
  List categoriesList = [];
  String applicationStatus = '';
  String collabType = '';

  // user values
  int userFollowers = 0;
  List userContentLanguage = [];
  List userContentCategory = [];

  Future getUserData() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userNumber)
        .get()
        .then(
      (value) {
        setState(
          () {
            if (value.get('address') != "") {
              profileCompletionPercentage = 10;
            }
            if (value.get('date_of_brith') != "") {
              profileCompletionPercentage = profileCompletionPercentage + 10;
            }
            if (value.get('description') != "") {
              profileCompletionPercentage = profileCompletionPercentage + 10;
            }
            if (value.get('email') != "") {
              profileCompletionPercentage = profileCompletionPercentage + 10;
            }
            if (value.get('gender') != "") {
              profileCompletionPercentage = profileCompletionPercentage + 10;
            }
            if (value.get('instagram_username') != "") {
              profileCompletionPercentage = profileCompletionPercentage + 10;
            }
            if (value.get('language') != "") {
              profileCompletionPercentage = profileCompletionPercentage + 10;
            }
            if (value.get('name') != "") {
              profileCompletionPercentage = profileCompletionPercentage + 10;
            }
            if (value.get('phone_number') != "") {
              profileCompletionPercentage = profileCompletionPercentage + 10;
            }
            if (value.get('profile_pic') != "") {
              profileCompletionPercentage = profileCompletionPercentage + 10;
            }
            if (value.get('instagram_followers') != null ||
                value.get('instagram_followers') != "") {
              try {
                userFollowers = int.parse(value.get('instagram_followers'));
              } catch (e) {
                print("Invalid number: $e");
              }
            }
            userContentLanguage = value
                .get('language')
                .toString()
                .split(',')
                .map((e) => e.trim())
                .toList();
            userContentCategory = value
                .get('categories')
                .toString()
                .split(',')
                .map((e) => e.trim())
                .toList();
          },
        );
      },
    );
  }

  Future getCollabData() async {
    getUserData();
    FirebaseFirestore.instance
        .collection('collaboration')
        .doc(widget.collabId)
        .get()
        .then(
      (value) {
        title = value.get('titles');
        description = value.get('descreption');
        image = value.get('image');
        brandLogo = value.get('brand_logo');
        applicationStatus = value.get('status');
        collabType = value.get('collaboration_type');
        try {
          followersFrom = int.parse(value.get('required_followers_from'));
        } catch (e) {
          print("Invalid number: $e");
        }
        try {
          followersTo = int.parse(value.get('required_followers_to'));
        } catch (e) {
          print("Invalid number: $e");
        }
        categories = value.get('categories');
        categoriesList = categories.split(',').map((e) => e.trim()).toList();
        contentLanguage = value.get('language');
        contentLanguageList =
            contentLanguage.split(',').map((e) => e.trim()).toList();
      },
    );
  }

  @override
  void initState() {
    getCollabData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black.withOpacity(0.6),
        ),
        backgroundColor: whiteColor,
        title: Text(
          title,
          style: TextStyle(
            fontSize: maxSize,
            color: Colors.black.withOpacity(0.6),
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
                    image,
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
                        color:
                            applicationStatus == "1" ? primeColor2 : primeColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        applicationStatus == "1"
                            ? 'Applications Open'
                            : 'Application Closed',
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
                            "$followersFrom to ",
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "$followersTo followers",
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      MaterialButton(
                        padding: EdgeInsets.zero,
                        height: 0,
                        minWidth: 0,
                        onPressed: () {
                          DeepLinkService.instance!.buildDynamicLinks(
                            url,
                            title,
                            widget.userNumber,
                          );
                        },
                        child: FaIcon(
                          FontAwesomeIcons.shareNodes,
                          color: purpleColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    description,
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
                              "$followersFrom to $followersTo followers",
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        userFollowers >= followersFrom
                            ? Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: primeColor2,
                                ),
                                child: Icon(
                                  Icons.check,
                                  color: whiteColor,
                                  size: 11,
                                ),
                              )
                            : Container(
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
                                FontAwesomeIcons.person,
                                color: Colors.black.withOpacity(0.4),
                                size: 17,
                              ),
                            ),
                            Text(
                              categories,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        userContentCategory.any(
                                (element) => categoriesList.contains(element))
                            ? Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: primeColor2,
                                ),
                                child: Icon(
                                  Icons.check,
                                  color: whiteColor,
                                  size: 11,
                                ),
                              )
                            : Container(
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
                              contentLanguage,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        userContentLanguage.any((element) =>
                                contentLanguageList.contains(element))
                            ? Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: primeColor2,
                                ),
                                child: Icon(
                                  Icons.check,
                                  color: whiteColor,
                                  size: 11,
                                ),
                              )
                            : Container(
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
                  Container(
                    width: displayWidth(context),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 2,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: purpleColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        paymentTypeWidget(
                          FontAwesomeIcons.box,
                          'Barter\nCollaboration',
                          collabType == "Barter"
                              ? primeColor2
                              : whiteColor.withOpacity(0.6),
                          collabType == "Barter"
                              ? whiteColor
                              : whiteColor.withOpacity(0.6),
                        ),
                        Container(
                          width: 2,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: whiteColor.withOpacity(0.4),
                          ),
                        ),
                        paymentTypeWidget(
                          Icons.currency_rupee_rounded,
                          'Paid\nCollaboration',
                          collabType == "Paid"
                              ? primeColor2
                              : whiteColor.withOpacity(0.6),
                          collabType == "Paid"
                              ? whiteColor
                              : whiteColor.withOpacity(0.6),
                        ),
                        Container(
                          width: 2,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: whiteColor.withOpacity(0.4),
                          ),
                        ),
                        paymentTypeWidget(
                          FontAwesomeIcons.bolt,
                          'Instant\nPayout',
                          collabType == "Instant Payout"
                              ? primeColor2
                              : whiteColor.withOpacity(0.6),
                          collabType == "Instant Payout"
                              ? whiteColor
                              : whiteColor.withOpacity(0.6),
                        ),
                      ],
                    ),
                  ),
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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: whiteColor,
          boxShadow: [
            BoxShadow(
              color: primeColor.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        height: 80,
        child: Center(
          child: applicationStatus == "0"
              ? Text(
                  'Application Closed !!!',
                  style: TextStyle(
                    color: primeColor,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : !userContentLanguage.any(
                          (element) => contentLanguageList.contains(element)) ||
                      !userContentCategory
                          .any((element) => categoriesList.contains(element)) ||
                      userFollowers < followersFrom
                  ? Text(
                      "You profile doesn't meet the application criteria",
                      style: TextStyle(
                        color: primeColor,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : profileCompletionPercentage == 100
                      ? MaterialButton(
                          minWidth: displayWidth(context) / 1.5,
                          color: purpleColor,
                          padding: const EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ViewBriefScreen(
                                userNumber: widget.userNumber,
                              ),
                            ),
                          ),
                          child: const Text(
                            'Apply Now',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : profileCompletionPercentage < 10
                          ? CircularProgressIndicator(
                              color: primeColor2,
                              strokeWidth: 5,
                            )
                          : MaterialButton(
                              minWidth: displayWidth(context) / 1.5,
                              color: primeColor,
                              padding: const EdgeInsets.all(10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProfileEditScreen(
                                    userNumber: widget.userNumber,
                                  ),
                                ),
                              ),
                              child: const Text(
                                'Complete your profile to continue',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
        ),
      ),
    );
  }

  paymentTypeWidget(icon, heading, iconColor, headingColor) {
    return SizedBox(
      width: displayWidth(context) / 3.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(
            icon,
            color: iconColor,
          ),
          const SizedBox(height: 5),
          Text(
            heading,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
              fontSize: 11,
              color: headingColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
