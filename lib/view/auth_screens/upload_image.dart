import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:primewayskills_app/view/appbar_screens/profile_edit_screen.dart';
import 'package:primewayskills_app/view/helpers/loader.dart';
import 'package:primewayskills_app/view/helpers/responsive_size_helper.dart';

import '../dashboard/dashboard.dart';
import '../helpers/colors.dart';

class UplodeImage extends StatefulWidget {
  final String phoneNumber;
  final String pageType;
  const UplodeImage({
    super.key,
    required this.phoneNumber,
    required this.pageType,
  });

  @override
  State<UplodeImage> createState() => _UplodeImageState();
}

class _UplodeImageState extends State<UplodeImage> {
  String uploadedImage = '';
  bool picFound = false;
  bool showLoader = false;
  UploadTask? uploadTask;
  File? image;

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
      });
    } on PlatformException catch (e) {
      log('Failed to pick image: $e');
    }
  }

  Future uploadFile() async {
    final path = 'users/${widget.phoneNumber}/$image';
    final file = File(image!.path);

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
        .doc(widget.phoneNumber)
        .update(
      {
        'profile_pic': urlDownload.toString(),
      },
    ).then((value) {
      if (widget.pageType == 'new') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Dashboard(),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileEditScreen(
              userNumber: widget.phoneNumber,
            ),
          ),
        );
      }
    });
  }

  Future getProfilePic() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.phoneNumber)
        .get()
        .then(
      (value) {
        setState(
          () {
            uploadedImage = value.get('profile_pic');
            if (uploadedImage.isNotEmpty) {
              picFound = true;
            }
          },
        );
      },
    );
  }

  @override
  void initState() {
    getProfilePic();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 3,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        primeColor,
                        primeColor.withOpacity(0.1),
                        primeColor.withOpacity(0.3),
                      ],
                    ),
                  ),
                  child: AppBar(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    iconTheme: IconThemeData(
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 6,
                    ),
                    Center(
                      child: Container(
                        width: displayWidth(context) / 1.2,
                        height: displayHeight(context) / 2,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              primeColor.withOpacity(0.1),
                              primeColor,
                              primeColor.withOpacity(0.3),
                            ],
                          ),
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(40),
                            bottomLeft: Radius.circular(40),
                          ),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: picFound
                            ? Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.blue[100],
                                  image: DecorationImage(
                                    image: NetworkImage(uploadedImage),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Icon(
                                    Icons.add_a_photo,
                                    color: whiteColor,
                                    size: 40,
                                  ),
                                ),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  image == null
                                      ? Container(
                                          width: displayWidth(context) / 1.5,
                                          height: displayHeight(context) / 2.5,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.1),
                                              ),
                                            ],
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.add_a_photo,
                                            color:
                                                Colors.black.withOpacity(0.3),
                                            size: 80,
                                          ),
                                        )
                                      : Container(
                                          color: Colors.blue[100],
                                          child: Image.file(
                                            File(image!.path),
                                            width: displayWidth(context) / 1.5,
                                            height:
                                                displayHeight(context) / 2.5,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              picFound = false;
                            });
                            pickImage(ImageSource.gallery);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Text(
                              "Gallery",
                              style: TextStyle(
                                color: primeColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.6,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Container(
                          height: 40,
                          width: 1,
                          color: Colors.black.withOpacity(0.2),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              picFound = false;
                            });
                            pickImage(ImageSource.camera);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Text(
                              "camera",
                              style: TextStyle(
                                color: primeColor2,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.6,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            showLoader = true;
                          });
                          uploadFile();
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 1.5,
                          decoration: BoxDecoration(
                            color: purpleColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(15),
                            child: Text(
                              "Upload Profile Picture",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.4,
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
          ),
          showLoader ? const LoaderWidget() : Container(),
        ],
      ),
    );
  }
}
