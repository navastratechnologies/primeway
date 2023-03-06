// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:primewayskills_app/view/drawer/setting/privacypolicy.dart';
import 'package:primewayskills_app/view/drawer/setting/termofservice.dart';
import 'package:primewayskills_app/view/drawer/setting/version.dart';
import 'package:primewayskills_app/view/drawer/sidebar.dart';
import 'package:primewayskills_app/view/helpers/colors.dart';
import 'package:primewayskills_app/view/helpers/helping_widgets.dart';

class SettingScreen extends StatefulWidget {
  final String userNumber;
  final String userName;
  final String userAddress;
  final String userProfileImage;
  final String userPayment;
  final String userEmail;
  final String userWalletId;
  const SettingScreen(
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
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool isSwitched = false;
  String appVersion = '';

  Future<void> appVersions() async {
    FirebaseFirestore.instance
        .collection('app_version')
        .doc('eGrmtdJDkF7LhjMjGnsN')
        .get()
        .then((value) {
      log('app version is : ${value.get('version')}');
      setState(() {
        appVersion = value.get('version');
      });
      log('app version is : $appVersion');
    });
  }

  @override
  void initState() {
    appVersions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationsDrawer(
        userAddress: widget.userAddress,
        userEmail: widget.userEmail,
        userName: widget.userName,
        userNumber: widget.userNumber,
        userPayment: widget.userPayment,
        userProfileImage: widget.userProfileImage,
        userWalletId: widget.userWalletId,
      ),
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black.withOpacity(0.6),
        ),
        backgroundColor: whiteColor,
        title: Text(
          'Settings',
          style: TextStyle(
            fontSize: maxSize,
            color: Colors.black.withOpacity(0.6),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TermOfServiceScreen(
                      userAddress: widget.userAddress,
                      userEmail: widget.userEmail,
                      userName: widget.userName,
                      userNumber: widget.userNumber,
                      userPayment: widget.userPayment,
                      userProfileImage: widget.userProfileImage,
                      userWalletId: widget.userWalletId,
                    ),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  headingWidgetMethod('Terms Of Service'),
                  const SizedBox(height: 5),
                  paragraphWidgetMethod('Read Terms Of Service', context),
                  const SizedBox(height: 14),
                  const Divider(),
                ],
              ),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PrivacyPloicyScreen(
                      userAddress: widget.userAddress,
                      userEmail: widget.userEmail,
                      userName: widget.userName,
                      userNumber: widget.userNumber,
                      userPayment: widget.userPayment,
                      userProfileImage: widget.userProfileImage,
                      userWalletId: widget.userWalletId,
                    ),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  headingWidgetMethod('Privacy Policy'),
                  const SizedBox(height: 5),
                  paragraphWidgetMethod('Read Privacy Policy', context),
                  const SizedBox(height: 20),
                  const Divider(),
                ],
              ),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () async {
                await FlutterEmailSender.send(
                  Email(
                    body: 'body of email',
                    subject: 'subject of email',
                    recipients: [companyMail],
                    isHTML: false,
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  headingWidgetMethod('Contact Us'),
                  const SizedBox(height: 20),
                  const Divider(),
                ],
              ),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VersionScreen(),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  headingWidgetMethod('App Version'),
                  const SizedBox(height: 5),
                  paragraphWidgetMethod(appVersion, context),
                  const SizedBox(height: 20),
                  const Divider(),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    headingWidgetMethod('Push Notifications'),
                    Switch(
                      value: isSwitched,
                      onChanged: (value) {
                        setState(
                          () {
                            isSwitched = value;
                            print(isSwitched);
                          },
                        );
                      },
                      activeTrackColor: Colors.blue.withOpacity(0.5),
                      activeColor: Colors.blue,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
