// ignore_for_file: avoid_print, invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:primewayskills_app/controllers/deepLink.dart';
import 'package:primewayskills_app/view/appbar_screens/profile_edit_screen.dart';
import 'package:primewayskills_app/view/collab_apply_screens/task_completion_screen.dart';
import 'package:primewayskills_app/view/collab_apply_screens/view_brief_screen.dart';
import 'package:primewayskills_app/view/dashboard/dashboard.dart';
import 'package:primewayskills_app/view/helpers/colors.dart';
import 'package:primewayskills_app/view/helpers/helping_widgets.dart';
import 'package:primewayskills_app/view/helpers/responsive_size_helper.dart';
import 'package:shimmer/shimmer.dart';

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
  bool viewBrief = false;
  bool taskCompleted = false;
  bool taskVerified = false;

  // collab values
  String title = '';
  String image = '';
  String brandLogo = '';
  String followersFrom = '';
  String followersTo = '';
  String description = '';
  String contentLanguage = '';
  String requirementType = '';
  List contentLanguageList = [];
  String categories = '';
  List categoriesList = [];
  String applicationStatus = '';
  String collabType = '';
  String campainDuration = '';

  // user values
  String userName = '';
  String userProfilePic = '';
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
            userName = value.get('name');
            userProfilePic = value.get('profile_pic');
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
                .toUpperCase()
                .split(',')
                .map((e) => e.trim())
                .toList();
            userContentCategory = value
                .get('categories')
                .toString()
                .toUpperCase()
                .split(',')
                .map((e) => e.trim())
                .toList();
          },
        );
      },
    );
  }

  Future applyCollab() async {
    String formatedTime = DateFormat.jm().format(DateTime.now());
    String formatedDate =
        "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";
    log('formatted date is $formatedDate $formatedTime');
    FirebaseFirestore.instance
        .collection('collaboration')
        .doc(widget.collabId)
        .collection('users')
        .doc(widget.userNumber)
        .set(
      {
        'name': userName,
        'number': widget.userNumber,
        'date_time': '$formatedDate $formatedTime',
        'profile_pic': userProfilePic,
        'view_brief': 'true',
        'task_uploaded': 'false',
        'task_verified': 'false',
      },
    ).whenComplete(
      () {
        FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userNumber)
            .collection('myCollabs')
            .doc(widget.collabId)
            .set(
          {
            'titles': title,
            'date_time': '$formatedDate $formatedTime',
            'image': image,
            'brand_logo': brandLogo,
            'status': '1',
            'required_followers_from': followersFrom,
            'required_followers_to': followersTo,
            'requirement_type': requirementType,
            'collaboration_type': collabType,
          },
        ).whenComplete(getTasksData);
      },
    );
  }

  Future getTasksData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("collaboration")
        .doc(widget.collabId)
        .collection('deliverables')
        .get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var a = querySnapshot.docs[i];
      log('task data is $a');
      FirebaseFirestore.instance
          .collection('collaboration')
          .doc(widget.collabId)
          .collection('users')
          .doc(widget.userNumber)
          .collection('tasks')
          .doc(a.id)
          .set(
        {
          'task': '',
          'title': a['title'],
          'status': 'pending',
          'task_url': '',
          'task_text': '',
        },
      ).whenComplete(
        () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewBriefScreen(
              userNumber: widget.userNumber,
              collabId: widget.collabId,
            ),
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Dashboard(),
          ),
        );
        return false;
      },
      child: Scaffold(
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
          leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Dashboard(),
                ),
              );
            },
            icon: const Icon(
              Icons.arrow_back_rounded,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('collaboration')
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              if (streamSnapshot.hasData) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: streamSnapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot documentSnapshot =
                        streamSnapshot.data!.docs[index];
                    if (documentSnapshot.id == widget.collabId) {
                      title = documentSnapshot['titles'];
                      followersFrom =
                          documentSnapshot['required_followers_from'];
                      followersTo = documentSnapshot['required_followers_to'];
                      image = documentSnapshot['image'];
                      brandLogo = documentSnapshot['brand_logo'];
                      requirementType = documentSnapshot['requirement_type'];
                      collabType = documentSnapshot['collaboration_type'];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: height / 4,
                            width: width,
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                  child: FastCachedImage(
                                    width: width,
                                    url: documentSnapshot['image'],
                                    fit: BoxFit.cover,
                                    loadingBuilder: (context, progress) {
                                      return Shimmer.fromColors(
                                        baseColor: Colors.grey.shade200,
                                        highlightColor: Colors.grey.shade300,
                                        direction: ShimmerDirection.ttb,
                                        child: Container(
                                          height: 160,
                                          width: width,
                                          decoration: BoxDecoration(
                                            color: primeColor2,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color:
                                              documentSnapshot['status'] == "1"
                                                  ? primeColor2
                                                  : primeColor,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          documentSnapshot['status'] == "1"
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
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        FaIcon(
                                          documentSnapshot[
                                                      'requirement_type'] ==
                                                  "insta"
                                              ? FontAwesomeIcons.instagram
                                              : FontAwesomeIcons.youtube,
                                          color: primeColor,
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          documentSnapshot[
                                                      'requirement_type'] ==
                                                  "insta"
                                              ? "${documentSnapshot['required_followers_from']} to ${documentSnapshot['required_followers_to']} followers"
                                              : "${documentSnapshot['required_followers_from']} to ${documentSnapshot['required_followers_to']} subscribers",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.2,
                                          ),
                                        ),
                                      ],
                                    ),
                                    MaterialButton(
                                      padding: EdgeInsets.zero,
                                      height: 0,
                                      minWidth: 0,
                                      onPressed: () {
                                        DeepLinkService.instance!
                                            .buildDynamicLinks(
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
                                const SizedBox(height: 10),
                                headingWidgetMethod(documentSnapshot['titles']),
                                const SizedBox(height: 20),
                                Text(
                                  documentSnapshot['descreption'],
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.4),
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                                const SizedBox(height: 30),
                                StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection('collaboration')
                                      .doc(widget.collabId)
                                      .collection('users')
                                      .where('number',
                                          isEqualTo: widget.userNumber)
                                      .snapshots(),
                                  builder: (context,
                                      AsyncSnapshot<QuerySnapshot>
                                          streamSnapshot) {
                                    if (streamSnapshot.hasData) {
                                      if (streamSnapshot
                                          .data!.docs.isNotEmpty) {
                                        log('stream data is ${streamSnapshot.data!.docs.length}');
                                        return ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount:
                                              streamSnapshot.data!.docs.length,
                                          itemBuilder: (context, index) {
                                            DocumentSnapshot documentSnapshot1 =
                                                streamSnapshot
                                                    .data!.docs[index];
                                            if (documentSnapshot1[
                                                    'view_brief'] ==
                                                "true") {
                                              viewBrief = true;
                                            }
                                            if (documentSnapshot1[
                                                    'task_uploaded'] ==
                                                "true") {
                                              taskCompleted = true;
                                            }
                                            if (documentSnapshot1[
                                                    'task_verified'] ==
                                                "true") {
                                              taskVerified = true;
                                            }
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                headingWidgetMethod(
                                                    'Steps For Completion'),
                                                const SizedBox(height: 20),
                                                collabTextWidget(
                                                  'Collaboration Duration',
                                                  documentSnapshot['duration'],
                                                ),
                                                const SizedBox(height: 10),
                                                collabTextWidget(
                                                  'Note',
                                                  'Please read full description very carefully for schedules and task completions steps.',
                                                ),
                                                const SizedBox(height: 20),
                                                Container(
                                                  width: displayWidth(context),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 2,
                                                    vertical: 10,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: purpleColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      InkWell(
                                                        onTap: () =>
                                                            Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                ViewBriefScreen(
                                                              userNumber: widget
                                                                  .userNumber,
                                                              collabId: widget
                                                                  .collabId,
                                                            ),
                                                          ),
                                                        ),
                                                        child:
                                                            paymentTypeWidget(
                                                          FontAwesomeIcons
                                                              .checkDouble,
                                                          'Tasks\nViewed',
                                                          documentSnapshot1[
                                                                      'view_brief'] ==
                                                                  "true"
                                                              ? primeColor2
                                                              : whiteColor
                                                                  .withOpacity(
                                                                      0.6),
                                                          documentSnapshot1[
                                                                      'view_brief'] ==
                                                                  "true"
                                                              ? whiteColor
                                                              : whiteColor
                                                                  .withOpacity(
                                                                      0.6),
                                                        ),
                                                      ),
                                                      Container(
                                                        width: 2,
                                                        height: 50,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color: whiteColor
                                                              .withOpacity(0.4),
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () =>
                                                            Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                TaskCompletionScreen(
                                                              userNumber: widget
                                                                  .userNumber,
                                                              collabId: widget
                                                                  .collabId,
                                                            ),
                                                          ),
                                                        ),
                                                        child:
                                                            paymentTypeWidget(
                                                          FontAwesomeIcons
                                                              .checkDouble,
                                                          'Tasks\nCompleted',
                                                          documentSnapshot1[
                                                                      'task_uploaded'] ==
                                                                  "true"
                                                              ? primeColor2
                                                              : whiteColor
                                                                  .withOpacity(
                                                                      0.6),
                                                          documentSnapshot1[
                                                                      'task_uploaded'] ==
                                                                  "true"
                                                              ? whiteColor
                                                              : whiteColor
                                                                  .withOpacity(
                                                                      0.6),
                                                        ),
                                                      ),
                                                      Container(
                                                        width: 2,
                                                        height: 50,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color: whiteColor
                                                              .withOpacity(0.4),
                                                        ),
                                                      ),
                                                      paymentTypeWidget(
                                                        documentSnapshot1[
                                                                    'task_verified'] ==
                                                                "rejected"
                                                            ? FontAwesomeIcons
                                                                .xmark
                                                            : FontAwesomeIcons
                                                                .checkDouble,
                                                        'Tasks\nVerified',
                                                        documentSnapshot1[
                                                                    'task_verified'] ==
                                                                "true"
                                                            ? primeColor2
                                                            : documentSnapshot1[
                                                                        'task_verified'] ==
                                                                    "rejected"
                                                                ? primeColor
                                                                : whiteColor
                                                                    .withOpacity(
                                                                        0.6),
                                                        documentSnapshot1[
                                                                    'task_verified'] ==
                                                                "true"
                                                            ? whiteColor
                                                            : whiteColor
                                                                .withOpacity(
                                                                    0.6),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      } else {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            headingWidgetMethod(
                                                'Application Criteria'),
                                            const SizedBox(height: 20),
                                            Container(
                                              width: width,
                                              padding: const EdgeInsets.all(14),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.black
                                                      .withOpacity(0.2),
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      FaIcon(
                                                        FontAwesomeIcons
                                                            .peopleGroup,
                                                        color: Colors.black
                                                            .withOpacity(0.4),
                                                        size: 17,
                                                      ),
                                                      const SizedBox(width: 20),
                                                      Text(
                                                        documentSnapshot[
                                                                    'requirement_type'] ==
                                                                "insta"
                                                            ? "${documentSnapshot['required_followers_from']} to ${documentSnapshot['required_followers_to']} followers"
                                                            : "${documentSnapshot['required_followers_from']} to ${documentSnapshot['required_followers_to']} subscribers",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          letterSpacing: 0.2,
                                                          color: Colors.black
                                                              .withOpacity(0.6),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  userFollowers >=
                                                          int.parse(
                                                              documentSnapshot[
                                                                  'required_followers_from'])
                                                      ? Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(3),
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color: primeColor2,
                                                          ),
                                                          child: Icon(
                                                            Icons.check,
                                                            color: whiteColor,
                                                            size: 11,
                                                          ),
                                                        )
                                                      : Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(3),
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
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
                                                  color: Colors.black
                                                      .withOpacity(0.2),
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 35,
                                                        child: FaIcon(
                                                          FontAwesomeIcons
                                                              .person,
                                                          color: Colors.black
                                                              .withOpacity(0.4),
                                                          size: 17,
                                                        ),
                                                      ),
                                                      Text(
                                                        documentSnapshot[
                                                            'categories'],
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          letterSpacing: 0.2,
                                                          color: Colors.black
                                                              .withOpacity(0.6),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  userContentCategory.any(
                                                    (element) =>
                                                        documentSnapshot[
                                                                'categories']
                                                            .toString()
                                                            .toUpperCase()
                                                            .split(',')
                                                            .map(
                                                                (e) => e.trim())
                                                            .toList()
                                                            .contains(element),
                                                  )
                                                      ? Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(3),
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color: primeColor2,
                                                          ),
                                                          child: Icon(
                                                            Icons.check,
                                                            color: whiteColor,
                                                            size: 11,
                                                          ),
                                                        )
                                                      : Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(3),
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
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
                                                  color: Colors.black
                                                      .withOpacity(0.2),
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 35,
                                                        child: FaIcon(
                                                          FontAwesomeIcons
                                                              .language,
                                                          color: Colors.black
                                                              .withOpacity(0.4),
                                                          size: 17,
                                                        ),
                                                      ),
                                                      Text(
                                                        documentSnapshot[
                                                            'language'],
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          letterSpacing: 0.2,
                                                          color: Colors.black
                                                              .withOpacity(0.6),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  userContentLanguage.any(
                                                    (element) =>
                                                        documentSnapshot[
                                                                'language']
                                                            .toString()
                                                            .toUpperCase()
                                                            .split(',')
                                                            .map(
                                                                (e) => e.trim())
                                                            .toList()
                                                            .contains(element),
                                                  )
                                                      ? Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(3),
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color: primeColor2,
                                                          ),
                                                          child: Icon(
                                                            Icons.check,
                                                            color: whiteColor,
                                                            size: 11,
                                                          ),
                                                        )
                                                      : Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(3),
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 2,
                                                vertical: 10,
                                              ),
                                              decoration: BoxDecoration(
                                                color: purpleColor,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  paymentTypeWidget(
                                                    FontAwesomeIcons.box,
                                                    'Barter\nCollaboration',
                                                    documentSnapshot[
                                                                    'collaboration_type']
                                                                .toString()
                                                                .toUpperCase() ==
                                                            "BARTER"
                                                        ? primeColor2
                                                        : whiteColor
                                                            .withOpacity(0.6),
                                                    documentSnapshot[
                                                                    'collaboration_type']
                                                                .toString()
                                                                .toUpperCase() ==
                                                            "BARTER"
                                                        ? whiteColor
                                                        : whiteColor
                                                            .withOpacity(0.6),
                                                  ),
                                                  Container(
                                                    width: 2,
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: whiteColor
                                                          .withOpacity(0.4),
                                                    ),
                                                  ),
                                                  paymentTypeWidget(
                                                    Icons
                                                        .currency_rupee_rounded,
                                                    'Paid\nCollaboration',
                                                    documentSnapshot[
                                                                    'collaboration_type']
                                                                .toString()
                                                                .toUpperCase() ==
                                                            "PAID"
                                                        ? primeColor2
                                                        : whiteColor
                                                            .withOpacity(0.6),
                                                    documentSnapshot[
                                                                    'collaboration_type']
                                                                .toString()
                                                                .toUpperCase() ==
                                                            "PAID"
                                                        ? whiteColor
                                                        : whiteColor
                                                            .withOpacity(0.6),
                                                  ),
                                                  Container(
                                                    width: 2,
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: whiteColor
                                                          .withOpacity(0.4),
                                                    ),
                                                  ),
                                                  paymentTypeWidget(
                                                    FontAwesomeIcons.bolt,
                                                    'Instant\nPayout',
                                                    documentSnapshot[
                                                                    'collaboration_type']
                                                                .toString()
                                                                .toUpperCase() ==
                                                            "INSTANT PAYOUT"
                                                        ? primeColor2
                                                        : whiteColor
                                                            .withOpacity(0.6),
                                                    documentSnapshot[
                                                                    'collaboration_type']
                                                                .toString()
                                                                .toUpperCase() ==
                                                            "INSTANT PAYOUT"
                                                        ? whiteColor
                                                        : whiteColor
                                                            .withOpacity(0.6),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                    }
                                    return Container();
                                  },
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
                      );
                    }
                    return Container();
                  },
                );
              }
              return Shimmer.fromColors(
                baseColor: Colors.grey.shade200,
                highlightColor: Colors.grey.shade300,
                direction: ShimmerDirection.ttb,
                child: Container(
                  height: 160,
                  width: width,
                  decoration: BoxDecoration(
                    color: primeColor2,
                  ),
                ),
              );
            },
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
          height: 65,
          child: taskVerified
              ? Center(
                  child: Text(
                    'Task verified. Please wait for disbursal!!!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      color: primeColor2,
                    ),
                  ),
                )
              : taskCompleted
                  ? Center(
                      child: Text(
                        'Please wait for task verification!!!',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          color: primeColor2,
                        ),
                      ),
                    )
                  : viewBrief
                      ? Center(
                          child: MaterialButton(
                            minWidth: displayWidth(context) / 1.5,
                            color: purpleColor,
                            padding: const EdgeInsets.all(10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TaskCompletionScreen(
                                  userNumber: widget.userNumber,
                                  collabId: widget.collabId,
                                ),
                              ),
                            ),
                            child: const Text(
                              'Complete Task',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      : StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('collaboration')
                              .snapshots(),
                          builder: (context,
                              AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                            if (streamSnapshot.hasData) {
                              return ListView.builder(
                                itemCount: streamSnapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot documentSnapshot =
                                      streamSnapshot.data!.docs[index];
                                  if (documentSnapshot.id == widget.collabId) {
                                    return Center(
                                      child: documentSnapshot['status'] == "0"
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 20),
                                              child: Text(
                                                'Application Closed !!!',
                                                style: TextStyle(
                                                  color: primeColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            )
                                          : !userContentLanguage.any((element) =>
                                                      documentSnapshot['language']
                                                          .toString()
                                                          .toUpperCase()
                                                          .split(',')
                                                          .map((e) => e.trim())
                                                          .toList()
                                                          .contains(element)) ||
                                                  !userContentCategory.any(
                                                      (element) => documentSnapshot[
                                                              'categories']
                                                          .toString()
                                                          .toUpperCase()
                                                          .split(',')
                                                          .map((e) => e.trim())
                                                          .toList()
                                                          .contains(element)) ||
                                                  userFollowers <
                                                      int.parse(documentSnapshot[
                                                          'required_followers_from'])
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 20),
                                                  child: Text(
                                                    "You profile doesn't meet the application criteria",
                                                    style: TextStyle(
                                                      color: primeColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                )
                                              : profileCompletionPercentage ==
                                                      100
                                                  ? MaterialButton(
                                                      minWidth: displayWidth(
                                                              context) /
                                                          1.5,
                                                      color: purpleColor,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      onPressed: applyCollab,
                                                      child: const Text(
                                                        'Apply Now',
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    )
                                                  : profileCompletionPercentage <
                                                          10
                                                      ? CircularProgressIndicator(
                                                          color: primeColor2,
                                                          strokeWidth: 5,
                                                        )
                                                      : MaterialButton(
                                                          minWidth:
                                                              displayWidth(
                                                                      context) /
                                                                  1.5,
                                                          color: primeColor,
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                          onPressed: () =>
                                                              Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ProfileEditScreen(
                                                                userNumber: widget
                                                                    .userNumber,
                                                              ),
                                                            ),
                                                          ),
                                                          child: const Text(
                                                            'Complete your profile to continue',
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                    );
                                  }
                                  return Container();
                                },
                              );
                            }
                            return Container();
                          },
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

  collabTextWidget(head, subhead) {
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
