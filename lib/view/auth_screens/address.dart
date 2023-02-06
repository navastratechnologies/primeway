import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:primewayskills_app/view/appbar_screens/profile_edit_screen.dart';
import 'package:primewayskills_app/view/auth_screens/upload_image.dart';
import 'package:primewayskills_app/view/helpers/colors.dart';
import 'package:primewayskills_app/view/helpers/responsive_size_helper.dart';

class EditAddressPage extends StatefulWidget {
  // final String name;
  final String phoneNumber;
  final String pageType;
  const EditAddressPage({
    super.key,
    required this.phoneNumber,
    required this.pageType,
  });

  @override
  State<EditAddressPage> createState() => _EditAddressPageState();
}

class _EditAddressPageState extends State<EditAddressPage> {
  TextEditingController addressController = TextEditingController();

  Future<void> updateAddress() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.phoneNumber)
        .update(
      {
        'address': addressController.text,
      },
    );

    if (widget.pageType == "new") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UplodeImage(
            pageType: 'new',
            phoneNumber: widget.phoneNumber,
          ),
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> getUserProfileData() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.phoneNumber)
        .get()
        .then(
      (value) {
        log('user name is ${value.get('name')}');
        setState(() {
          addressController.text = value.get('address');
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
        builder: (context) => ProfileEditScreen(
          userNumber: widget.phoneNumber,
        ),
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
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileEditScreen(
                  userNumber: widget.phoneNumber,
                ),
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  MaterialButton(
                    color: purpleColor,
                    padding: const EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onPressed: () => widget.pageType == "new"
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UplodeImage(
                                pageType: 'new',
                                phoneNumber: widget.phoneNumber,
                              ),
                            ),
                          )
                        : Navigator.pop(context),
                    child: const Text(
                      'Skip for now',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          title: Text(
            "Address",
            style: TextStyle(
              fontSize: maxSize,
              color: Colors.black.withOpacity(0.6),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Your full address for offline communication",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 50),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: primeColor.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 1,
                      )
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      maxLines: 7,
                      controller: addressController,
                      decoration: InputDecoration(
                        floatingLabelAlignment: FloatingLabelAlignment.start,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        label: Text(
                          'Address',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black.withOpacity(0.4),
                          ),
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Center(
                  child: MaterialButton(
                    minWidth: displayWidth(context) / 1.5,
                    color: primeColor2,
                    padding: const EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onPressed: () {
                      updateAddress();
                    },
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
