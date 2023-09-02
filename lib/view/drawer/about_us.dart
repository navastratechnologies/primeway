import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:primewayskills_app/view/helpers/colors.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Lottie.asset(
                'assets/json/about-us.json',
                repeat: true,
                reverse: true,
              ),
              const SizedBox(height: 20),
              Text(
                "We're All About",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black.withOpacity(0.4),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "Influencing and Marketing",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: primeColor2,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 60),
              Container(
                padding: const EdgeInsets.only(bottom: 4),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: primeColor2,
                      width: 3,
                    ),
                  ),
                ),
                child: Text(
                  "About Us",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.5),
                    fontSize: 18,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('about-us')
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot documentSnapshot = snapshot.data!.docs[index];
                          return Text(
                            documentSnapshot['data'],
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.4),
                              fontWeight: FontWeight.w500,
                              height: 1.4,
                            ),
                            textAlign: TextAlign.justify,
                          );
                        },
                      );
                    }
                    return Container();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  itemCount: 5,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 40,
                    mainAxisSpacing: 20,
                  ),
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.settings_suggest_outlined,
                            size: 80,
                            color: primeColor2,
                          ),
                          const SizedBox(height: 5),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 3,
                            child: Text(
                              "Heading title shown here",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black.withOpacity(0.4),
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 30),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: primeColor2,
                ),
                child: Column(
                  children: [
                    leftAchievementRow(
                      FontAwesomeIcons.solidFaceSmileWink,
                      "Happy Clients",
                      '1000+',
                    ),
                    const SizedBox(height: 20),
                    rightAchievementRow(
                      FontAwesomeIcons.handshakeAngle,
                      "Completed Deals",
                      '102370',
                    ),
                    const SizedBox(height: 20),
                    leftAchievementRow(
                      FontAwesomeIcons.chartColumn,
                      "Running Projects",
                      '500',
                    ),
                    const SizedBox(height: 20),
                    rightAchievementRow(
                      FontAwesomeIcons.trophy,
                      "Award Winning",
                      '3226',
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 30,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.7,
                      child: Text(
                        "Looking someone for marketing of your business?",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black.withOpacity(0.5),
                          fontSize: 14,
                        ),
                      ),
                    ),
                    MaterialButton(
                      color: primeColor2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      onPressed: () async {
                        await FlutterEmailSender.send(
                          Email(
                            body: 'body of email',
                            subject: 'subject of email',
                            recipients: [companyMail],
                            isHTML: false,
                          ),
                        );
                      },
                      child: Text(
                        'Contact Us',
                        style: TextStyle(color: whiteColor),
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
  }

  leftAchievementRow(icon, title, count) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        FaIcon(
          icon,
          size: 40,
          color: whiteColor,
        ),
        const SizedBox(width: 10),
        Container(
          width: 2,
          height: 60,
          decoration: BoxDecoration(
            color: whiteColor,
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: whiteColor.withOpacity(0.5),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              count,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: whiteColor.withOpacity(0.9),
                fontSize: 28,
              ),
            ),
          ],
        ),
      ],
    );
  }

  rightAchievementRow(icon, title, count) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: whiteColor.withOpacity(0.5),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              count,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: whiteColor.withOpacity(0.9),
                fontSize: 28,
              ),
            ),
          ],
        ),
        const SizedBox(width: 10),
        Container(
          width: 2,
          height: 60,
          decoration: BoxDecoration(
            color: whiteColor,
          ),
        ),
        const SizedBox(width: 10),
        FaIcon(
          icon,
          size: 40,
          color: whiteColor,
        ),
      ],
    );
  }
}
