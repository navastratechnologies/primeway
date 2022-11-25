import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../helpers/colors.dart';

class CampaingnScreen extends StatefulWidget {
  final String userNumber;
  final String userName;
  final String userProfileImage;
  final String instagramFollowers;
  final String instagramUserName;
  final String instagrsmBio;
  final String instagramImage;
  final String instagramFolowing;
  final String instagramWebsite;

  const CampaingnScreen(
      {super.key,
      required this.userName,
      required this.userProfileImage,
      required this.userNumber,
      required this.instagramFollowers,
      required this.instagramUserName,
      required this.instagrsmBio,
      required this.instagramImage,
      required this.instagramFolowing,
      required this.instagramWebsite});

  @override
  State<CampaingnScreen> createState() => _CampaingnScreenState();
}

class _CampaingnScreenState extends State<CampaingnScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: MaterialButton(
                      color: purpleColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "SKIP",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 1.1,
                  width: MediaQuery.of(context).size.width / 1.1,
                  child: Lottie.asset(
                    'assets/json/celebration.json',
                    fit: BoxFit.cover,
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
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.1)),
                                ],
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: NetworkImage(widget.instagramImage),
                                  fit: BoxFit.cover,
                                ),
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
                      height: 40,
                    ),
                    Text(
                      widget.instagramUserName,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black.withOpacity(0.5)),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    const Text(
                      "Campaign Unlocked",
                      style:
                          TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    const Text(
                      "Congratulations!",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: Text(
                        "you have succesfully unlocked Campaigns. Check now or find later",
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.black.withOpacity(0.5)),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 160,
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width / 1.3,
                      decoration: BoxDecoration(
                        color: primeColor2,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Text(
                        "View Campaign's",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
