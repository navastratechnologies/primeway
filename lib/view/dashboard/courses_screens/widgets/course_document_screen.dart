// ignore_for_file: unused_field

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:primewayskills_app/view/helpers/responsive_size_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class CourseDocumentScreen extends StatefulWidget {
  final String courseId;
  final String documentId;
  final String documentTitle;
  final String documentUrl;
  final String documentDescription;
  final String userNumber;
  final String userName;
  final String userAddress;
  final String userProfileImage;
  final String userPayment;
  final String userEmail;
  final String userWalletId;
  final String courseName;

  const CourseDocumentScreen({
    super.key,
    required this.courseId,
    required this.documentId,
    required this.documentTitle,
    required this.documentUrl,
    required this.documentDescription,
    required this.userNumber,
    required this.userName,
    required this.userAddress,
    required this.userProfileImage,
    required this.userPayment,
    required this.userEmail,
    required this.userWalletId,
    required this.courseName,
  });

  @override
  State<CourseDocumentScreen> createState() => _CourseDocumentScreenState();
}

class _CourseDocumentScreenState extends State<CourseDocumentScreen> {
  bool showControls = true;

  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  Future<void> _launchUrl(url) async {
    if (!await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalNonBrowserApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: Stack(
      //   children: <Widget>[
      //     PDFView(
      //       filePath:
      //           "https://dominatortechnology.com/demo_app/543_27997_AOA2.pdf",
      //       enableSwipe: true,
      //       swipeHorizontal: true,
      //       autoSpacing: false,
      //       pageFling: true,
      //       pageSnap: true,
      //       defaultPage: currentPage!,
      //       fitPolicy: FitPolicy.BOTH,
      //       preventLinkNavigation:
      //           false, // if set to true the link is handled in flutter
      //       onRender: (pages) {
      //         setState(() {
      //           pages = pages;
      //           isReady = true;
      //         });
      //       },
      //       onError: (error) {
      //         setState(() {
      //           errorMessage = error.toString();
      //         });
      //         print(error.toString());
      //       },
      //       onPageError: (page, error) {
      //         setState(() {
      //           errorMessage = '$page: ${error.toString()}';
      //         });
      //         print('$page: ${error.toString()}');
      //       },
      //       onViewCreated: (PDFViewController pdfViewController) {
      //         _controller.complete(pdfViewController);
      //       },
      //       onLinkHandler: (String? uri) {
      //         print('goto uri: $uri');
      //       },
      //       onPageChanged: (int? page, int? total) {
      //         print('page change: $page/$total');
      //         setState(() {
      //           currentPage = page;
      //         });
      //       },
      //     ),
      //     errorMessage.isEmpty
      //         ? !isReady
      //             ? const Center(
      //                 child: CircularProgressIndicator(),
      //               )
      //             : Container()
      //         : Center(
      //             child: Text(errorMessage),
      //           )
      //   ],
      // ),

      // body: Center(
      //   child: Container(
      //     child: pdfviewer(
      //       document: pdfwidgets.Document.openData(Uint8List.fromList(
      //         pdfwidgets.PdfUtils.hexToBytes(''),
      //       )),
      //     ),
      //   ),
      // ),
      // body: HtmlWidget(
      //   '<iframe width="560" height="315" src="https://dominatortechnology.com/demo_app/543_27997_AOA2.pdf"></iframe>',
      // ),
      body: SizedBox(
        height: displayHeight(context),
        width: displayWidth(context),
        child: InkWell(
          onTap: () {
            _launchUrl(widget.documentUrl);
            // canLaunchUrl(
            //   Uri.parse(
            //       'https://dominatortechnology.com/demo_app/543_27997_AOA2.pdf'),
            // );
          },
          child: const Center(
            child: Text('data'),
          ),
        ),
        // child: const WebView(
        //   initialUrl:
        //       "https://dominatortechnology.com/demo_app/543_27997_AOA2.pdf",
        //   javascriptMode: JavascriptMode.unrestricted,
        //   debuggingEnabled: true,
        // ),
      ),
      // body: SingleChildScrollView(
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [

      //       SizedBox(
      //         height: displayHeight(context) / 3,
      //         width: displayWidth(context),
      //         child: HtmlWidget(widget.documentUrl),
      //       ),

      //       Padding(
      //         padding:
      //             const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
      //         child: Text(
      //           widget.documentTitle,
      //           style: const TextStyle(
      //             fontWeight: FontWeight.bold,
      //             fontSize: 18,
      //           ),
      //         ),
      //       ),
      //       DefaultTabController(
      //         length: 2,
      //         initialIndex: 0,
      //         child: SizedBox(
      //           height: MediaQuery.of(context).size.height / 1.6,
      //           width: MediaQuery.of(context).size.width,
      //           child: Column(
      //             children: [
      //               TabBar(
      //                 indicatorColor: primeColor,
      //                 labelColor: Colors.black,
      //                 tabs: const [
      //                   Tab(
      //                     text: 'Discussions',
      //                   ),
      //                   Tab(
      //                     text: 'Description',
      //                   ),
      //                 ],
      //               ),
      //               Expanded(
      //                 child: TabBarView(
      //                   children: [
      //                     CourseDiscussionScreen(
      //                       courseId: widget.courseId,
      //                       courseName: widget.courseName,
      //                       userAddress: widget.userAddress,
      //                       userEmail: widget.userEmail,
      //                       userName: widget.userName,
      //                       userNumber: widget.userNumber,
      //                       userPayment: widget.userPayment,
      //                       userProfileImage: widget.userProfileImage,
      //                       userWalletId: widget.userWalletId,
      //                     ),
      //                     Padding(
      //                       padding: const EdgeInsets.all(20),
      //                       child: Text(widget.documentDescription),
      //                     ),
      //                   ],
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
