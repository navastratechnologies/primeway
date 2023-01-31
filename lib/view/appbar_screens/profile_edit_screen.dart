import 'dart:core';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:primewayskills_app/view/auth_screens/address.dart';
import 'package:primewayskills_app/view/auth_screens/commercial_page.dart';
import 'package:primewayskills_app/view/auth_screens/edit_details.dart';
import 'package:primewayskills_app/view/auth_screens/kyc.dart';
import 'package:primewayskills_app/view/dashboard/dashboard.dart';
import 'package:primewayskills_app/view/dashboard/social_account.dart';
import 'package:primewayskills_app/view/helpers/colors.dart';
import 'package:primewayskills_app/view/helpers/helping_widgets.dart';
import 'package:primewayskills_app/view/helpers/responsive_size_helper.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

class ProfileEditScreen extends StatefulWidget {
  final String userNumber;

  const ProfileEditScreen({
    Key? key,
    required this.userNumber,
  }) : super(key: key);

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final firebaseInstance = FirebaseFirestore.instance;

  String username = '';
  String userEmail = '';
  String userAddress = '';
  String youtubeId = '';
  String instaId = '';
  String idProof = '';
  String accountNumber = '';
  String accountName = '';
  String accountHolderName = '';
  String accountIFSC = '';
  String accountType = '';
  String instaImagePrice = '';
  String instaVideoPrice = '';
  String instaStoryPrice = '';
  String instaReelsPrice = '';
  String instaCarouselPrice = '';
  String youtubeVideoPrice = '';
  String youtubeShortsPrice = '';
  String dob = '';
  String description = '';
  String language = '';
  String gender = '';
  String secondaryNumber = '';
  String userProfileImage = '';
  String category = '';
  int profileCompletionPercentage = 0;

  Future<void> getUserProfileData() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userNumber)
        .get()
        .then(
      (value) {
        setState(() {
          userProfileImage = value.get('profile_pic');
          username = value.get('name');
          userEmail = value.get('email');
          userAddress = value.get('address');
          youtubeId = value.get('youtube_username');
          instaId = value.get('instagram_username');
          accountNumber = value.get('account_number');
          accountHolderName = value.get('account_holder_name');
          accountType = value.get('account_type');
          accountName = value.get('bank_name');
          accountIFSC = value.get('ifsc');
          idProof = value.get('front_document');
          instaImagePrice = value.get('insta_image_price');
          instaVideoPrice = value.get('insta_video_price');
          instaCarouselPrice = value.get('insta_carousel_price');
          instaStoryPrice = value.get('insta_story_price');
          instaReelsPrice = value.get('insta_reels_price');
          youtubeVideoPrice = value.get('youtube_video_price');
          youtubeShortsPrice = value.get('youtube_short_price');
          dob = value.get('date_of_brith');
          language = value.get('language');
          category = value.get('categories');
          description = value.get('description');
          gender = value.get('gender');
          secondaryNumber = value.get('secondry_phone_number');
          log('edit name is $accountNumber $idProof');
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
        });
      },
    );
  }

  @override
  void initState() {
    getUserProfileData();
    super.initState();
  }

  Future<bool> _onWillPop() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Dashboard(),
      ),
    );
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.black.withOpacity(0.6),
          ),
          leading: IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Dashboard(),
              ),
            ),
            icon: const Icon(
              Icons.arrow_back,
            ),
          ),
          backgroundColor: whiteColor,
          title: Text(
            'Profile',
            style: TextStyle(
              fontSize: maxSize,
              color: Colors.black.withOpacity(0.6),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 30,
                bottom: 80,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  userProfileImage.isNotEmpty
                      ? Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: whiteColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: primeColor.withOpacity(0.1),
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ],
                            image: DecorationImage(
                              image: NetworkImage(
                                userProfileImage,
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : InkWell(
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: whiteColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: primeColor.withOpacity(0.4),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: primeColor.withOpacity(0.1),
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                username.length > 1
                                    ? username.substring(0, 1)
                                    : username,
                                style: TextStyle(
                                  fontSize: maxSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome, ",
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.4),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        username,
                        style: TextStyle(
                          fontSize: maxSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "Your profile completion process",
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.4),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Container(
                            height: 6,
                            width: double.parse(
                                    profileCompletionPercentage.toString()) *
                                1.8,
                            decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Stack(
                              children: [
                                Container(
                                  height: 6,
                                  width: double.parse(
                                          profileCompletionPercentage
                                              .toString()) *
                                      1.8,
                                  decoration: BoxDecoration(
                                    color: primeColor2,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            "$profileCompletionPercentage%",
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.5),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: displayHeight(context) / 1.45,
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditDetailsPage(
                                phoneNumber: widget.userNumber,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: whiteColor,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  userEmail.isNotEmpty &&
                                          username.isNotEmpty &&
                                          gender.isNotEmpty &&
                                          description.isNotEmpty &&
                                          language.isNotEmpty
                                      ? Container()
                                      : Text(
                                          'INCOMPLETE',
                                          style: TextStyle(
                                            color: primeColor,
                                            fontSize: 10,
                                            letterSpacing: 1,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                  Text(
                                    'EDIT',
                                    style: TextStyle(
                                      color: primeColor,
                                      fontSize: 12,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              headingWidgetMethod('About you'),
                              const SizedBox(height: 10),
                              ResponsiveGridList(
                                listViewBuilderOptions: ListViewBuilderOptions(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                ),
                                minItemWidth: 100,
                                children: [
                                  profileEditInternalWidget('Email', userEmail),
                                  profileEditInternalWidget(
                                      'Primary Number', widget.userNumber),
                                  profileEditInternalWidget('Gender', gender),
                                  profileEditInternalWidget(
                                      'Content Language', language),
                                  profileEditInternalWidget(
                                      'Date of Birth', dob),
                                  profileEditInternalWidget(
                                      'Secondary Number', secondaryNumber),
                                  profileEditInternalWidget(
                                      'Content Category', category),
                                  profileEditInternalWidget(
                                      'Description (Bio)', description),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SocialScreen(
                              userNumber: widget.userNumber,
                              userName: username,
                              userProfileImage: userProfileImage,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 30,
                          ),
                          decoration: BoxDecoration(
                            color: whiteColor,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    youtubeId.isNotEmpty || instaId.isNotEmpty
                                        ? MainAxisAlignment.end
                                        : MainAxisAlignment.spaceBetween,
                                children: [
                                  youtubeId.isNotEmpty || instaId.isNotEmpty
                                      ? Container()
                                      : Text(
                                          'INCOMPLETE',
                                          style: TextStyle(
                                            color: primeColor,
                                            fontSize: 10,
                                            letterSpacing: 1,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                  Text(
                                    'EDIT',
                                    style: TextStyle(
                                      color: primeColor,
                                      fontSize: 12,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              headingWidgetMethod('Social Accounts'),
                              const SizedBox(height: 20),
                              youtubeId.isEmpty
                                  ? Container()
                                  : const SizedBox(height: 20),
                              youtubeId.isEmpty
                                  ? Container()
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              FontAwesomeIcons.youtube,
                                              color: primeColor,
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              youtubeId,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                letterSpacing: 1,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        MaterialButton(
                                          color: purpleColor,
                                          onPressed: () {
                                            FirebaseFirestore.instance
                                                .collection("users")
                                                .doc(widget.userNumber)
                                                .update(
                                              {
                                                "youtube_username": "",
                                                "youtube_subscribers": "",
                                              },
                                            );
                                            getUserProfileData();
                                          },
                                          child: Text(
                                            "Remove",
                                            style: TextStyle(
                                              color: whiteColor,
                                              fontSize: 12,
                                              letterSpacing: 1,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                              instaId.isEmpty
                                  ? Container()
                                  : const SizedBox(height: 20),
                              instaId.isEmpty
                                  ? Container()
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                              FontAwesomeIcons.instagram,
                                              color: Colors.pink,
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              instaId,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                letterSpacing: 1,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        MaterialButton(
                                          color: purpleColor,
                                          onPressed: () {
                                            FirebaseFirestore.instance
                                                .collection("users")
                                                .doc(widget.userNumber)
                                                .update(
                                              {
                                                "instagram_username": "",
                                                "instagram_followers": "",
                                              },
                                            );
                                            getUserProfileData();
                                          },
                                          child: Text(
                                            "Remove",
                                            style: TextStyle(
                                              color: whiteColor,
                                              fontSize: 12,
                                              letterSpacing: 1,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CommercialPricingPage(
                              userNumber: widget.userNumber,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: whiteColor,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  instaCarouselPrice != "0" &&
                                          instaImagePrice != "0" &&
                                          instaReelsPrice != "0" &&
                                          instaStoryPrice != "0" &&
                                          instaVideoPrice != "0" &&
                                          youtubeShortsPrice != "0" &&
                                          youtubeVideoPrice != "0"
                                      ? Container()
                                      : Text(
                                          'INCOMPLETE',
                                          style: TextStyle(
                                            color: primeColor,
                                            fontSize: 10,
                                            letterSpacing: 1,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                  Text(
                                    'EDIT',
                                    style: TextStyle(
                                      color: primeColor,
                                      fontSize: 12,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              headingWidgetMethod('Commercials'),
                              const SizedBox(height: 30),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: whiteColor,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: primeColor.withOpacity(0.1),
                                      blurRadius: 10,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    commercialHeadingWidget(
                                      'assets/json/instagram-icon.json',
                                      "Instagram Commercial Charges",
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        profileEditInternalWidget(
                                          'Insta Image',
                                          "$rupeeSign$instaImagePrice",
                                        ),
                                        profileEditInternalWidget(
                                          'Insta Reels',
                                          "$rupeeSign$instaReelsPrice",
                                        ),
                                        profileEditInternalWidget(
                                          'Insta Story',
                                          "$rupeeSign$instaStoryPrice",
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        profileEditInternalWidget(
                                          'Insta Video',
                                          "$rupeeSign$instaVideoPrice",
                                        ),
                                        profileEditInternalWidget(
                                          'Insta Carousel',
                                          "$rupeeSign$instaCarouselPrice",
                                        ),
                                        const SizedBox(width: 60),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: whiteColor,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: primeColor.withOpacity(0.1),
                                      blurRadius: 10,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    commercialHeadingWidget(
                                      'assets/json/youtube.json',
                                      "Youtube Commercial Charges",
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        profileEditInternalWidget(
                                          'Youtube Video',
                                          "$rupeeSign$youtubeVideoPrice",
                                        ),
                                        profileEditInternalWidget(
                                          'Youtube Shorts',
                                          "$rupeeSign$youtubeShortsPrice",
                                        ),
                                        const SizedBox(width: 60),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EkycPage(
                              phoneNumber: widget.userNumber,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: whiteColor,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: idProof.isNotEmpty &&
                                        accountNumber.isNotEmpty
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.spaceBetween,
                                children: [
                                  idProof.isNotEmpty && accountNumber.isNotEmpty
                                      ? Container()
                                      : Text(
                                          'INCOMPLETE',
                                          style: TextStyle(
                                            color: primeColor,
                                            fontSize: 10,
                                            letterSpacing: 1,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                  Text(
                                    'EDIT',
                                    style: TextStyle(
                                      color: primeColor,
                                      fontSize: 12,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              headingWidgetMethod('Payments'),
                              const SizedBox(height: 30),
                              accountName.isEmpty
                                  ? Container()
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        profileEditInternalWidget(
                                          'Bank Name',
                                          accountName,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Account Type",
                                              style: TextStyle(
                                                color: Colors.black
                                                    .withOpacity(0.4),
                                                fontSize: 12,
                                                letterSpacing: 1,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 4),
                                              decoration: BoxDecoration(
                                                color: purpleColor,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Text(
                                                accountType,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  letterSpacing: 1,
                                                  fontWeight: FontWeight.bold,
                                                  color: whiteColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                              accountName.isEmpty
                                  ? Container()
                                  : const SizedBox(height: 20),
                              accountHolderName.isEmpty
                                  ? Container()
                                  : profileEditInternalWidget(
                                      'Account Holder Name', accountHolderName),
                              accountHolderName.isEmpty
                                  ? Container()
                                  : const SizedBox(height: 20),
                              accountNumber.isEmpty
                                  ? Container()
                                  : profileEditInternalWidget(
                                      'Account Number', accountNumber),
                              accountNumber.isEmpty
                                  ? Container()
                                  : const SizedBox(height: 20),
                              accountIFSC.isEmpty
                                  ? Container()
                                  : profileEditInternalWidget(
                                      'IFSC Code', accountIFSC),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditAddressPage(
                              phoneNumber: widget.userNumber,
                              pageType: "edit",
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: whiteColor,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: userAddress.isNotEmpty
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.spaceBetween,
                                children: [
                                  userAddress.isNotEmpty
                                      ? Container()
                                      : Text(
                                          'INCOMPLETE',
                                          style: TextStyle(
                                            color: primeColor,
                                            fontSize: 10,
                                            letterSpacing: 1,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                  Text(
                                    'EDIT',
                                    style: TextStyle(
                                      color: primeColor,
                                      fontSize: 12,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              headingWidgetMethod('Address'),
                              const SizedBox(height: 30),
                              userAddress.isEmpty
                                  ? Container()
                                  : profileEditInternalWidget(
                                      'Address',
                                      userAddress,
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  profileEditInternalWidget(head, subhead) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          head,
          style: TextStyle(
            color: Colors.black.withOpacity(0.4),
            fontSize: 12,
            letterSpacing: 1,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          subhead,
          style: const TextStyle(
            fontSize: 12,
            letterSpacing: 1,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
