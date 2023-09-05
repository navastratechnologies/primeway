import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:primewayskills_app/view/helpers/colors.dart';
import 'package:primewayskills_app/view/helpers/loader.dart';
import 'package:primewayskills_app/view/helpers/responsive_size_helper.dart';

class TaskCompletionScreen extends StatefulWidget {
  final String userNumber, collabId;
  const TaskCompletionScreen({
    super.key,
    required this.userNumber,
    required this.collabId,
  });

  @override
  State<TaskCompletionScreen> createState() => _TaskCompletionScreenState();
}

class _TaskCompletionScreenState extends State<TaskCompletionScreen> {
  bool tileExpanded = false;
  bool showLoader = false;
  String tileIndex = '';

  TextEditingController taskUrlController = TextEditingController();
  TextEditingController taskTextController = TextEditingController();

  File? image;
  UploadTask? uploadTask;

  Future pickImage(docId) async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
      });
      uploadFile(docId);
    } on PlatformException catch (e) {
      log('Failed to pick image: $e');
    }
  }

  Future uploadFile(docId) async {
    final path = 'tasks/${widget.userNumber}/$image';
    final file = File(image!.path);

    final ref = FirebaseStorage.instance.ref().child(path);
    setState(() {
      uploadTask = ref.putFile(file);
      showLoader = true;
    });

    final snapshot = await uploadTask!.whenComplete(() {});

    final urlDownload = await snapshot.ref.getDownloadURL();
    log('Download link : $urlDownload');

    setState(() {
      uploadTask = null;
    });

    FirebaseFirestore.instance
        .collection('collaboration')
        .doc(widget.collabId)
        .collection('users')
        .doc(widget.userNumber)
        .update(
      {
        'task_uploaded': 'true',
      },
    );

    FirebaseFirestore.instance
        .collection('collaboration')
        .doc(widget.collabId)
        .collection('users')
        .doc(widget.userNumber)
        .collection('tasks')
        .doc(docId)
        .update(
      {
        'task': urlDownload.toString(),
        'status': 'uploaded',
        'task_text': taskTextController.text,
        'task_url': taskUrlController.text,
      },
    ).then((value) {
      setState(() {
        showLoader = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            elevation: 0.2,
            iconTheme: IconThemeData(
              color: Colors.black.withOpacity(0.6),
            ),
            backgroundColor: whiteColor,
            title: Text(
              'Tasks',
              style: TextStyle(
                fontSize: maxSize,
                color: Colors.black.withOpacity(0.6),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  width: displayWidth(context),
                  decoration: BoxDecoration(
                    color: purpleColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('collaboration')
                            .doc(widget.collabId)
                            .collection('users')
                            .doc(widget.userNumber)
                            .collection('tasks')
                            .snapshots(),
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                          if (streamSnapshot.hasData) {
                            return taskCountWidget(
                              streamSnapshot.data!.docs.length.toString(),
                              'Total',
                            );
                          }
                          return taskCountWidget('0', 'Total');
                        },
                      ),
                      customDivider(),
                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('collaboration')
                            .doc(widget.collabId)
                            .collection('users')
                            .doc(widget.userNumber)
                            .collection('tasks')
                            .where('status', isEqualTo: 'uploaded')
                            .snapshots(),
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                          if (streamSnapshot.hasData) {
                            return taskCountWidget(
                              streamSnapshot.data!.docs.length.toString(),
                              'Completed',
                            );
                          }
                          return taskCountWidget('0', 'Completed');
                        },
                      ),
                      customDivider(),
                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('collaboration')
                            .doc(widget.collabId)
                            .collection('users')
                            .doc(widget.userNumber)
                            .collection('tasks')
                            .where('status', isEqualTo: 'verified')
                            .snapshots(),
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                          if (streamSnapshot.hasData) {
                            return taskCountWidget(
                              streamSnapshot.data!.docs.length.toString(),
                              'Verified',
                            );
                          }
                          return taskCountWidget('0', 'Verified');
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: displayHeight(context) / 1.26,
                width: displayWidth(context),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('collaboration')
                      .doc(widget.collabId)
                      .collection('users')
                      .doc(widget.userNumber)
                      .collection('tasks')
                      .snapshots(),
                  builder:
                      (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                    if (streamSnapshot.hasData) {
                      return ListView.builder(
                        itemCount: streamSnapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot documentSnapshot =
                              streamSnapshot.data!.docs[index];
                          taskTextController.text =
                              documentSnapshot['task_text'];
                          taskUrlController.text = documentSnapshot['task_url'];
                          return Theme(
                            data: ThemeData()
                                .copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              title: Text(
                                documentSnapshot['title'],
                                style: TextStyle(
                                  color: tileIndex == index.toString()
                                      ? primeColor2
                                      : Colors.black.withOpacity(0.4),
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                              trailing: Icon(
                                tileIndex == index.toString()
                                    ? Icons.keyboard_arrow_up_rounded
                                    : Icons.keyboard_arrow_down_rounded,
                                color: tileIndex == index.toString()
                                    ? primeColor2
                                    : Colors.black.withOpacity(0.4),
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Center(
                                    child: Container(
                                      width: displayWidth(context) / 1.2,
                                      height: displayHeight(context) / 3,
                                      decoration: BoxDecoration(
                                        color: whiteColor,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: primeColor.withOpacity(0.1),
                                            blurRadius: 10,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      child: InkWell(
                                        onTap: () {
                                          pickImage(documentSnapshot.id);
                                        },
                                        child: Container(
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
                                          child: documentSnapshot['task']
                                                  .toString()
                                                  .isEmpty
                                              ? Icon(
                                                  Icons.add_rounded,
                                                  color: purpleColor,
                                                  size: 80,
                                                )
                                              : Image.network(
                                                  documentSnapshot['task'],
                                                  fit: BoxFit.cover,
                                                ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Container(
                                    width: displayWidth(context) / 1.2,
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: whiteColor,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: primeColor.withOpacity(0.1),
                                          blurRadius: 10,
                                          spreadRadius: 1,
                                        ),
                                      ],
                                    ),
                                    child: TextFormField(
                                      controller: taskUrlController,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Enter Task URL here if any',
                                        hintStyle: TextStyle(
                                          color: Colors.black.withOpacity(0.2),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Container(
                                    width: displayWidth(context) / 1.2,
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: whiteColor,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: primeColor.withOpacity(0.1),
                                          blurRadius: 10,
                                          spreadRadius: 1,
                                        ),
                                      ],
                                    ),
                                    child: TextFormField(
                                      controller: taskTextController,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText:
                                            'Enter additional text here if any',
                                        hintStyle: TextStyle(
                                          color: Colors.black.withOpacity(0.2),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                MaterialButton(
                                  color: purpleColor,
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection('collaboration')
                                        .doc(widget.collabId)
                                        .collection('users')
                                        .doc(widget.userNumber)
                                        .collection('tasks')
                                        .doc(documentSnapshot.id)
                                        .update(
                                      {
                                        'status': 'uploaded',
                                        'task_text': taskTextController.text,
                                        'task_url': taskUrlController.text,
                                      },
                                    ).then((value) {
                                      setState(() {
                                        showLoader = false;
                                        taskTextController.clear();
                                        taskUrlController.clear();
                                      });
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: primeColor2,
                                        content: Text(
                                          'Task Uploaded Successfully',
                                          style: TextStyle(
                                            color: whiteColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Submit This Task',
                                    style: TextStyle(
                                      color: whiteColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                              onExpansionChanged: (value) {
                                setState(
                                  () {
                                    tileExpanded = value;
                                    if (tileIndex == index.toString()) {
                                      tileIndex = '';
                                      taskUrlController.clear();
                                      taskTextController.clear();
                                    } else {
                                      tileIndex = index.toString();
                                      taskUrlController.clear();
                                      taskTextController.clear();
                                    }
                                  },
                                );
                              },
                            ),
                          );
                        },
                      );
                    }
                    return Container();
                  },
                ),
              ),
            ],
          ),
        ),
        showLoader ? const LoaderWidget() : Container(),
      ],
    );
  }

  customDivider() {
    return Container(
      height: 30,
      width: 1.5,
      decoration: BoxDecoration(
        color: whiteColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  taskCountWidget(head, subhead) {
    return SizedBox(
      width: 70,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            head,
            style: TextStyle(
              color: whiteColor.withOpacity(0.6),
              fontSize: 16,
              letterSpacing: 1,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            subhead,
            style: TextStyle(
              fontSize: 12,
              letterSpacing: 1,
              fontWeight: FontWeight.bold,
              color: whiteColor,
            ),
          ),
        ],
      ),
    );
  }
}
