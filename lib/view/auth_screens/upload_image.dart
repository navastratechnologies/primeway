import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../dashboard/dashboard.dart';
import '../helpers/colors.dart';

class UplodeImage extends StatefulWidget {
  final String phoneNumber;
  const UplodeImage({super.key, required this.phoneNumber});

  @override
  State<UplodeImage> createState() => _UplodeImageState();
}

class _UplodeImageState extends State<UplodeImage> {
  // PlatformFile? pickedFile;
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
        .update({
      'profile_pic': urlDownload.toString(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(children: [
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
                height: MediaQuery.of(context).size.height / 4.5,
              ),
              Center(
                child: Container(
                  width: 180,
                  height: 180,
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      image == null
                          ? Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.1)),
                                ],
                                shape: BoxShape.circle,

                                // image: DecorationImage(
                                //   image: NetworkImage(),
                                //   fit: BoxFit.cover,
                                // ),
                              ),
                              child: Icon(
                                Icons.add_a_photo,
                                color: Colors.black.withOpacity(0.3),
                                size: 80,
                              ),
                            )
                          : Container(
                              color: Colors.blue[100],
                              child: Image.file(
                                File(image!.path),
                                width: 140,
                                height: 140,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 150),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      pickImage(ImageSource.gallery);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text(
                        "Gallery",
                        style: TextStyle(color: primeColor, fontSize: 18),
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
                      pickImage(ImageSource.camera);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text(
                        "camera",
                        style: TextStyle(color: primeColor2, fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 70,
              ),
              Center(
                child: InkWell(
                  onTap: () {
                    uploadFile();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Dashboard(),
                      ),
                    );
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
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
