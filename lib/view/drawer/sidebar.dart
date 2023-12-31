// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:primewayskills_app/view/appbar_screens/profile_edit_screen.dart';
import 'package:primewayskills_app/view/auth_screens/loginHomeScreen.dart';
import 'package:primewayskills_app/view/dashboard/dashboard.dart';
import 'package:primewayskills_app/view/drawer/about_us.dart';
import 'package:primewayskills_app/view/drawer/feedback.dart';
import 'package:primewayskills_app/view/drawer/resources/resources.dart';
import 'package:primewayskills_app/view/drawer/setting/setting.dart';
import 'package:primewayskills_app/view/helpers/alert_deialogs.dart';
import 'package:primewayskills_app/view/helpers/colors.dart';
import 'package:primewayskills_app/view/helpers/helping_widgets.dart';
import 'package:primewayskills_app/view/helpers/responsive_size_helper.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class NavigationsDrawer extends StatefulWidget {
  final String userNumber;
  final String userName;
  final String userAddress;
  final String userProfileImage;
  final String userPayment;
  final String userEmail;
  final String userWalletId;
  const NavigationsDrawer(
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
  State<NavigationsDrawer> createState() => _NavigationsDrawerState();
}

class _NavigationsDrawerState extends State<NavigationsDrawer> {
  FlutterSecureStorage storage = const FlutterSecureStorage();

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
              children: <Widget>[
                SafeArea(
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileEditScreen(
                              userNumber: widget.userNumber,
                            ),
                          ),
                        ),
                        child: Container(
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
                                    child: SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: FastCachedImage(
                                          url: widget.userProfileImage,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, exception, stacktrace) {
                                            log('image error is ${stacktrace.toString()}');
                                            return Text(
                                              stacktrace.toString(),
                                            );
                                          },
                                          loadingBuilder: (context, progress) {
                                            return Shimmer.fromColors(
                                              baseColor: Colors.grey.shade200,
                                              highlightColor:
                                                  Colors.grey.shade300,
                                              direction: ShimmerDirection.ttb,
                                              child: Container(
                                                width: 60,
                                                height: 60,
                                                decoration: BoxDecoration(
                                                  color: primeColor2,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        .collection('users')
                                        .doc(widget.userNumber)
                                        .collection('courses')
                                        .get()
                                        .then(
                                      (value) {
                                        if (value.docs.isEmpty) {
                                          Navigator.pop(context);
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                content: SizedBox(
                                                  height:
                                                      displayHeight(context) /
                                                          4,
                                                  child: Column(
                                                    children: [
                                                      Icon(
                                                        Icons.error_rounded,
                                                        color: primeColor,
                                                        size: 100,
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      Text(
                                                        "Please purchase any course before to become eligible for affiliate program",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black
                                                              .withOpacity(0.4),
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        } else {
                                          Navigator.pop(context);
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                title: Text(
                                                  'Become Partner',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: primeColor2,
                                                    letterSpacing: 1,
                                                  ),
                                                ),
                                                content: Container(
                                                  height: 120,
                                                  decoration: BoxDecoration(
                                                    color: whiteColor,
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        'Do you really want to become our affiliate partner and earn from our programs?',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black
                                                              .withOpacity(0.4),
                                                          fontSize: 12,
                                                          letterSpacing: 1,
                                                        ),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          MaterialButton(
                                                            color: primeColor2,
                                                            onPressed: () {
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'affilate_dashboard')
                                                                  .doc(
                                                                      'NkcdMPSuI3SSIpJ2uLuv')
                                                                  .collection(
                                                                      'affiliate_users')
                                                                  .doc(widget
                                                                      .userNumber)
                                                                  .set(
                                                                {
                                                                  'approved_affiliate':
                                                                      '0',
                                                                  'complete_affiliate':
                                                                      '0',
                                                                  'pending_affiliate':
                                                                      '0',
                                                                  'successful_affiliate':
                                                                      '0',
                                                                  'today_earning':
                                                                      '0',
                                                                  'total_affiliate':
                                                                      '0',
                                                                  'user_Id': widget
                                                                      .userNumber,
                                                                  'annualy_earning':
                                                                      '0',
                                                                  'monthly_earning':
                                                                      '0',
                                                                  'quaterly_earning':
                                                                      '0',
                                                                  'weekly_earning':
                                                                      '0',
                                                                  'courseShared':
                                                                      '0',
                                                                  'status':
                                                                      'pending',
                                                                  'totalRefferals':
                                                                      '0',
                                                                },
                                                              ).then(
                                                                (value) {
                                                                  alertDialogWidget(
                                                                    context,
                                                                    primeColor2,
                                                                    'Affiliate registration successful',
                                                                  );
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                              );
                                                            },
                                                            child: Text(
                                                              'Yes',
                                                              style: TextStyle(
                                                                color:
                                                                    whiteColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                letterSpacing:
                                                                    1,
                                                              ),
                                                            ),
                                                          ),
                                                          MaterialButton(
                                                            color: primeColor,
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    context),
                                                            child: Text(
                                                              'No',
                                                              style: TextStyle(
                                                                color:
                                                                    whiteColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                letterSpacing:
                                                                    1,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        }
                                      },
                                    );
                                  },
                                  trailing: FaIcon(
                                    FontAwesomeIcons.chevronRight,
                                    color: whiteColor.withOpacity(0.6),
                                    size: 18,
                                  ),
                                )
                              : Container(),
                          ListTile(
                            leading:
                                sidebarIconWidget(FontAwesomeIcons.whatsapp),
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
                                  builder: (context) => const AboutUsScreen(),
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
                              "Feedbacks",
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
                const SizedBox(height: 10),
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
                        storage.delete(key: 'token');
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
