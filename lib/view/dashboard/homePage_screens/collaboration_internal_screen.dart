// ignore_for_file: avoid_print, invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:primewayskills_app/controllers/deepLink.dart';
import 'package:primewayskills_app/view/appbar_screens/profile_edit_screen.dart';
import 'package:primewayskills_app/view/helpers/colors.dart';
import 'package:primewayskills_app/view/helpers/helping_widgets.dart';
import 'package:primewayskills_app/view/helpers/responsive_size_helper.dart';

class CollaborationInternalScreen extends StatefulWidget {
  final String heading,
      image,
      paragraph,
      followerDetails,
      brandlogo,
      categories,
      collaborationtype,
      language,
      titles;
  final String userNumber;
  final String userName;
  final String userAddress;
  final String userProfileImage;
  final String userPayment;
  final String userEmail;
  final String userWalletId;
  final String userLanguage;
  final String userFollowers;
  const CollaborationInternalScreen({
    Key? key,
    required this.heading,
    required this.image,
    required this.paragraph,
    required this.followerDetails,
    required this.brandlogo,
    required this.categories,
    required this.language,
    required this.collaborationtype,
    required this.titles,
    required this.userNumber,
    required this.userName,
    required this.userAddress,
    required this.userProfileImage,
    required this.userPayment,
    required this.userEmail,
    required this.userWalletId,
    required this.userLanguage,
    required this.userFollowers,
  }) : super(key: key);

  @override
  State<CollaborationInternalScreen> createState() =>
      _CollaborationInternalScreenState();
}

class _CollaborationInternalScreenState
    extends State<CollaborationInternalScreen> {
  String url = 'https://primeway.page.link';

  int profileCompletionPercentage = 0;

  Future getUserDataCompletionPercentage() async {
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
          },
        );
      },
    );
  }

  @override
  void initState() {
    getUserDataCompletionPercentage();
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
          widget.titles,
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
                          DeepLinkService.instance!.buildDynamicLinks(
                            url,
                            widget.titles,
                            widget.userNumber,
                          );
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
                        widget.userFollowers == widget.followerDetails
                            ? Container(
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
                        widget.userLanguage == widget.language
                            ? Container(
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
                              )
                            : Container(
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
          child: profileCompletionPercentage == 100
              ? Container()
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
}
