import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:primewayskills_app/view/helpers/colors.dart';

class CollaborationScreen extends StatefulWidget {
  const CollaborationScreen({Key? key}) : super(key: key);

  @override
  State<CollaborationScreen> createState() => _CollaborationScreenState();
}

class _CollaborationScreenState extends State<CollaborationScreen> {
  bool explorePage = false;
  bool appliedPage = false;
  bool shortlistedPage = false;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: whiteColor,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: 10),
                Container(
                  height: 50,
                  width: width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            explorePage = true;
                            appliedPage = false;
                            shortlistedPage = false;
                          });
                          log('log is $explorePage $appliedPage $shortlistedPage');
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            color: explorePage ? primeColor : whiteColor,
                            border: Border.all(
                              width: 2,
                              color: primeColor,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Explore | 148',
                            style: TextStyle(
                              color: explorePage ? whiteColor : primeColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            explorePage = false;
                            appliedPage = true;
                            shortlistedPage = false;
                          });
                          log('log is $explorePage $appliedPage $shortlistedPage');
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            color: appliedPage ? primeColor : whiteColor,
                            border: Border.all(
                              width: 2,
                              color: primeColor,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Applied',
                            style: TextStyle(
                              color: appliedPage ? whiteColor : primeColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            explorePage = false;
                            appliedPage = false;
                            shortlistedPage = true;
                          });
                          log('log is $explorePage $appliedPage $shortlistedPage');
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            color: shortlistedPage ? primeColor : whiteColor,
                            border: Border.all(
                              width: 2,
                              color: primeColor,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Shortlisted',
                            style: TextStyle(
                              color: shortlistedPage ? whiteColor : primeColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(12),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        shadowColor: Colors.black.withOpacity(0.4),
                        color: whiteColor,
                        elevation: 5,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 10,
                                  width: 4,
                                  decoration: const BoxDecoration(
                                    color: Colors.green,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                const Text(
                                  'Applications Open',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(14),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    height: 50,
                                    width: width / 3.5,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black.withOpacity(0.2),
                                      ),
                                    ),
                                    child: Image(
                                      image: NetworkImage(
                                        'https://images.unsplash.com/photo-1523800378286-dae1f0dae656?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1552&q=80',
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: width / 2.5,
                                        child: Text(
                                          'Campaign - Name shown here',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      SizedBox(
                                        width: width / 2,
                                        child: Text(
                                          'Paid | 1 to 300M+ followers',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13,
                                            color:
                                                Colors.black.withOpacity(0.3),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      FaIcon(
                                        FontAwesomeIcons.instagram,
                                        color: primeColor,
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 50,
                              width: width,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.3),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Apply to get Shortlisted',
                                    style: TextStyle(fontSize: minSize - 1),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.arrow_forward_ios,
                                        color: whiteColor,
                                        size: 10,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
