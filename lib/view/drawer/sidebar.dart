// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:primewayskills_app/view/auth_screens/loginHomeScreen.dart';
import 'package:primewayskills_app/view/dashboard/dashboard.dart';
import 'package:primewayskills_app/view/drawer/about_us.dart';
import 'package:primewayskills_app/view/drawer/feedback.dart';
import 'package:primewayskills_app/view/drawer/resources/resources.dart';
import 'package:primewayskills_app/view/drawer/setting/setting.dart';
import 'package:primewayskills_app/view/helpers/colors.dart';
import 'package:primewayskills_app/view/helpers/helping_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class NavigationDrawer extends StatefulWidget {
  final String userNumber;
  final String userName;
  final String userAddress;
  final String userProfileImage;
  final String userPayment;
  final String userEmail;
  final String userWalletId;
  const NavigationDrawer(
      {Key? key,
      required this.userNumber,
      required this.userName,
      required this.userAddress,
      required this.userProfileImage,
      required this.userPayment,
      required this.userEmail,
      required this.userWalletId})
      : super(key: key);

  @override
  State<NavigationDrawer> createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  bool showPartenerPage = false;
  String docId = '';

  Future<void> checkCollection() async {
    FirebaseFirestore.instance
        .collection('affilate_dashboard')
        .doc('NkcdMPSuI3SSIpJ2uLuv')
        .collection('affiliate_users')
        .doc(widget.userNumber)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          docId = documentSnapshot.id;
          showPartenerPage = false;
        });
        log('Document id: ${documentSnapshot.id}');
      } else {
        setState(() {
          showPartenerPage = true;
        });
        log('Document does not exist on the database');
      }
    });
  }

  @override
  void initState() {
    checkCollection();
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        log('User is currently signed out!');
      } else {
        log('User is signed in!');
      }
    });
  }

  @override
  Widget build(BuildContext context) => Drawer(
        backgroundColor: primeColor,
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SafeArea(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: primeColor,
                          border: Border(
                            bottom: BorderSide(
                              color: whiteColor.withOpacity(0.6),
                              width: 2,
                            ),
                          ),
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                InkWell(
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: whiteColor,
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            widget.userProfileImage),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.userName,
                                      style: TextStyle(
                                        color: whiteColor,
                                        fontSize: maxSize,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      widget.userEmail,
                                      style: TextStyle(
                                        color: whiteColor.withOpacity(0.6),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Icon(
                              Icons.edit,
                              color: whiteColor.withOpacity(0.6),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Wrap(
                        runSpacing: 10,
                        children: [
                          ListTile(
                            leading: sidebarIconWidget(Icons.home_filled),
                            title: Text(
                              "Home",
                              style: TextStyle(
                                color: whiteColor,
                              ),
                            ),
                            onTap: () => {
                              Navigator.pop(context),
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const Dashboard(),
                                ),
                              ),
                            },
                            trailing: FaIcon(
                              FontAwesomeIcons.chevronRight,
                              color: whiteColor.withOpacity(0.6),
                              size: 16,
                            ),
                          ),
                          ListTile(
                            leading: sidebarIconWidget(Icons.tips_and_updates),
                            title: Text(
                              "Resources",
                              style: TextStyle(
                                color: whiteColor,
                              ),
                            ),
                            onTap: () => {
                              Navigator.pop(context),
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ResourcesScreen(
                                    userAddress: widget.userAddress,
                                    userEmail: widget.userEmail,
                                    userName: widget.userName,
                                    userNumber: widget.userNumber,
                                    userPayment: widget.userPayment,
                                    userProfileImage: widget.userProfileImage,
                                    userWalletId: widget.userWalletId,
                                  ),
                                ),
                              ),
                            },
                            trailing: FaIcon(
                              FontAwesomeIcons.chevronRight,
                              color: whiteColor.withOpacity(0.6),
                              size: 18,
                            ),
                          ),
                          ListTile(
                            leading: sidebarIconWidget(Icons.settings),
                            title: Text(
                              "Settings",
                              style: TextStyle(
                                color: whiteColor,
                              ),
                            ),
                            onTap: () => {
                              Navigator.pop(context),
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => SettingScreen(
                                    userAddress: widget.userAddress,
                                    userEmail: widget.userEmail,
                                    userName: widget.userName,
                                    userNumber: widget.userNumber,
                                    userPayment: widget.userPayment,
                                    userProfileImage: widget.userProfileImage,
                                    userWalletId: widget.userWalletId,
                                  ),
                                ),
                              ),
                            },
                            trailing: FaIcon(
                              FontAwesomeIcons.chevronRight,
                              color: whiteColor.withOpacity(0.6),
                              size: 18,
                            ),
                          ),
                          showPartenerPage
                              ? ListTile(
                                  leading: sidebarIconWidget(
                                      Icons.handshake_rounded),
                                  title: Text(
                                    "Become Partner",
                                    style: TextStyle(
                                      color: whiteColor,
                                    ),
                                  ),
                                  onTap: () {
                                    FirebaseFirestore.instance
                                        .collection('affilate_dashboard')
                                        .doc('NkcdMPSuI3SSIpJ2uLuv')
                                        .collection('affiliate_users')
                                        .doc(widget.userNumber)
                                        .set({
                                          'approved_affiliate': '',
                                          'complete_affiliate': '',
                                          'pending_affiliate': '',
                                          'successful_affiliate': '',
                                          'today_earning': '',
                                          'total_affiliate': '',
                                          'user_Id': widget.userNumber,
                                        })
                                        .then((value) => print("User Added"))
                                        .catchError((error) => print(
                                            "Failed to add user: $error"));
                                  },
                                  trailing: FaIcon(
                                    FontAwesomeIcons.chevronRight,
                                    color: whiteColor.withOpacity(0.6),
                                    size: 18,
                                  ),
                                )
                              : Container(),
                          ListTile(
                            leading: sidebarIconWidget(Icons.whatsapp),
                            title: Text(
                              "Chat With Us",
                              style: TextStyle(
                                color: whiteColor,
                              ),
                            ),
                            onTap: () async {
                              // var whatsapp = "+919803428694";
                              var whatsappURlAndroid =
                                  "whatsapp://send?phone=+919803428694&text=Hello";
                              var whatappURLIos =
                                  "whatsapp://send?phone=+919803428694&text=Hello";

                              if (Platform.isIOS) {
                                try {
                                  await launchUrl(Uri.parse(whatappURLIos));
                                } catch (e) {
                                  log('Error in Ios $e');
                                }
                              } else {
                                try {
                                  await launchUrl(
                                      Uri.parse(whatsappURlAndroid));
                                } catch (e) {
                                  log('Error in Androiod $e');
                                }
                              }
                            },
                            trailing: FaIcon(
                              FontAwesomeIcons.chevronRight,
                              color: whiteColor.withOpacity(0.6),
                              size: 18,
                            ),
                          ),
                          ListTile(
                            leading: sidebarIconWidget(Icons.business_rounded),
                            title: Text(
                              "About Us",
                              style: TextStyle(
                                color: whiteColor,
                              ),
                            ),
                            onTap: () => {
                              Navigator.pop(context),
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => AboutUsScreen(),
                                ),
                              ),
                            },
                            trailing: FaIcon(
                              FontAwesomeIcons.chevronRight,
                              color: whiteColor.withOpacity(0.6),
                              size: 18,
                            ),
                          ),
                          ListTile(
                            leading: sidebarIconWidget(Icons.quiz_rounded),
                            title: Text(
                              "FAQs",
                              style: TextStyle(
                                color: whiteColor,
                              ),
                            ),
                            onTap: () => {
                              Navigator.pop(context),
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => FeedbackScreen(
                                    userAddress: widget.userAddress,
                                    userEmail: widget.userEmail,
                                    userName: widget.userName,
                                    userNumber: widget.userNumber,
                                    userPayment: widget.userPayment,
                                    userProfileImage: widget.userProfileImage,
                                    userWalletId: widget.userWalletId,
                                  ),
                                ),
                              ),
                            },
                            trailing: FaIcon(
                              FontAwesomeIcons.chevronRight,
                              color: whiteColor.withOpacity(0.6),
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    ListTile(
                      leading: sidebarIconWidget(Icons.logout),
                      title: Text(
                        "Logout",
                        style: TextStyle(
                          color: whiteColor,
                        ),
                      ),
                      onTap: () async {
                        await FirebaseAuth.instance.signOut();
                        FirebaseAuth.instance
                            .authStateChanges()
                            .listen((User? user) {
                          if (user == null) {
                            log('User is currently signed out!');
                          } else {
                            log('User is signed in!');
                          }
                        });
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const LoginHomeScreen(),
                          ),
                        );
                      },
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
}
