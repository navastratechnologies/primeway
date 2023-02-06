import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:primewayskills_app/models/demo_models.dart';
import 'package:primewayskills_app/view/appbar_screens/profile_edit_screen.dart';
import 'package:primewayskills_app/view/helpers/alert_deialogs.dart';
import 'package:primewayskills_app/view/helpers/colors.dart';
import 'package:primewayskills_app/view/helpers/responsive_size_helper.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

class EditDetailsPage extends StatefulWidget {
  final String phoneNumber;
  const EditDetailsPage({
    super.key,
    required this.phoneNumber,
  });

  @override
  State<EditDetailsPage> createState() => _EditDetailsPageState();
}

class _EditDetailsPageState extends State<EditDetailsPage> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController secondaryNumberController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController genderController = TextEditingController();

  bool showMale = false;
  bool showFemale = false;

  List languageType = [];
  List categoryType = [];

  DateTime dateOfBirth = DateTime.now();

  Future<void> updateDetails() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.phoneNumber)
        .update(
      {
        'email': emailController.text,
        'name': fullNameController.text,
        'date_of_brith': dobController.text,
        'language':
            languageType.toString().replaceAll('[', '').replaceAll(']', ''),
        'categories':
            categoryType.toString().replaceAll('[', '').replaceAll(']', ''),
        'secondry_phone_number': secondaryNumberController.text,
        'description': descriptionController.text,
        'gender': genderController.text,
      },
    );
    alertDialogWidget(
      context,
      purpleColor,
      "Details Updated Successfully",
    );
  }

  Future<void> getUserProfileData() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.phoneNumber)
        .get()
        .then(
      (value) {
        setState(() {
          emailController.text = value.get('email');
          fullNameController.text = value.get('name');
          dobController.text = value.get('date_of_brith');
          dateOfBirth = DateTime.parse(dobController.text);
          if (value.get('language').toString().isNotEmpty) {
            languageType =
                value.get('language').toString().replaceAll(' ', '').split(",");
          }
          log('language is user : $languageType');
          if (value.get('categories').toString().isNotEmpty) {
            categoryType = value
                .get('categories')
                .toString()
                .replaceAll(' ', '')
                .split(",");
          }
          log('category is user : $categoryType');
          descriptionController.text = value.get('description');
          genderController.text = value.get('gender');
          if (genderController.text == "male") {
            showMale = true;
            showFemale = false;
          }
          secondaryNumberController.text = value.get('secondry_phone_number');
        });
      },
    );
  }

  Future<void> _selectDateOfBirth() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dateOfBirth,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, picker) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: primeColor2,
              onPrimary: Colors.white,
              surface: primeColor2,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: whiteColor,
          ),
          child: picker!,
        );
      },
    );
    if (picked != null && picked != dateOfBirth) {
      setState(
        () {
          dateOfBirth = picked;
          dobController.text =
              "${dateOfBirth.year.toString()}-${dateOfBirth.month.toString()}-${dateOfBirth.day.toString()}";
        },
      );
    }
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
            "Profile",
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
                const SizedBox(height: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Gender",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black.withOpacity(0.4),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                showMale = true;
                                showFemale = false;
                                genderController.text = 'male';
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: showMale ? primeColor2 : Colors.white,
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
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  "Male",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color:
                                        showMale ? Colors.white : Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                showMale = false;
                                showFemale = true;
                                genderController.text = 'female';
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: showFemale ? primeColor2 : Colors.white,
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
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  "Female",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: showFemale
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                editDetailsWidget("Name", fullNameController),
                const SizedBox(height: 20),
                editDetailsWidget("Email", emailController),
                const SizedBox(height: 20),
                editDetailsWidget(
                    "Secondary Phone Number", secondaryNumberController),
                const SizedBox(height: 20),
                InkWell(
                  onTap: _selectDateOfBirth,
                  child: editDetailsWidget("DOB", dobController),
                ),
                const SizedBox(height: 20),
                Text(
                  "Description (Bio)",
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
                      maxLines: 4,
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Content Language',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black.withOpacity(0.4),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Select upto 3 languages in which you create content',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black.withOpacity(0.2),
                      ),
                    ),
                    const SizedBox(height: 30),
                    ResponsiveGridList(
                      listViewBuilderOptions: ListViewBuilderOptions(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                      ),
                      minItemWidth: 80,
                      minItemsPerRow: 3,
                      children: List.generate(
                        languageModel.length,
                        (index) => Center(
                          child: InkWell(
                            onTap: () {
                              if (languageType.contains(languageModel[index])) {
                                setState(() {
                                  languageType.remove(languageModel[index]);
                                });
                              } else {
                                if (languageType.length < 3) {
                                  setState(() {
                                    languageType.add(languageModel[index]
                                        .toString()
                                        .replaceAll(',', ''));
                                  });
                                }
                              }
                              log('language is : $languageType');
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color:
                                    languageType.contains(languageModel[index])
                                        ? primeColor2
                                        : whiteColor,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: primeColor.withOpacity(0.1),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: Text(
                                languageModel[index],
                                style: TextStyle(
                                  color: languageType
                                          .contains(languageModel[index])
                                      ? whiteColor
                                      : Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Content Category',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black.withOpacity(0.4),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Select upto 3 categories in which you create content',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black.withOpacity(0.2),
                      ),
                    ),
                    const SizedBox(height: 30),
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('creator_program_category')
                          .snapshots(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                        if (streamSnapshot.hasData) {
                          return ResponsiveGridList(
                            listViewBuilderOptions: ListViewBuilderOptions(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                            ),
                            minItemWidth: 80,
                            minItemsPerRow: 3,
                            children: List.generate(
                              streamSnapshot.data!.docs.length,
                              (index) {
                                DocumentSnapshot documentSnapshot =
                                    streamSnapshot.data!.docs[index];
                                return Center(
                                  child: InkWell(
                                    onTap: () {
                                      if (categoryType.contains(
                                          documentSnapshot['category'])) {
                                        setState(() {
                                          categoryType.remove(
                                              documentSnapshot['category']);
                                        });
                                      } else {
                                        if (categoryType.length < 3) {
                                          setState(() {
                                            categoryType.add(
                                                documentSnapshot['category']);
                                          });
                                        }
                                      }
                                      log('category is : $categoryType');
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      decoration: BoxDecoration(
                                        color: categoryType.contains(
                                                documentSnapshot['category'])
                                            ? primeColor2
                                            : whiteColor,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: primeColor.withOpacity(0.1),
                                            blurRadius: 10,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        documentSnapshot['category'],
                                        style: TextStyle(
                                          color: categoryType.contains(
                                                  documentSnapshot['category'])
                                              ? whiteColor
                                              : Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }
                        return Container();
                      },
                    ),
                  ],
                ),
              ],
            ),
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
          height: 80,
          child: Center(
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
                  if (fullNameController.text.isNotEmpty &&
                      emailController.text.isNotEmpty &&
                      dobController.text.isNotEmpty &&
                      languageModel.isNotEmpty &&
                      secondaryNumberController.text.isNotEmpty &&
                      descriptionController.text.isNotEmpty &&
                      genderController.text.isNotEmpty) {
                    updateDetails();
                  } else {
                    alertDialogWidget(
                      context,
                      primeColor,
                      "Please fill all details to continue",
                    );
                  }
                } else {
                  alertDialogWidget(
                    context,
                    primeColor,
                    "Date Of Birth is less than 18 years.",
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
