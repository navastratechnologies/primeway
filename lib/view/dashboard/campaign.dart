import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../helpers/colors.dart';

class CampaingnScreen extends StatefulWidget {
  const CampaingnScreen({
    super.key,
  });

  @override
  State<CampaingnScreen> createState() => _CampaingnScreenState();
}

class _CampaingnScreenState extends State<CampaingnScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black.withOpacity(0.6),
        ),
        backgroundColor: whiteColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Lottie.asset(
                  'assets/json/refer.json',
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              const Text(
                "Campaigns Unlocked",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              const Text(
                "Congratulations!",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.5,
                child: Text(
                  "you have succesfully unlocked Campaigns. Check now!!!",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    color: Colors.black.withOpacity(0.3),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
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
    );
  }
}
