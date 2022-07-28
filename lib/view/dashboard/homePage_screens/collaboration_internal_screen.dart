import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:primewayskills_app/view/complete_profile_screens/complete_profile_screen.dart';
import 'package:primewayskills_app/view/helpers/colors.dart';
import 'package:primewayskills_app/view/helpers/helping_widgets.dart';

class CollaborationInternalScreen extends StatefulWidget {
  final String heading, image, paragraph, followerDetails;
  const CollaborationInternalScreen({
    Key? key,
    required this.heading,
    required this.image,
    required this.paragraph,
    required this.followerDetails,
  }) : super(key: key);

  @override
  State<CollaborationInternalScreen> createState() =>
      _CollaborationInternalScreenState();
}

class _CollaborationInternalScreenState
    extends State<CollaborationInternalScreen> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primeColor,
        title: Text(
          widget.heading,
          style: TextStyle(
            fontSize: maxSize,
            color: whiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: height / 4,
              width: width,
              decoration: BoxDecoration(
                color: primeColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                image: DecorationImage(
                  image: NetworkImage(
                    widget.image,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Applications Open',
                        style: TextStyle(
                          color: whiteColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.instagram,
                            color: primeColor,
                          ),
                          SizedBox(width: 10),
                          Text(
                            widget.followerDetails,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 35,
                        child: FaIcon(
                          FontAwesomeIcons.shareNodes,
                          color: primeColor,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    widget.heading,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: maxSize,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    widget.paragraph,
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.4),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 30),
                  headingWidgetMethod('Application Criteria'),
                  SizedBox(height: 20),
                  Container(
                    width: width,
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black.withOpacity(0.2),
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.peopleGroup,
                              color: Colors.black.withOpacity(0.4),
                              size: 17,
                            ),
                            SizedBox(width: 20),
                            Text(
                              widget.followerDetails,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green,
                          ),
                          child: Icon(
                            Icons.check,
                            color: whiteColor,
                            size: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    width: width,
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black.withOpacity(0.2),
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 35,
                              child: FaIcon(
                                FontAwesomeIcons.person,
                                color: Colors.black.withOpacity(0.4),
                                size: 17,
                              ),
                            ),
                            Text(
                              'Health, Food, Travel',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: primeColor,
                          ),
                          child: Icon(
                            Icons.close,
                            color: whiteColor,
                            size: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    width: width,
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black.withOpacity(0.2),
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 35,
                              child: FaIcon(
                                FontAwesomeIcons.language,
                                color: Colors.black.withOpacity(0.4),
                                size: 17,
                              ),
                            ),
                            Text(
                              'English, Hindi',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: primeColor,
                          ),
                          child: Icon(
                            Icons.close,
                            color: whiteColor,
                            size: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  headingWidgetMethod('Additional Requirements'),
                  SizedBox(height: 20),
                  listOrderWidget('Foodie'),
                  SizedBox(height: 14),
                  listOrderWidget('Overseas Students'),
                  SizedBox(height: 14),
                  listOrderWidget('Travel'),
                  SizedBox(height: 14),
                  listOrderWidget('Food Bloggers'),
                  SizedBox(height: 14),
                  listOrderWidget("Recipe's"),
                  SizedBox(height: 14),
                  listOrderWidget('Ready to eat food reviews'),
                  SizedBox(height: 14),
                  listOrderWidget('Food Reviews'),
                  SizedBox(height: 14),
                  listOrderWidget('Should have followers between 1and 307.5M'),
                  SizedBox(height: 30),
                  headingWidgetMethod('Help & Support'),
                  SizedBox(height: 10),
                  Text(
                    'In case of any queries, checkout the FAQs or contact us',
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.4),
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                    ),
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.envelope,
                            color: primeColor,
                            size: maxSize,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Email',
                            style: TextStyle(
                              color: primeColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 20),
                      Container(
                        height: 20,
                        width: 2,
                        color: primeColor,
                      ),
                      SizedBox(width: 20),
                      Row(
                        children: [
                          Icon(
                            Icons.contact_support_outlined,
                            color: primeColor,
                            size: maxSize,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'FAQs',
                            style: TextStyle(
                              color: primeColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 70,
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CompleteProfileScreen(),
                  ),
                );
              },
              child: Container(
                height: 50,
                width: width / 1.5,
                decoration: BoxDecoration(
                  color: primeColor,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'Complete Your Profile To Apply',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: maxSize - 3,
                      color: whiteColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
