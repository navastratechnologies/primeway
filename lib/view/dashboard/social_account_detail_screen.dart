// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_insta/flutter_insta.dart';
import 'package:primewayskills_app/constants.dart';
import 'package:primewayskills_app/view/dashboard/campaign.dart';
import 'package:primewayskills_app/view/helpers/colors.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewClass extends StatefulWidget {
  final String userNumber, url, linkType;
  const WebViewClass({
    super.key,
    required this.userNumber,
    required this.url,
    required this.linkType,
  });

  @override
  _WebViewClassState createState() => _WebViewClassState();
}

class _WebViewClassState extends State<WebViewClass> {
  FlutterInsta flutterInsta = FlutterInsta();

  Future instagramDetails() async {
    String profileId =
        widget.url.split("com/").elementAt(1).replaceAll(" ", "");
    flutterInsta.getProfileData(profileId).then((value) {
      setState(() {
        FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userNumber)
            .update({
          'instagram_followers': flutterInsta.followers.toString(),
          'instagram_username': profileId,
        });
        log('instagram data is ${flutterInsta.followers.toString()}');
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CampaingnScreen(),
        ),
      );
    });
  }

  Future youtubeDetails() async {
    String channelId = widget.url.split("channel/").elementAt(1);

    String apiurl =
        "https://www.googleapis.com/youtube/v3/channels?part=snippet&id=$channelId&key=$youtubeApiKey";
    try {
      var response = await http.get(
        Uri.parse(apiurl),
      );

      if (response.statusCode == 200) {
        setState(() {
          Map<String, dynamic> youtubeData = json.decode(response.body);
          FirebaseFirestore.instance
              .collection('users')
              .doc(widget.userNumber)
              .update({
            'youtube_subscribers': youtubeData["items"][0]['snippet']
                ['subscriberCount'],
            'youtube_username': channelId,
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CampaingnScreen(),
            ),
          );
          log('youtube data is ${widget.url} ${youtubeData["items"][0]['snippet']['subscriberCount']}');
        });
      }
    } on Exception {
      // log('exception is $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black.withOpacity(0.6),
        ),
        backgroundColor: whiteColor,
        title: Text(
          widget.linkType == "youtube"
              ? 'Is this your channel?'
              : 'Is this your profile?',
          style: TextStyle(
            fontSize: maxSize,
            color: Colors.black.withOpacity(0.6),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: WebView(
        initialUrl: widget.url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: whiteColor,
          boxShadow: [
            BoxShadow(
              color: primeColor2.withOpacity(0.4),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        height: 60,
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: () {
                if (widget.linkType == "insta") {
                  instagramDetails();
                } else {
                  youtubeDetails();
                }
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width / 5,
                decoration: BoxDecoration(
                  color: primeColor2,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Text(
                  "Yes",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width / 5,
              decoration: BoxDecoration(
                color: purpleColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Text(
                "No",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
