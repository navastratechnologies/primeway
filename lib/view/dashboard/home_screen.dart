import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:primewayskills_app/view/appbar_screens/profile_edit_screen.dart';
import 'package:primewayskills_app/view/dashboard/homePage_screens/collaboration_internal_screen.dart';
import 'package:primewayskills_app/view/dashboard/homePage_screens/creater_program_scrren.dart';
import 'package:primewayskills_app/view/helpers/colors.dart';
import 'package:primewayskills_app/view/helpers/helping_widgets.dart';

class Homescreen extends StatefulWidget {
  final String userNumber;
  final String userName;
  final String userAddress;
  final String userProfileImage;
  final String userPayment;
  final String userEmail;
  final String userWalletId;
  final String userLanguage;
  final String userFollowers;
  final String userProfileCompletionPercentage;

  const Homescreen({
    Key? key,
    required this.userNumber,
    required this.userName,
    required this.userAddress,
    required this.userProfileImage,
    required this.userPayment,
    required this.userEmail,
    required this.userWalletId,
    required this.userLanguage,
    required this.userFollowers,
    required this.userProfileCompletionPercentage,
  }) : super(key: key);

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final CollectionReference collaboration =
      FirebaseFirestore.instance.collection('collaboration');

  final CollectionReference banner =
      FirebaseFirestore.instance.collection('Banner');

  final CollectionReference createrBanner =
      FirebaseFirestore.instance.collection('Creater_banner');

  final CollectionReference creatorProgramCategory =
      FirebaseFirestore.instance.collection('creator_program_category');

  int _current = 0;
  final CarouselController _controller = CarouselController();
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: whiteColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                const SizedBox(height: 10),
                StreamBuilder(
                  stream: banner.snapshots(),
                  builder:
                      (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                    if (streamSnapshot.hasData) {
                      return CarouselSlider.builder(
                        itemCount: streamSnapshot.data!.docs.length,
                        itemBuilder: (context, index, realIndex) {
                          final DocumentSnapshot documentSnapshot =
                              streamSnapshot.data!.docs[index];
                          return Container(
                            width: MediaQuery.of(context).size.width / 1.1,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                  documentSnapshot['Banner_image'],
                                ),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          );
                        },
                        options: CarouselOptions(
                          autoPlayInterval: const Duration(seconds: 5),
                          autoPlay: true,
                          enlargeCenterPage: true,
                          aspectRatio: 2.0,
                          viewportFraction: 2.0,
                          onPageChanged: (index, reason) {
                            setState(
                              () {
                                _current = index;
                              },
                            );
                          },
                        ),
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.userProfileCompletionPercentage == "100"
                      ? Container()
                      : Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (contex) => ProfileEditScreen(
                                      userNumber: widget.userNumber,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                height: 70,
                                width: width,
                                decoration: BoxDecoration(
                                  color: primeColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons.user,
                                        color: whiteColor,
                                        size: 40,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Complete Your profile ➪",
                                            style: TextStyle(
                                              color: whiteColor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Row(
                                            children: [
                                              Stack(
                                                children: [
                                                  Container(
                                                    height: 7,
                                                    width: 200,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: whiteColor
                                                          .withOpacity(0.4),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 7,
                                                    width: double.parse(widget
                                                            .userProfileCompletionPercentage) *
                                                        2,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: whiteColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(width: 10),
                                              Text(
                                                "${widget.userProfileCompletionPercentage}%",
                                                style: TextStyle(
                                                  color: whiteColor,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                  const SizedBox(height: 30),
                  headingWidgetMethod('Creator Programs'),
                  const SizedBox(height: 10),
                  StreamBuilder(
                      stream: creatorProgramCategory.snapshots(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                        if (streamSnapshot.hasData) {
                          return GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    childAspectRatio: 1.5),
                            itemCount: streamSnapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              final DocumentSnapshot documentSnapshot =
                                  streamSnapshot.data!.docs[index];
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CreaterProgramScreen(
                                        categorey: documentSnapshot['category'],
                                        titles: "Creator Programs",
                                        userNumber: widget.userNumber,
                                        userAddress: widget.userAddress,
                                        userEmail: widget.userEmail,
                                        userName: widget.userName,
                                        userPayment: widget.userPayment,
                                        userProfileImage:
                                            widget.userProfileImage,
                                        userWalletId: widget.userWalletId,
                                        userLanguage:
                                            widget.userLanguage.toString(),
                                        userFollowers: widget.userFollowers,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: primeColor,
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          documentSnapshot['image']),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }),
                  const SizedBox(height: 30),
                  headingWidgetMethod('Collaborations'),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: width,
                    height: 360,
                    child: StreamBuilder(
                      stream: collaboration.snapshots(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                        if (streamSnapshot.hasData) {
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: streamSnapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              final DocumentSnapshot documentSnapshot =
                                  streamSnapshot.data!.docs[index];
                              return Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CollaborationInternalScreen(
                                          collabId: documentSnapshot.id,
                                          userNumber: widget.userNumber,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: width / 1.11,
                                    decoration: BoxDecoration(
                                      color: whiteColor,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                        color: Colors.black.withOpacity(0.2),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 175,
                                          width: width / 1.11,
                                          decoration: BoxDecoration(
                                            color: primeColor,
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(15),
                                              topRight: Radius.circular(15),
                                            ),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                documentSnapshot['image'],
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(14),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      const FaIcon(
                                                          FontAwesomeIcons
                                                              .instagram),
                                                      const SizedBox(width: 5),
                                                      Text(
                                                          "${documentSnapshot['required_followers_from']} to "),
                                                      Text(
                                                          "${documentSnapshot['required_followers_to']} followers"),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                      height: 50,
                                                      width: 100,
                                                      child: Image.network(
                                                        documentSnapshot[
                                                            'brand_logo'],
                                                        fit: BoxFit.cover,
                                                      )),
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                              headingWidgetMethod(
                                                documentSnapshot['titles'],
                                              ),
                                              const SizedBox(height: 10),
                                              Text(
                                                documentSnapshot['descreption'],
                                                style: TextStyle(
                                                  color: Colors.black
                                                      .withOpacity(0.4),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
