import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:primewayskills_app/view/dashboard/dashboard.dart';
import 'package:primewayskills_app/view/helpers/colors.dart';
import 'package:primewayskills_app/view/helpers/helping_widgets.dart';
import 'package:primewayskills_app/view/helpers/loader.dart';
import 'package:primewayskills_app/view/helpers/responsive_size_helper.dart';

class CommercialPricingPage extends StatefulWidget {
  final String userNumber;
  const CommercialPricingPage({
    super.key,
    required this.userNumber,
  });

  @override
  State<CommercialPricingPage> createState() => _CommercialPricingPageState();
}

class _CommercialPricingPageState extends State<CommercialPricingPage> {
  TextEditingController instaImageController = TextEditingController();
  TextEditingController instaVideoController = TextEditingController();
  TextEditingController instaStoryController = TextEditingController();
  TextEditingController instaReelsController = TextEditingController();
  TextEditingController instaCarouselController = TextEditingController();
  TextEditingController youtubeVideoController = TextEditingController();
  TextEditingController youtubeShortsController = TextEditingController();

  Future updateCommercialPrice() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userNumber)
        .update(
      {
        "insta_image_price": instaImageController.text,
        "insta_video_price": instaVideoController.text,
        "insta_carousel_price": instaCarouselController.text,
        "insta_story_price": instaStoryController.text,
        "insta_reels_price": instaReelsController.text,
        "youtube_video_price": youtubeVideoController.text,
        "youtube_short_price": youtubeShortsController.text,
      },
    );
  }

  Future<void> getUserProfileData() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userNumber)
        .get()
        .then(
      (value) {
        setState(() {
          instaImageController.text = value.get('insta_image_price');
          instaVideoController.text = value.get('insta_video_price');
          instaCarouselController.text = value.get('insta_carousel_price');
          instaStoryController.text = value.get('insta_story_price');
          instaReelsController.text = value.get('insta_reels_price');
          youtubeVideoController.text = value.get('youtube_video_price');
          youtubeShortsController.text = value.get('youtube_short_price');
        });
      },
    );
  }

  @override
  void initState() {
    getUserProfileData();
    super.initState();
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
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                MaterialButton(
                  color: purpleColor,
                  padding: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Skip for now',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        title: Text(
          'Commercials',
          style: TextStyle(
            fontSize: maxSize,
            color: Colors.black.withOpacity(0.6),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Text(
                "Share your charges for insta & youtube platform to get more relevant collabs.",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 50),
              commercialHeadingWidget(
                'assets/json/instagram-icon.json',
                "Connect with Instagram",
              ),
              editCommercialsWidget(
                "Insta Image",
                instaImageController,
                'Image',
              ),
              editCommercialsWidget(
                "Insta Story",
                instaStoryController,
                'Story',
              ),
              editCommercialsWidget(
                "Insta Video",
                instaVideoController,
                'Video',
              ),
              editCommercialsWidget(
                "Insta Reels",
                instaReelsController,
                'Reels',
              ),
              editCommercialsWidget(
                "Insta Carousels",
                instaCarouselController,
                'Carousel',
              ),
              const SizedBox(height: 30),
              commercialHeadingWidget(
                'assets/json/youtube.json',
                "Connect with Youtube",
              ),
              editCommercialsWidget(
                "Youtube Video",
                youtubeVideoController,
                'Video',
              ),
              editCommercialsWidget(
                "Youtube Shorts",
                youtubeShortsController,
                'Shorts',
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 80,
        child: Center(
          child: MaterialButton(
            minWidth: displayWidth(context) / 1.5,
            color: primeColor2,
            padding: const EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            onPressed: () {
              setState(() {
                const LoaderWidget();
                updateCommercialPrice();
              });
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Dashboard(),
                ),
              );
            },
            child: const Text(
              'Save',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  editCommercialsWidget(heading, controller, hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            heading,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black.withOpacity(0.4),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                rupeeSign,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: maxSize,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 140,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: primeColor.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 1,
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter Price Per $hint',
                      hintStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black.withOpacity(0.3),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
