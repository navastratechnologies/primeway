// ignore_for_file: unused_field, avoid_print

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:primewayskills_app/controllers/notification_controller.dart';
import 'package:primewayskills_app/controllers/phone_controller.dart';
import 'package:primewayskills_app/view/appbar_screens/notification_screen.dart';
import 'package:primewayskills_app/view/appbar_screens/profile_edit_screen.dart';
import 'package:primewayskills_app/view/auth_screens/loginHomeScreen.dart';
import 'package:primewayskills_app/view/dashboard/collaboration_screen.dart';
import 'package:primewayskills_app/view/dashboard/course_screen.dart';
import 'package:primewayskills_app/view/dashboard/home_screen.dart';
import 'package:primewayskills_app/view/dashboard/profile_screen.dart';
import 'package:primewayskills_app/view/drawer/sidebar.dart';
import 'package:primewayskills_app/view/helpers/colors.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String? mtoken = '';

  String userNumber = "";
  String userName = '';
  String userAddress = '';
  String userProfileImage = '';
  String userPayment = '';
  String userEmail = '';
  String userWalletId = '';
  String userLanguage = '';
  String userFollowers = '';

  final int _currentIndex = 0;

  bool showHome = true;
  bool showCollab = false;
  bool showProfile = false;
  bool showCourses = false;

  int profileCompletionPercentage = 0;

  Future<void> getUserProfileData() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userNumber)
        .get()
        .then((value) {
      log('user name is ${value.get('name')}');
      setState(() {
        userName = value.get('name');
        userAddress = value.get('address');
        userProfileImage = value.get('profile_pic');
        userPayment = value.get('payments');
        userEmail = value.get('email');
        userWalletId = value.get('wallet_id');
        userNumber = value.get('phone_number');
        userLanguage = value.get('language');
        userFollowers = value.get('instagram_followers');
      });
    });
  }

  Future getMsgToken() async {
    await FirebaseMessaging.instance.getToken().then((value) {
      setState(() {
        mtoken = value;
        log("getToken : $mtoken");
      });
      saveToken(value!);
    });
  }

  Future saveToken(String value) async {
    await FirebaseFirestore.instance
        .collection('user_token')
        .doc(userNumber)
        .set({
      'token': value,
    });
  }

  Future getUserDataCompletionPercentage() async {
    FirebaseFirestore.instance.collection('users').doc(userNumber).get().then(
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

  Future<void> checkUserStatus(id) async {
    try {
      // Replace 'users' with the actual collection name in Firestore
      final DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(id) // Replace with the actual user document ID
          .get();

      if (userSnapshot.exists) {
        getUserProfileData();
        getUserDataCompletionPercentage();
        log('check id $id');
      } else {
        log('check id not exist');
        setState(() {
          storage.delete(key: 'token');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginHomeScreen(),
            ),
          );
        });
      }
    } catch (e) {
      log('check Error: $e');
    }
  }

  @override
  void initState() {
    checkLogin();
    requestPermission();
    loadFCM();
    listenFCM();
    super.initState();
    getMsgToken();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        drawer: NavigationsDrawer(
          userAddress: userAddress,
          userEmail: userEmail,
          userName: userName,
          userNumber: userNumber,
          userPayment: userPayment,
          userProfileImage: userProfileImage,
          userWalletId: userWalletId,
        ),
        appBar: showProfile
            ? null
            : AppBar(
                elevation: 0,
                iconTheme: IconThemeData(
                  color: Colors.black.withOpacity(0.6),
                ),
                backgroundColor: whiteColor,
                title: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Hi, ',
                        style: TextStyle(
                          fontSize: maxSize,
                          color: Colors.black.withOpacity(0.6),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text: userName,
                        style: TextStyle(
                          fontSize: maxSize,
                          color: Colors.black.withOpacity(0.6),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  InkWell(
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: whiteColor,
                        boxShadow: [
                          BoxShadow(
                            color: primeColor.withOpacity(0.4),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.person,
                        color: Colors.black.withOpacity(0.6),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileEditScreen(
                            userNumber: userNumber,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 10),
                  InkWell(
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: whiteColor,
                        boxShadow: [
                          BoxShadow(
                            color: primeColor.withOpacity(0.4),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.notifications,
                        color: Colors.black.withOpacity(0.6),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 10),
                ],
              ),
        body: showHome
            ? Homescreen(
                userAddress: userAddress,
                userEmail: userEmail,
                userName: userName,
                userNumber: userNumber,
                userPayment: userPayment,
                userProfileImage: userProfileImage,
                userWalletId: userWalletId,
                userLanguage: userLanguage,
                userFollowers: userFollowers,
                userProfileCompletionPercentage:
                    profileCompletionPercentage.toString(),
              )
            : showCollab
                ? CollaborationScreen(
                    userNumber: userNumber,
                  )
                : showCourses
                    ? CoursesScreen(
                        userAddress: userAddress,
                        userEmail: userEmail,
                        userName: userName,
                        userNumber: userNumber,
                        userPayment: userPayment,
                        userProfileImage: userProfileImage,
                        userWalletId: userWalletId)
                    : ProfileScreen(
                        userAddress: userAddress,
                        userEmail: userEmail,
                        userName: userName,
                        userNumber: userNumber,
                        userPayment: userPayment,
                        userProfileImage: userProfileImage,
                        userWalletId: userWalletId),
        bottomNavigationBar: SizedBox(
          height: 80,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 4,
            ),
            child: Column(
              children: [
                Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: primeColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MaterialButton(
                        onPressed: () {
                          setState(() {
                            showHome = true;
                            showCollab = false;
                            showCourses = false;
                            showProfile = false;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.home_rounded,
                              color: showHome
                                  ? whiteColor.withOpacity(0.4)
                                  : whiteColor,
                              size: showHome ? 30 : 25,
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'HOME',
                              style: TextStyle(
                                color: showHome
                                    ? whiteColor.withOpacity(0.4)
                                    : whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                      MaterialButton(
                        onPressed: () {
                          setState(() {
                            showHome = false;
                            showCollab = true;
                            showCourses = false;
                            showProfile = false;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.workspaces_rounded,
                              color: showCollab
                                  ? whiteColor.withOpacity(0.4)
                                  : whiteColor,
                              size: showCollab ? 30 : 25,
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'COLLABS',
                              style: TextStyle(
                                color: showCollab
                                    ? whiteColor.withOpacity(0.4)
                                    : whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                      MaterialButton(
                        onPressed: () {
                          setState(() {
                            showHome = false;
                            showCollab = false;
                            showCourses = true;
                            showProfile = false;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.library_books_rounded,
                              color: showCourses
                                  ? whiteColor.withOpacity(0.4)
                                  : whiteColor,
                              size: showCourses ? 30 : 25,
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'LIBRARY',
                              style: TextStyle(
                                color: showCourses
                                    ? whiteColor.withOpacity(0.4)
                                    : whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                      MaterialButton(
                        onPressed: () {
                          setState(() {
                            showHome = false;
                            showCollab = false;
                            showCourses = false;
                            showProfile = true;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.person_rounded,
                              color: showProfile
                                  ? whiteColor.withOpacity(0.4)
                                  : whiteColor,
                              size: showProfile ? 30 : 25,
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'PROFILE',
                              style: TextStyle(
                                color: showProfile
                                    ? whiteColor.withOpacity(0.4)
                                    : whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  checkLogin() async {
    String? token = await getToken();
    if (token != null) {
      setState(() {
        userNumber = token;
        checkUserStatus(userNumber);
        checkAffiliateData(userNumber);
      });
    }
  }

  checkAffiliateData(userNumber) async {
    DocumentSnapshot value = await FirebaseFirestore.instance
        .collection('affilate_dashboard')
        .doc('NkcdMPSuI3SSIpJ2uLuv')
        .collection('affiliate_users')
        .doc(userNumber)
        .get();

    if (value.exists) {
      String? today = await getAffiliateTodayDate();
      String? week = await getAffiliateWeekDate();
      String? month = await getAffiliateMonthDate();
      String? quater = await getAffiliateQuaterDate();
      String? annual = await getAffiliateAnnualDate();

      if (today != null) {
        if (DateTime.now().day.toString() == today) {
          log('today date is same $today');
        } else {
          setState(() {
            storage.delete(key: 'today_date');
            storeAffiliateTodayDate(DateTime.now().day.toString());
            log('today date is not same $today');
            FirebaseFirestore.instance
                .collection('affilate_dashboard')
                .doc('NkcdMPSuI3SSIpJ2uLuv')
                .collection('affiliate_users')
                .doc(userNumber)
                .update(
              {
                'today_earning': '0.0',
              },
            );
          });
        }
      } else {
        storeAffiliateTodayDate(DateTime.now().day.toString());
      }

      if (week != null) {
        if ((DateTime.now().day / 7).ceil().toString() == week) {
          log('week is same $week');
        } else {
          setState(() {
            storage.delete(key: 'weekly_date');
            storeAffiliateWeekDate((DateTime.now().day / 7).ceil().toString());
            log('week is not same $week');
            FirebaseFirestore.instance
                .collection('affilate_dashboard')
                .doc('NkcdMPSuI3SSIpJ2uLuv')
                .collection('affiliate_users')
                .doc(userNumber)
                .update(
              {
                'weekly_earning': '0.0',
              },
            );
          });
        }
      } else {
        storeAffiliateWeekDate((DateTime.now().day / 7).ceil().toString());
      }

      if (month != null) {
        if (DateTime.now().month.toString() == month) {
          log('month is same $month');
        } else {
          setState(() {
            storage.delete(key: 'monthly_date');
            storeAffiliateMonthDate(DateTime.now().month.toString());
            log('month is not same $month');
            FirebaseFirestore.instance
                .collection('affilate_dashboard')
                .doc('NkcdMPSuI3SSIpJ2uLuv')
                .collection('affiliate_users')
                .doc(userNumber)
                .update(
              {
                'monthly_earning': '0.0',
              },
            );
          });
        }
      } else {
        storeAffiliateMonthDate(DateTime.now().month.toString());
      }

      if (quater != null) {
        if ((((DateTime.now().month - 1) / 3).ceil() + 1).toString() ==
            quater) {
          log('quater is same $quater');
        } else {
          setState(() {
            storage.delete(key: 'quaterly_date');
            storeAffiliateQuaterDate(
                (((DateTime.now().month - 1) / 3).ceil() + 1).toString());
            log('quater is not same $quater');
            FirebaseFirestore.instance
                .collection('affilate_dashboard')
                .doc('NkcdMPSuI3SSIpJ2uLuv')
                .collection('affiliate_users')
                .doc(userNumber)
                .update(
              {
                'quaterly_earning': '0.0',
              },
            );
          });
        }
      } else {
        storeAffiliateQuaterDate(
          (((DateTime.now().month - 1) / 3).ceil() + 1).toString(),
        );
      }

      if (annual != null) {
        if (DateTime.now().year.toString() == annual) {
          log('annual is same $annual');
        } else {
          setState(() {
            storage.delete(key: 'annualy_date');
            storeAffiliateAnnualDate(DateTime.now().year.toString());
            log('annual is not same $annual');
            FirebaseFirestore.instance
                .collection('affilate_dashboard')
                .doc('NkcdMPSuI3SSIpJ2uLuv')
                .collection('affiliate_users')
                .doc(userNumber)
                .update(
              {
                'annualy_earning': '0.0',
              },
            );
          });
        }
      } else {
        storeAffiliateAnnualDate(DateTime.now().year.toString());
      }
    } else {
      log('not exist in affiliate collection');
    }
  }
}
