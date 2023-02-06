import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:primewayskills_app/view/collab_apply_screens/task_completion_screen.dart';
import 'package:primewayskills_app/view/dashboard/homePage_screens/collaboration_internal_screen.dart';
import 'package:primewayskills_app/view/helpers/colors.dart';
import 'package:primewayskills_app/view/helpers/loader.dart';
import 'package:primewayskills_app/view/helpers/responsive_size_helper.dart';

class ViewBriefScreen extends StatefulWidget {
  final String userNumber, collabId;
  const ViewBriefScreen({
    super.key,
    required this.userNumber,
    required this.collabId,
  });

  @override
  State<ViewBriefScreen> createState() => _ViewBriefScreenState();
}

class _ViewBriefScreenState extends State<ViewBriefScreen> {
  String data = """""";
  String title = "Instructions";
  String instructionData = """""";

  Future getInstructionsData() async {
    FirebaseFirestore.instance
        .collection('collaboration')
        .doc(widget.collabId)
        .get()
        .then((value) {
      setState(() {
        data = value.get('instructions');
      });
    });
  }

  @override
  void initState() {
    getInstructionsData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('collaboration')
          .doc(widget.collabId)
          .collection('deliverables')
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        if (streamSnapshot.hasData) {
          return WillPopScope(
            onWillPop: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CollaborationInternalScreen(
                    userNumber: widget.userNumber,
                    collabId: widget.collabId,
                  ),
                ),
              );
              return false;
            },
            child: Scaffold(
              appBar: AppBar(
                elevation: 0.2,
                iconTheme: IconThemeData(
                  color: Colors.black.withOpacity(0.6),
                ),
                backgroundColor: whiteColor,
                title: Text(
                  'Breif',
                  style: TextStyle(
                    fontSize: maxSize,
                    color: Colors.black.withOpacity(0.6),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                leading: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CollaborationInternalScreen(
                          userNumber: widget.userNumber,
                          collabId: widget.collabId,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                  ),
                ),
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
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
                    height: 60,
                    padding: const EdgeInsets.all(6),
                    width: displayWidth(context),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 4,
                            ),
                            child: InkWell(
                              onTap: () => setState(() {
                                getInstructionsData();
                                title = 'Instructions';
                              }),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: title == "Instructions"
                                      ? primeColor2
                                      : whiteColor,
                                  border: Border.all(color: primeColor2),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Center(
                                  child: Text(
                                    'Instructions',
                                    style: TextStyle(
                                      color: title == "Instructions"
                                          ? whiteColor
                                          : Colors.black.withOpacity(0.6),
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: streamSnapshot.data!.docs.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              final DocumentSnapshot documentSnapshot =
                                  streamSnapshot.data!.docs[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 4,
                                ),
                                child: InkWell(
                                  onTap: () => setState(() {
                                    data = documentSnapshot['data'];
                                    title = documentSnapshot['title'];
                                  }),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: title == documentSnapshot['title']
                                          ? primeColor2
                                          : whiteColor,
                                      border: Border.all(color: primeColor2),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Center(
                                      child: Text(
                                        documentSnapshot['title'],
                                        style: TextStyle(
                                          color: title ==
                                                  documentSnapshot['title']
                                              ? whiteColor
                                              : Colors.black.withOpacity(0.6),
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: HtmlWidget(
                      data,
                    ),
                  ),
                ],
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
                    color: purpleColor,
                    padding: const EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskCompletionScreen(
                          userNumber: widget.userNumber,
                          collabId: widget.collabId,
                        ),
                      ),
                    ),
                    child: const Text(
                      'Submit Task',
                      style: TextStyle(
                        fontSize: 16,
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
        return const Scaffold(body: LoaderWidget());
      },
    );
  }
}
