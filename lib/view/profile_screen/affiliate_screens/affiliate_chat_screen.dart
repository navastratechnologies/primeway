import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:primewayskills_app/controllers/notification_controller.dart';
import 'package:primewayskills_app/view/helpers/colors.dart';

class AffiliateChatScreen extends StatefulWidget {
  final String myNumber, userNumber, userName;
  const AffiliateChatScreen({
    super.key,
    required this.myNumber,
    required this.userNumber,
    required this.userName,
  });

  @override
  State<AffiliateChatScreen> createState() => _AffiliateChatScreenState();
}

class _AffiliateChatScreenState extends State<AffiliateChatScreen> {
  TextEditingController msgController = TextEditingController();

  String getCombinedPhones() {
    List<String> emails = [widget.myNumber, widget.userNumber];
    emails.sort(); // Sort the emails alphabetically
    return '${emails[0]}-${emails[1]}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userName),
        backgroundColor: primeColor2,
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('chats')
                    .doc(getCombinedPhones())
                    .collection('chat_collection')
                    .orderBy('date_time', descending: true)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      shrinkWrap: true,
                      reverse: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot documentSnapshot =
                            snapshot.data!.docs[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 10,
                          ),
                          child: Wrap(
                            children: [
                              Align(
                                alignment:
                                    documentSnapshot['email'] == widget.myNumber
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: documentSnapshot['email'] ==
                                            widget.myNumber
                                        ? purpleColor
                                        : primeColor2,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    documentSnapshot['msg'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                  return Container();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: msgController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter message here",
                        ),
                      ),
                    ),
                    ActionChip(
                      disabledColor: purpleColor,
                      backgroundColor: purpleColor,
                      label: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection('chats')
                            .doc(getCombinedPhones())
                            .collection('chat_collection')
                            .add(
                          {
                            'msg': msgController.text,
                            'email': widget.myNumber,
                            'date_time': DateTime.now().toString(),
                          },
                        );
                        setState(
                          () {
                            msgController.clear();
                          },
                        );
                        FirebaseFirestore.instance
                            .collection('user_token')
                            .doc(widget.userNumber)
                            .get()
                            .then(
                          (value) {
                            sendPushMessage(
                              value.get('token'),
                              msgController.text,
                              "New Message!",
                            );
                          },
                        );
                      },
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
