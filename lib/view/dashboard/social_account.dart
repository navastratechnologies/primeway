import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:primewayskills_app/view/appbar_screens/profile_edit_screen.dart';

import '../helpers/colors.dart';
import 'social_account_detail_screen.dart';

class SocialScreen extends StatefulWidget {
  final String userNumber, userName, userProfileImage;

  const SocialScreen({
    super.key,
    required this.userNumber,
    required this.userName,
    required this.userProfileImage,
  });

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {
  TextEditingController instagramController = TextEditingController();
  TextEditingController youtubeController = TextEditingController();

  final instagram = 'https://www.instagram.com/';

  Future<bool> _onWillPop() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileEditScreen(
          userNumber: widget.userNumber,
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
        body: Center(
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 4,
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
                  leading: IconButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileEditScreen(
                          userNumber: widget.userNumber,
                        ),
                      ),
                    ),
                    icon: const Icon(
                      Icons.arrow_back,
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  const SizedBox(
                    height: 120,
                  ),
                  Center(
                    child: Container(
                      width: 130,
                      height: 130,
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
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(color: Colors.black.withOpacity(0.1)),
                              ],
                              // shape: BoxShape.circle,
                              // image: DecorationImage(
                              //   image: NetworkImage(widget.instagramImage),
                              //   fit: BoxFit.cover,
                              // ),
                            ),
                            child: Icon(
                              Icons.add_a_photo,
                              color: Colors.black.withOpacity(0.3),
                              size: 50,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    "Connect your world",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "with ours",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Link your social account and participate in",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                  ),
                  const Text(
                    "brand collaboration to earn reward.",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: primeColor2,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    spreadRadius: 1),
                              ],
                            ),
                            child: Icon(
                              Icons.local_library,
                              size: 30,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const Text(
                            "Learn From",
                            style: TextStyle(
                              fontSize: 11,
                            ),
                          ),
                          const Text(
                            "industry experts",
                            style: TextStyle(
                              fontSize: 11,
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: primeColor2,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    spreadRadius: 1),
                              ],
                            ),
                            child: Icon(
                              Icons.explore,
                              size: 30,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const Text(
                            "Explore",
                            style: TextStyle(
                              fontSize: 11,
                            ),
                          ),
                          const Text(
                            "Industries Trends",
                            style: TextStyle(
                              fontSize: 11,
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: primeColor2,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    spreadRadius: 1),
                              ],
                            ),
                            child: Icon(
                              Icons.workspaces,
                              size: 30,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const Text(
                            "Get",
                            style: TextStyle(
                              fontSize: 11,
                            ),
                          ),
                          const Text(
                            "Brand Collabs",
                            style: TextStyle(
                              fontSize: 11,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 70,
                  ),
                  InkWell(
                    onTap: () {
                      showModalBottomSheet<void>(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            // <-- SEE HERE
                            topLeft: Radius.circular(25.0),
                          ),
                        ),
                        builder: (BuildContext context) {
                          return Padding(
                            padding: MediaQuery.of(context).viewInsets,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                // borderRadius: BorderRadius.vertical(
                                //   top: Radius.circular(30),
                                // )
                              ),
                              height: 300,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      height: 50,
                                      width: MediaQuery.of(context).size.width /
                                          1.3,
                                      decoration: BoxDecoration(
                                        color: purpleColor,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Lottie.asset(
                                            'assets/json/instagram-icon.json',
                                            fit: BoxFit.cover,
                                          ),
                                          const Text(
                                            "CONNECT WITH INSTAGRAM",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(39),
                                      child: TextField(
                                        controller: instagramController,
                                        decoration: const InputDecoration(
                                          border: UnderlineInputBorder(),
                                          labelText: 'Enter your instagram id',
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        if (instagramController
                                            .text.isNotEmpty) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  WebViewClass(
                                                userNumber: widget.userNumber,
                                                url:
                                                    "$instagram${instagramController.text}",
                                                linkType: "insta",
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.3,
                                        decoration: BoxDecoration(
                                          color: primeColor2,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: const Text(
                                          "NEXT",
                                          style: TextStyle(
                                            fontSize: 22,
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
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width / 1.3,
                      decoration: BoxDecoration(
                        color: purpleColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Lottie.asset(
                            'assets/json/instagram-icon.json',
                            fit: BoxFit.cover,
                          ),
                          const Text(
                            "CONNECT WITH INSTAGRAM",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      showModalBottomSheet<void>(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            // <-- SEE HERE
                            topLeft: Radius.circular(25.0),
                          ),
                        ),
                        builder: (BuildContext context) {
                          return Padding(
                            padding: MediaQuery.of(context).viewInsets,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                // borderRadius: BorderRadius.vertical(
                                //   top: Radius.circular(30),
                                // )
                              ),
                              height: 300,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      height: 50,
                                      width: MediaQuery.of(context).size.width /
                                          1.3,
                                      decoration: BoxDecoration(
                                        color: primeColor2,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Lottie.asset(
                                            'assets/json/youtube.json',
                                            fit: BoxFit.cover,
                                          ),
                                          const Text(
                                            "CONNECT WITH YOUTUBE",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(39),
                                      child: TextField(
                                        controller: youtubeController,
                                        decoration: const InputDecoration(
                                          border: UnderlineInputBorder(),
                                          labelText:
                                              'Enter your Youtube channel link',
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        if (youtubeController.text.isNotEmpty) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  WebViewClass(
                                                userNumber: widget.userNumber,
                                                url: youtubeController.text,
                                                linkType: "youtube",
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.3,
                                        decoration: BoxDecoration(
                                          color: purpleColor,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: const Text(
                                          "NEXT",
                                          style: TextStyle(
                                            fontSize: 22,
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
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width / 1.3,
                      decoration: BoxDecoration(
                        color: primeColor2,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Lottie.asset(
                            'assets/json/youtube.json',
                            fit: BoxFit.cover,
                          ),
                          const Text(
                            "CONNECT WITH YOUTUBE",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
