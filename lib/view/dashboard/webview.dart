// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:primewayskills_app/view/dashboard/social_account.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../helpers/colors.dart';
import 'campaign.dart';

class WebViewClass extends StatefulWidget {
  final String instagramController;
  final String youtubeController;
  final String instagramUrl;
  final String youTubeUrl;
  const WebViewClass(
      {super.key,
      required this.instagramController,
      required this.youtubeController,
      required this.instagramUrl,
      required this.youTubeUrl});

  @override
  _WebViewClassState createState() => _WebViewClassState();
}

class _WebViewClassState extends State<WebViewClass> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  String instagram = '';
  String youTube = '';

  // Future<void> instagramConnect() async {
  //   final url = 'https://www.instagram.com/${widget.instagramController}';

  //   if (await canLaunchUrl(Uri.parse(url))) {
  //       await launchUrl(
  //         Uri.parse(url),
  //         mode: LaunchMode.inAppWebView,
  //       );
  //       log('Url is open');
  //     } else {
  //       log('There was a problem to open the url: $url');
  //   }
  // }

  // Future<void> youTubeConnect() async {
  //   final url = 'https://www.youtube.com/${widget.youtubeController}';

  //   if (await canLaunchUrl(Uri.parse(url))) {
  //     await launchUrl(
  //       Uri.parse(url),
  //     );
  //     log('Url is open');
  //   } else {
  //     log('There was a problem to open the url: $url');
  //   }
  // }

  @override
  void initState() {
    instagram = '${widget.instagramUrl}${widget.instagramController}';
    youTube = '${widget.youTubeUrl}${widget.youtubeController}';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Is this your account',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: WebView(
        initialUrl: widget.youtubeController == ''
            ? '${widget.instagramUrl}${widget.instagramController}'
            : '${widget.youTubeUrl}${widget.youtubeController}',
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      ),
      bottomNavigationBar: SizedBox(
        height: 60,
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CampaingnScreen(
                      instagram: instagram,
                      youTube: youTube,
                    ),
                  ),
                );
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
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SocialScreen(),
                  ),
                );
              },
              child: Container(
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
            ),
          ],
        ),
      ),
    );
  }
}
