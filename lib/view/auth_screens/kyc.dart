// ignore_for_file: avoid_print, invalid_return_type_for_catch_error

import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:primewayskills_app/view/appbar_screens/profile_edit_screen.dart';
import 'package:primewayskills_app/view/helpers/alert_deialogs.dart';
import 'package:primewayskills_app/view/helpers/colors.dart';
import 'package:primewayskills_app/view/helpers/responsive_size_helper.dart';

class EkycPage extends StatefulWidget {
  final String phoneNumber;
  const EkycPage({
    super.key,
    required this.phoneNumber,
  });

  @override
  State<EkycPage> createState() => _EkycPageState();
}

class _EkycPageState extends State<EkycPage> {
  bool showSavingsAccount = true;
  bool showCurrentAccount = false;
  bool showadharColor = true;
  bool showpanColor = false;
  bool showvotarColor = false;
  String documentType = 'Aadhar Card';
  String accountType = 'Savings';

  String userFrontDocument = '';
  String userBackDocument = '';
  String userDocumentType = '';

  TextEditingController accountNameController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  TextEditingController accoutnNumberController = TextEditingController();
  TextEditingController confirmAccountNumberController =
      TextEditingController();
  TextEditingController ifscNumberController = TextEditingController();

  PlatformFile? pickedFile;
  PlatformFile? pickedFile2;
  UploadTask? uploadTask;
  UploadTask? uploadTask2;

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });
  }

  Future selectFile2() async {
    final result2 = await FilePicker.platform.pickFiles();
    if (result2 == null) return;

    setState(() {
      pickedFile2 = result2.files.first;
    });
  }

  Future uploadFile() async {
    final path = 'documents/${pickedFile!.name}';
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

    String urlDownload2 = '';

    if (documentType == "Aadhar Card") {
      final path2 = 'documents/${pickedFile2!.name}';
      final file2 = File(pickedFile2!.path!);

      final ref2 = FirebaseStorage.instance.ref().child(path2);
      setState(() {
        uploadTask2 = ref2.putFile(file2);
      });

      final snapshot2 = await uploadTask2!.whenComplete(() {});

      urlDownload2 = await snapshot2.ref.getDownloadURL();
      log('Download link : $urlDownload2');

      setState(() {
        uploadTask2 = null;
      });
    }

    if (documentType == "Aadhar Card") {
      FirebaseFirestore.instance
          .collection('users')
          .doc(widget.phoneNumber)
          .update({
        'front_document': urlDownload.toString(),
        'back_document': urlDownload2.toString(),
        'document_type': documentType,
      });
    } else {
      FirebaseFirestore.instance
          .collection('users')
          .doc(widget.phoneNumber)
          .update({
        'front_document': urlDownload.toString(),
        'document_type': documentType,
      });
    }
  }

  Future<void> updateAccount() async {
    if (accoutnNumberController.text == confirmAccountNumberController.text) {
      FirebaseFirestore.instance
          .collection('wallet')
          .doc(widget.phoneNumber)
          .update(
        {
          'account_number': accoutnNumberController.text,
          'bank_name': bankNameController.text,
          'ifsc': ifscNumberController.text,
          'account_holder_name': accountNameController.text,
          'account_type': accountType,
        },
      );
      FirebaseFirestore.instance
          .collection('users')
          .doc(widget.phoneNumber)
          .update(
        {
          'account_number': accoutnNumberController.text,
          'bank_name': bankNameController.text,
          'ifsc': ifscNumberController.text,
          'account_holder_name': accountNameController.text,
          'account_type': accountType,
        },
      );
    } else {
      log('Account number is not match');
    }
  }

  Future<void> getUserProfileData() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.phoneNumber)
        .get()
        .then(
      (value) {
        setState(() {
          bankNameController.text = value.get('bank_name');
          accountNameController.text = value.get('account_holder_name');
          accoutnNumberController.text = value.get('account_number');
          confirmAccountNumberController.text = value.get('account_number');
          ifscNumberController.text = value.get('ifsc');
          accountType = value.get('account_type');
          if (accountType == "Current") {
            showCurrentAccount = true;
            showSavingsAccount = false;
          } else {
            showCurrentAccount = false;
            showSavingsAccount = true;
          }
          userFrontDocument = value.get('front_document');
          userBackDocument = value.get('back_document');
          userDocumentType = value.get('document_type');
          if (userDocumentType == "Aadhar Card") {
            showadharColor = true;
            showpanColor = false;
            showvotarColor = false;
          } else if (userDocumentType == "Pan Card") {
            showadharColor = false;
            showpanColor = true;
            showvotarColor = false;
          } else {
            showadharColor = false;
            showpanColor = false;
            showvotarColor = true;
          }
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
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          body: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      primeColor,
                      primeColor.withOpacity(0.6),
                      primeColor.withOpacity(0.8),
                    ],
                  ),
                ),
                child: AppBar(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: whiteColor,
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileEditScreen(
                          userNumber: widget.phoneNumber,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    "Upload KYC",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: whiteColor,
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        color: whiteColor,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      primeColor,
                      primeColor.withOpacity(0.6),
                      primeColor.withOpacity(0.8),
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    TabBar(
                      indicatorColor: primeColor2,
                      indicatorWeight: 3,
                      indicatorSize: TabBarIndicatorSize.label,
                      tabs: [
                        Tab(
                          child: Text(
                            "Id Proof",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: whiteColor.withOpacity(0.7),
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            "Bank Detail",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: whiteColor.withOpacity(0.7),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              Expanded(
                // height: MediaQuery.of(context).size.height / 1.25,
                child: TabBarView(
                  children: [
                    SingleChildScrollView(
                      child: Container(
                        decoration: BoxDecoration(
                          color: whiteColor,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              const Text(
                                "Choose Document Type",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 30),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        showadharColor = true;
                                        showpanColor = false;
                                        showvotarColor = false;
                                        documentType = 'Aadhar Card';
                                        pickedFile = null;
                                        pickedFile2 = null;
                                      });
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width /
                                          3.5,
                                      decoration: BoxDecoration(
                                        color: showadharColor
                                            ? primeColor2
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(25),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 10,
                                            spreadRadius: 1,
                                          )
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          "Aadhar Card",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: showadharColor
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        showadharColor = false;
                                        showpanColor = true;
                                        showvotarColor = false;
                                        documentType = 'Pan Card';
                                        pickedFile = null;
                                        pickedFile2 = null;
                                      });
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width /
                                          3.5,
                                      decoration: BoxDecoration(
                                        color: showpanColor
                                            ? primeColor2
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(25),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 10,
                                            spreadRadius: 1,
                                          )
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          "Pan Card",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: showpanColor
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        showadharColor = false;
                                        showpanColor = false;
                                        showvotarColor = true;
                                        documentType = 'Voter Card';
                                        pickedFile = null;
                                        pickedFile2 = null;
                                      });
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width /
                                          3.5,
                                      decoration: BoxDecoration(
                                        color: showvotarColor
                                            ? primeColor2
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(25),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 10,
                                            spreadRadius: 1,
                                          )
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          "Voter Id",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: showvotarColor
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 50),
                              const Text(
                                "Upload Your Id Proof",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 30),
                              showadharColor
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        userDocumentType == "Aadhar Card" &&
                                                userFrontDocument.isNotEmpty
                                            ? Container(
                                                height: 220,
                                                width: displayWidth(context),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: primeColor2
                                                          .withOpacity(0.3),
                                                      spreadRadius: 1,
                                                      blurRadius: 10,
                                                    )
                                                  ],
                                                ),
                                                child: Image.network(
                                                  userFrontDocument,
                                                  fit: BoxFit.fill,
                                                ),
                                              )
                                            : Container(
                                                height: 220,
                                                width: displayWidth(context),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: primeColor2
                                                          .withOpacity(0.3),
                                                      spreadRadius: 1,
                                                      blurRadius: 10,
                                                    )
                                                  ],
                                                ),
                                                child: InkWell(
                                                  onTap: () {
                                                    selectFile();
                                                  },
                                                  child: pickedFile == null
                                                      ? Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Icon(
                                                                Icons.camera,
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.3),
                                                                size: 100,
                                                              ),
                                                              const SizedBox(
                                                                  height: 10),
                                                              Text(
                                                                "Front Picture",
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.5),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      : Container(
                                                          color:
                                                              Colors.blue[100],
                                                          child: Image.file(
                                                            File(pickedFile!
                                                                .path!),
                                                            fit: BoxFit.fill,
                                                          ),
                                                        ),
                                                ),
                                              ),
                                        const SizedBox(height: 10),
                                        userDocumentType == "Aadhar Card" &&
                                                userBackDocument.isNotEmpty
                                            ? Container(
                                                height: 220,
                                                width: displayWidth(context),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: primeColor2
                                                          .withOpacity(0.3),
                                                      spreadRadius: 1,
                                                      blurRadius: 10,
                                                    )
                                                  ],
                                                ),
                                                child: Image.network(
                                                  userBackDocument,
                                                  fit: BoxFit.fill,
                                                ),
                                              )
                                            : Container(
                                                height: 220,
                                                width: displayWidth(context),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: primeColor2
                                                          .withOpacity(0.3),
                                                      spreadRadius: 1,
                                                      blurRadius: 10,
                                                    )
                                                  ],
                                                ),
                                                child: InkWell(
                                                  onTap: () {
                                                    selectFile2();
                                                  },
                                                  child: pickedFile2 == null
                                                      ? Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Icon(
                                                                Icons.camera,
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.3),
                                                                size: 100,
                                                              ),
                                                              const SizedBox(
                                                                  height: 10),
                                                              Text(
                                                                "Back Picture",
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.5),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      : Container(
                                                          color:
                                                              Colors.blue[100],
                                                          child: Image.file(
                                                            File(pickedFile2!
                                                                .path!),
                                                            fit: BoxFit.fill,
                                                          ),
                                                        ),
                                                ),
                                              ),
                                      ],
                                    )
                                  : userDocumentType != "Aadhar Card" &&
                                          userFrontDocument.isNotEmpty
                                      ? Container(
                                          height: 220,
                                          width: displayWidth(context),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            boxShadow: [
                                              BoxShadow(
                                                color: primeColor2
                                                    .withOpacity(0.3),
                                                spreadRadius: 1,
                                                blurRadius: 10,
                                              )
                                            ],
                                          ),
                                          child: Image.network(
                                            userFrontDocument,
                                            fit: BoxFit.fill,
                                          ),
                                        )
                                      : Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            boxShadow: [
                                              BoxShadow(
                                                color: primeColor2
                                                    .withOpacity(0.3),
                                                spreadRadius: 1,
                                                blurRadius: 10,
                                              )
                                            ],
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              selectFile();
                                            },
                                            child: Container(
                                              height: 220,
                                              width: displayWidth(context),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: primeColor2
                                                        .withOpacity(0.3),
                                                    spreadRadius: 1,
                                                    blurRadius: 10,
                                                  )
                                                ],
                                              ),
                                              child: InkWell(
                                                onTap: () {
                                                  selectFile();
                                                },
                                                child: pickedFile == null
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(
                                                              Icons.camera,
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.3),
                                                              size: 100,
                                                            ),
                                                            const SizedBox(
                                                                height: 10),
                                                            Text(
                                                              "Front Picture",
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.5),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    : Container(
                                                        color: Colors.blue[100],
                                                        child: Image.file(
                                                          File(pickedFile!
                                                              .path!),
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ),
                                              ),
                                            ),
                                          ),
                                        ),
                              const SizedBox(height: 30),
                              Center(
                                child: MaterialButton(
                                  minWidth: displayWidth(context) / 1.3,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  color: purpleColor,
                                  onPressed: uploadFile,
                                  child: const Text(
                                    "Save",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              "Enter Account Details",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text(
                                  "Account Type",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          showSavingsAccount = true;
                                          showCurrentAccount = false;
                                          accountType = 'Savings';
                                        });
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                3.5,
                                        decoration: BoxDecoration(
                                          color: showSavingsAccount
                                              ? primeColor2
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              blurRadius: 10,
                                              spreadRadius: 1,
                                            )
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Text(
                                            "Savings",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: showSavingsAccount
                                                    ? Colors.white
                                                    : Colors.black),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          showSavingsAccount = false;
                                          showCurrentAccount = true;
                                          accountType = 'Current';
                                        });
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                3.5,
                                        decoration: BoxDecoration(
                                          color: showCurrentAccount
                                              ? primeColor2
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              blurRadius: 10,
                                              spreadRadius: 1,
                                            )
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Text(
                                            "Current",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: showCurrentAccount
                                                    ? Colors.white
                                                    : Colors.black),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Bank Name",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 10,
                                        spreadRadius: 1,
                                      )
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 2,
                                    ),
                                    child: TextField(
                                      controller: bankNameController,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Name on Account",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 10,
                                        spreadRadius: 1,
                                      )
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 2,
                                    ),
                                    child: TextField(
                                      controller: accountNameController,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Account Number",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 10,
                                        spreadRadius: 1,
                                      )
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 2,
                                    ),
                                    child: TextField(
                                      controller: accoutnNumberController,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Confirm Account Number",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 10,
                                        spreadRadius: 1,
                                      )
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 2,
                                    ),
                                    child: TextFormField(
                                      obscureText: true,
                                      controller:
                                          confirmAccountNumberController,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                      validator: (value) {
                                        if (value !=
                                            accoutnNumberController.text) {
                                          return "Account number doesn't match. Please check";
                                        }
                                        return null;
                                      },
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "IFSC Code",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 10,
                                        spreadRadius: 1,
                                      )
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 2,
                                    ),
                                    child: TextField(
                                      controller: ifscNumberController,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            Center(
                              child: MaterialButton(
                                minWidth: displayWidth(context) / 1.3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                color: purpleColor,
                                onPressed: () {
                                  if (confirmAccountNumberController
                                          .text.isNotEmpty &&
                                      accoutnNumberController.text.isNotEmpty &&
                                      bankNameController.text.isNotEmpty &&
                                      accountNameController.text.isNotEmpty &&
                                      ifscNumberController.text.isNotEmpty &&
                                      accountType.isNotEmpty) {
                                    updateAccount();
                                    alertDialogWidget(
                                      context,
                                      primeColor2,
                                      'Bank details updated successfully',
                                    );
                                  } else {
                                    alertDialogWidget(
                                      context,
                                      primeColor,
                                      'Please fill all fields to continue',
                                    );
                                  }
                                },
                                child: const Text(
                                  "Save",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
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
    );
  }
}
