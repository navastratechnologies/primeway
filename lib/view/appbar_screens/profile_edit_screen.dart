import 'dart:core';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:primewayskills_app/view/helpers/colors.dart';
import 'package:primewayskills_app/view/helpers/helping_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileEditScreen extends StatefulWidget {
  final String userId;
  final String userName;
  const ProfileEditScreen(
      {Key? key, required this.userId, required this.userName})
      : super(key: key);

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final firebaseInstance = FirebaseFirestore.instance;

  String name = '';
  String address = '';
  String profileImage = '';
  String payment = '';
  String number = '';
  String email = '';

 
  Future<void> getUserProfileData() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .get()
        .then((value) {
      log('name is ${value.get('name')}');
      setState(() {
        name = value.get('name');
        address = value.get('address');
        profileImage = value.get('profile_pic');
        payment = value.get('payments');
        number = value.get('phone_number');
        email = value.get('email');
      });
    });
  }

  @override
  void initState() {
    getUserProfileData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primeColor,
        title: Text(
          'Profile',
          style: TextStyle(
            fontSize: maxSize,
            color: whiteColor,
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
                InkWell(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: whiteColor,
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(
                          profileImage,
                        ),
                        fit: BoxFit.cover,
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
                      name,
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
                          width: width / 2,
                          decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Stack(
                            children: [
                              Container(
                                height: 6,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: primeColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          "28%",
                          style: TextStyle(
                            color: primeColor,
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
              height: height / 1.45,
              width: width / 1.2,
              child: ListView(
                children: [
                  Container(
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'INCOMPLETE',
                              style: TextStyle(
                                color: primeColor,
                                fontSize: 10,
                                letterSpacing: 1,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                'EDIT',
                                style: TextStyle(
                                  color: primeColor,
                                  fontSize: 12,
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        headingWidgetMethod('About you'),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            profileEditInternalWidget('Name', widget.userName),
                            profileEditInternalWidget('Email', email),
                          ],
                        ),
                        const SizedBox(height: 20),
                        profileEditInternalWidget('Phone', number),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  editProfileCardWidget('Social Accounts'),
                  Container(
                    color: Colors.red,
                    child: GestureDetector(
                      onTap: () {
                        canLaunchUrl(Uri.parse('www.google.com'));
                      },
                      child: const Text('Click'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  editProfileCardWidget('Commercials'),
                  const SizedBox(height: 16),
                  editProfileCardWidget('Payments'),
                  Text(payment),
                  const SizedBox(height: 16),
                  editProfileCardWidget('Address'),
                  Text(address),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
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
