import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:primewayskills_app/models/demo_models.dart';
import 'package:primewayskills_app/view/helpers/colors.dart';

class CompleteProfileScreen extends StatefulWidget {
  final String userNumber;
  final String userName;
  final String userAddress;
  final String userProfileImage;
  final String userPayment;
  final String userEmail;
  final String userWalletId;
  const CompleteProfileScreen(
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
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController describeController = TextEditingController();
  TextEditingController dateOfBrithController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController seconderyNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController languageController = TextEditingController();
  List languageType = [];
  int describeCharLength = 0;

  bool male = false;
  bool female = false;
  bool otherGender = false;
  String genderType = '';

  bool pageOne = true;
  bool pageTwo = false;
  bool pageThree = false;
  bool pageOneEditing = false;
  bool pageTwoEditing = false;
  bool pageThreeEditing = false;
  PlatformFile? pickedFile;
  UploadTask? uploadTask;

  String dob = 'Date of Birth';
  DateTime _indobDate = DateTime.now();

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });
  }

  Future uploadFile() async {
    final path = 'users/${pickedFile!.name}';
    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    setState(() {
      uploadTask = ref.putFile(file);
    });

    final snapshot = await uploadTask!.whenComplete(() {});

    final urlDownload = await snapshot.ref.getDownloadURL();
    log('Download link : $urlDownload');

    setState(() {
      uploadTask = null;
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userNumber)
        .update({
      'profile_pic': urlDownload.toString(),
    });
  }

  Future<void> updateProfile() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userNumber)
        .update({
      'name': nameController.text,
      'email': emailController.text,
      'secondry_phone_number': seconderyNumberController.text,
      'description': describeController.text,
      'gender': genderType,
      'date_of_brith': dob,
      'address': addressController.text,
      'language':
          languageType.toString().replaceAll('[', '').replaceAll(']', ''),
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      nameController.text = widget.userName;
      addressController.text = widget.userAddress;
      emailController.text = widget.userEmail;
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primeColor,
        title: Text(
          'About You',
          style: TextStyle(
            fontSize: maxSize,
            color: whiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SizedBox(
        width: width,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: whiteColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: primeColor,
                      ),
                      child: pageOneEditing
                          ? FaIcon(
                              FontAwesomeIcons.check,
                              color: whiteColor,
                              size: 14,
                            )
                          : Text(
                              '1',
                              style: TextStyle(
                                color: whiteColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Container(
                        height: 2,
                        decoration: BoxDecoration(
                          color: pageOneEditing
                              ? primeColor
                              : Colors.black.withOpacity(0.2),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: primeColor,
                      ),
                      child: pageTwoEditing
                          ? FaIcon(
                              FontAwesomeIcons.check,
                              color: whiteColor,
                              size: 14,
                            )
                          : Text(
                              '2',
                              style: TextStyle(
                                color: whiteColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Container(
                        height: 2,
                        decoration: BoxDecoration(
                          color: pageTwoEditing
                              ? primeColor
                              : Colors.black.withOpacity(0.2),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: primeColor,
                      ),
                      child: pageThreeEditing
                          ? FaIcon(
                              FontAwesomeIcons.check,
                              color: whiteColor,
                              size: 14,
                            )
                          : Text(
                              '3',
                              style: TextStyle(
                                color: whiteColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              // height: height/1.27,
              // width: width,
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    pageOne
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 20),
                                Center(
                                  child: SizedBox(
                                    width: 100,
                                    child: InkWell(
                                      onTap: () {
                                        selectFile();
                                      },
                                      child: Stack(
                                        children: [
                                          pickedFile == null
                                              ? Container(
                                                  width: 80,
                                                  height: 80,
                                                  decoration: BoxDecoration(
                                                    color: whiteColor,
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                      image: NetworkImage(widget
                                                          .userProfileImage),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                )
                                              : SizedBox(
                                                  width: 80,
                                                  height: 80,
                                                  child: Image.file(
                                                    File(pickedFile!.path!),
                                                    width: 180,
                                                    height: 110,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 20),
                                            child: Align(
                                              alignment: Alignment.topRight,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: primeColor,
                                                ),
                                                child: Icon(
                                                  Icons.edit,
                                                  size: 14,
                                                  color: whiteColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'Name',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextField(
                                  controller: nameController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black.withOpacity(0.2),
                                      ),
                                    ),
                                    hintText: 'Enter your name',
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black.withOpacity(0.2),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 30),
                                const Text(
                                  'Describe your work',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextField(
                                  maxLines: 4,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black.withOpacity(0.2),
                                      ),
                                    ),
                                    hintText: 'Describe your work here...',
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black.withOpacity(0.2),
                                      ),
                                    ),
                                  ),
                                  controller: describeController,
                                  onChanged: (value) {
                                    setState(() {
                                      describeCharLength = value.length;
                                    });
                                  },
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(128),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    "$describeCharLength / 128",
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(0.4),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 30),
                                const Text(
                                  'Gender',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                  height: 50,
                                  width: width,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            male = true;
                                            female = false;
                                            otherGender = false;
                                            genderType = 'Male';
                                          });
                                          log('log is $male $female $otherGender');
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 6,
                                            horizontal: 16,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                male ? primeColor : whiteColor,
                                            border: Border.all(
                                              width: 2,
                                              color: primeColor,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            'Male',
                                            style: TextStyle(
                                              color: male
                                                  ? whiteColor
                                                  : primeColor,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            male = false;
                                            female = true;
                                            otherGender = false;
                                            genderType = 'Female';
                                          });
                                          log('log is $male $female $otherGender');
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 6,
                                            horizontal: 16,
                                          ),
                                          decoration: BoxDecoration(
                                            color: female
                                                ? primeColor
                                                : whiteColor,
                                            border: Border.all(
                                              width: 2,
                                              color: primeColor,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            'Female',
                                            style: TextStyle(
                                              color: female
                                                  ? whiteColor
                                                  : primeColor,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            male = false;
                                            female = false;
                                            otherGender = true;
                                            genderType = 'Other Gender';
                                          });
                                          log('log is $male $female $otherGender');
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 6,
                                            horizontal: 16,
                                          ),
                                          decoration: BoxDecoration(
                                            color: otherGender
                                                ? primeColor
                                                : whiteColor,
                                            border: Border.all(
                                              width: 2,
                                              color: primeColor,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            'Other',
                                            style: TextStyle(
                                              color: otherGender
                                                  ? whiteColor
                                                  : primeColor,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 30),
                                const Text(
                                  'Date of Birth',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                InkWell(
                                  onTap: () async {
                                    DateTime? dobDate = await showDatePicker(
                                      context: context,
                                      initialDate: _indobDate,
                                      firstDate: DateTime(1990),
                                      lastDate: DateTime(2030),
                                      builder: (context, picker) {
                                        return Theme(
                                          data: ThemeData.dark().copyWith(
                                            colorScheme: ColorScheme.dark(
                                              primary: Colors.white,
                                              onPrimary: Colors.black,
                                              surface: primeColor,
                                              onSurface: Colors.white,
                                            ),
                                            dialogBackgroundColor: primeColor,
                                          ),
                                          child: picker!,
                                        );
                                      },
                                    );
                                    if (dobDate != null) {
                                      setState(() {
                                        _indobDate = dobDate;
                                        dob =
                                            "${_indobDate.day}/${_indobDate.month}/${_indobDate.year}";
                                      });
                                      log("last index$_indobDate");
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: primeColor,
                                    ),
                                    padding: const EdgeInsets.all(10),
                                    child: Text(
                                      dob,
                                      style: TextStyle(
                                          color: whiteColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Gil"),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  height: 70,
                                  width: width,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            pageOne = false;
                                            pageTwo = true;
                                            pageThree = false;
                                            pageOneEditing = true;
                                          });
                                        },
                                        child: Container(
                                          height: 50,
                                          width: width / 1.5,
                                          decoration: BoxDecoration(
                                            color: primeColor,
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.2),
                                                blurRadius: 10,
                                                spreadRadius: 2,
                                              ),
                                            ],
                                          ),
                                          child: Center(
                                            child: Text(
                                              'Next',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: maxSize - 3,
                                                color: whiteColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Center(
                                  child: TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text(
                                      'Back',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: primeColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : pageTwo
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 20),
                                    const Text(
                                      'Location',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    TextField(
                                      controller: addressController,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color:
                                                Colors.black.withOpacity(0.2),
                                          ),
                                        ),
                                        hintText: 'Enter Your Location',
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color:
                                                Colors.black.withOpacity(0.2),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 30),
                                    const Text(
                                      'Primary Contact',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'This number is used for login and cannot be edited',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 13,
                                        color: Colors.black.withOpacity(0.4),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      widget.userNumber,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 30),
                                    const Text(
                                      'Secondary Contact',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    TextField(
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color:
                                                Colors.black.withOpacity(0.2),
                                          ),
                                        ),
                                        hintText: '1234567890',
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color:
                                                Colors.black.withOpacity(0.2),
                                          ),
                                        ),
                                      ),
                                      controller: seconderyNumberController,
                                      onChanged: (value) {
                                        setState(() {
                                          describeCharLength = value.length;
                                        });
                                      },
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(10),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Text(
                                        "$describeCharLength / 10",
                                        style: TextStyle(
                                          color: Colors.black.withOpacity(0.4),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    const Text(
                                      'Email',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    TextField(
                                      controller: emailController,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color:
                                                Colors.black.withOpacity(0.2),
                                          ),
                                        ),
                                        hintText: 'Enter Your Email',
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color:
                                                Colors.black.withOpacity(0.2),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 30),
                                    SizedBox(
                                      height: 70,
                                      width: width,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                pageOne = false;
                                                pageTwo = false;
                                                pageThree = true;
                                                pageTwoEditing = true;
                                              });
                                            },
                                            child: Container(
                                              height: 50,
                                              width: width / 1.5,
                                              decoration: BoxDecoration(
                                                color: primeColor,
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.2),
                                                    blurRadius: 10,
                                                    spreadRadius: 2,
                                                  ),
                                                ],
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'Next',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: maxSize - 3,
                                                    color: whiteColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Center(
                                      child: TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text(
                                          'Back',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: primeColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 20),
                                    const Text(
                                      'Content Language',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Select upto 3 languages in which you create content',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black.withOpacity(0.4),
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(height: 30),
                                    GridView.builder(
                                      itemCount: languageModel.length,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        mainAxisSpacing: 1,
                                        crossAxisSpacing: 1,
                                        childAspectRatio: 2,
                                      ),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Center(
                                          child: InkWell(
                                            onTap: () {
                                              if (languageType.contains(
                                                  languageModel[index])) {
                                                setState(() {
                                                  languageType.remove(
                                                      languageModel[index]);
                                                });
                                              } else {
                                                if (languageType.length < 3) {
                                                  setState(() {
                                                    languageType.add(
                                                        languageModel[index]);
                                                  });
                                                }
                                              }
                                              log('language is : $languageType');
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 10),
                                              decoration: BoxDecoration(
                                                color: languageType.contains(
                                                        languageModel[index])
                                                    ? primeColor2
                                                    : Colors.blue,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Text(
                                                languageModel[index],
                                                style: TextStyle(
                                                  color: whiteColor,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 30),
                                    SizedBox(
                                      height: 70,
                                      width: width,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () =>
                                                Navigator.of(context).pop(),
                                            child: Container(
                                              height: 50,
                                              width: width / 1.5,
                                              decoration: BoxDecoration(
                                                color: primeColor,
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.2),
                                                    blurRadius: 10,
                                                    spreadRadius: 2,
                                                  ),
                                                ],
                                              ),
                                              child: InkWell(
                                                onTap: () {
                                                  updateProfile();
                                                  uploadFile();
                                                  Navigator.pop(context);
                                                },
                                                child: Center(
                                                  child: Text(
                                                    'Next',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: maxSize - 3,
                                                      color: whiteColor,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Center(
                                      child: TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text(
                                          'Back',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: primeColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
