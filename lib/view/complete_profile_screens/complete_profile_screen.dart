import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:primewayskills_app/models/demo_models.dart';
import 'package:primewayskills_app/view/helpers/colors.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({Key? key}) : super(key: key);

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  TextEditingController describeController = TextEditingController();

  int describeCharLength = 0;

  bool male = false;
  bool female = false;
  bool otherGender = false;

  bool pageOne = true;
  bool pageTwo = false;
  bool pageThree = false;
  bool pageOneEditing = false;
  bool pageTwoEditing = false;
  bool pageThreeEditing = false;

  String dob = 'Date of Birth';
  DateTime _indobDate = DateTime.now();

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
                                      child: Stack(
                                        children: [
                                          Container(
                                            width: 80,
                                            height: 80,
                                            decoration: BoxDecoration(
                                              color: whiteColor,
                                              shape: BoxShape.circle,
                                              image: const DecorationImage(
                                                image: NetworkImage(
                                                  'https://images.unsplash.com/photo-1593104547489-5cfb3839a3b5?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1706&q=80',
                                                ),
                                                fit: BoxFit.cover,
                                              ),
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
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black.withOpacity(0.2),
                                      ),
                                    ),
                                    hintText: 'Enter Your Name',
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
                                    const Text(
                                      '9876543210',
                                      style: TextStyle(
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
                                        hintText: '9876543210',
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color:
                                                Colors.black.withOpacity(0.2),
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
                                          child: Container(
                                            padding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                    vertical: 10),
                                            decoration: BoxDecoration(
                                              color: Colors.blue,
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
