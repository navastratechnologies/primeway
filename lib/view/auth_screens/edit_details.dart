import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:primewayskills_app/view/helpers/colors.dart';
import 'package:primewayskills_app/view/helpers/loader.dart';
import 'package:primewayskills_app/view/helpers/responsive_size_helper.dart';

class EditDetailsPage extends StatefulWidget {
  // final String name;
  final String phoneNumber;
  const EditDetailsPage({super.key, required this.phoneNumber});

  @override
  State<EditDetailsPage> createState() => _EditDetailsPageState();
}

class _EditDetailsPageState extends State<EditDetailsPage> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dobController = TextEditingController();

  DateTime dateOfBirth = DateTime.now();

  Future<void> updateAddress() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.phoneNumber)
        .update(
      {
        'email': emailController.text,
        'name': fullNameController.text,
        'date_of_brith': dobController.text,
      },
    );
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
          emailController.text = value.get('email');
          fullNameController.text = value.get('name');
          dobController.text = value.get('date_of_brith');
        });
      },
    );
  }

  Future<void> _selectDateOfBirth() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: dateOfBirth,
        firstDate: DateTime(1900),
        lastDate: DateTime.now());
    if (picked != null && picked != dateOfBirth) {
      setState(() {
        dateOfBirth = picked;
        dobController.text =
            "${dateOfBirth.day.toString()}-${dateOfBirth.month.toString()}-${dateOfBirth.year.toString()}";
      });
    }
  }

  @override
  void initState() {
    getUserProfileData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
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
                  onPressed: () => Navigator.pop(context),
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
                "Edit your profile details for communication here",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 50),
              editDetailsWidget("Name", fullNameController),
              const SizedBox(height: 20),
              editDetailsWidget("Email", emailController),
              const SizedBox(height: 20),
              InkWell(
                onTap: _selectDateOfBirth,
                child: editDetailsWidget("DOB", dobController),
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
                    var currentYear = DateTime.now().year - dateOfBirth.year;
                    if (currentYear > 18) {
                      setState(() {
                        
                        updateAddress();
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          margin: const EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: primeColor,
                          content: Text(
                            "Date Of Birth is less than 18 years.",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: whiteColor,
                            ),
                          ),
                        ),
                      );
                    }
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
    );
  }

  editDetailsWidget(heading, controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black.withOpacity(0.4),
          ),
        ),
        const SizedBox(height: 10),
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
              enabled: heading == "DOB" ? false : true,
              controller: controller,
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
