import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:primewayskills_app/controllers/phone_controller.dart';
import 'package:primewayskills_app/view/dashboard/dashboard.dart';
import 'package:primewayskills_app/view/helpers/colors.dart';
import 'package:primewayskills_app/view/helpers/responsive_size_helper.dart';
import 'package:primewayskills_app/view/profile_screen/congrats_screen.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class AffiliateCourseDetailScreen extends StatefulWidget {
  final String userNumber;
  final String courseId;
  const AffiliateCourseDetailScreen({
    super.key,
    required this.courseId,
    required this.userNumber,
  });

  @override
  State<AffiliateCourseDetailScreen> createState() =>
      _AffiliateCourseDetailScreenState();
}

class _AffiliateCourseDetailScreenState
    extends State<AffiliateCourseDetailScreen> {
  String walletBalance = '0';
  String gst = '0';
  String baseAmount = '0';
  String totalAmount = '0';
  String finalAmountForPayment = '0';
  String userNumber = '';
  String courseAuthor = '';
  String courseImage = '';
  String courseName = '';
  String affiliateCount = '';
  String userEmail = '';

  double exactTotalToPay = 0.0;
  double exactWalletBalanceAfterDeduction = 0.0;

  String cartCount = '0';

  bool alreadyPurchased = false;

  late Razorpay _razorpay;

  Future updateUserWalletbalance(String walletBalance) async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(userNumber)
        .collection('courses')
        .doc(widget.courseId)
        .set(
      {
        "author_name": courseAuthor,
        "courses_id": widget.courseId,
        "image": courseImage,
        "name": courseName,
        "base_ammount": baseAmount,
      },
    );
    FirebaseFirestore.instance.collection('wallet').doc(userNumber).update(
      {
        "wallet_balance": walletBalance,
      },
    ).then((value) {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CongratsScreen(
            msg: 'Congrats, Your have purchased this course successfully.',
          ),
        ),
      );
    });
  }

  Future updateUserAffiliateCollection() async {
    var newCount = int.parse(affiliateCount) + 1;
    FirebaseFirestore.instance
        .collection('affilate_dashboard')
        .doc('NkcdMPSuI3SSIpJ2uLuv')
        .collection('affiliate_users')
        .doc(userNumber)
        .update(
      {
        "total_affiliate": newCount.toString(),
      },
    );
  }

  Future getAffiliateDataOfTheUser() async {
    FirebaseFirestore.instance
        .collection('affilate_dashboard')
        .doc('NkcdMPSuI3SSIpJ2uLuv')
        .collection('affiliate_users')
        .doc(userNumber)
        .get()
        .then(
      (value) {
        setState(() {
          affiliateCount = value.get('total_affiliate');
          updateUserAffiliateCollection();
        });
        log('affiliate total is $affiliateCount');
      },
    );
  }

  Future getUserData() async {
    FirebaseFirestore.instance.collection('users').doc(userNumber).get().then(
      (value) {
        setState(() {
          userEmail = value.get('email');
        });
        log('user email is $userEmail');
      },
    );
  }

  Future checkCourseAlreadyPurchasedOrnot() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userNumber)
        .collection('courses')
        .doc(widget.courseId)
        .get()
        .then(
      (value) {
        if (value.exists) {
          log('course already purchased');
          setState(() {
            alreadyPurchased = true;
          });
        } else {
          log('course already not purchased');
          setState(() {
            alreadyPurchased = false;
          });
          // getAffiliateDataOfTheUser();
        }
      },
    );
  }

  void openCheckout(price) async {
    var options = {
      'key': razor_key_id,
      'amount': price,
      'name': 'Primeway Skills - Influencing & Marketing',
      'description': '',
      'retry': {
        'enabled': true,
      },
      'send_sms_hash': true,
      'prefill': {
        'contact': widget.userNumber,
        'email': "widget.userEmail",
      },
      'external': {
        'wallets': ['paytm']
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error : e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // ignore: use_build_context_synchronously
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CongratsScreen(
          msg: 'Congrats, Your payment is successfully completed.',
        ),
      ),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {}

  void _handlePaymentWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("EXTERNAL WALLET"),
      ),
    );
  }

  Future getWalletBalance() async {
    FirebaseFirestore.instance.collection("wallet").doc(userNumber).get().then(
      (value) {
        walletBalance = value.get("wallet_balance");
      },
    );
  }

  Future getCoursePrice() async {
    FirebaseFirestore.instance
        .collection("courses")
        .doc(widget.courseId)
        .get()
        .then(
      (value) {
        gst = value.get("gst_rate").toString().replaceAll('%', '');
        courseAuthor = value.get('author_name');
        courseImage = value.get('image');
        courseName = value.get('name');
        baseAmount = value.get("base_ammount");
        var baseTotal = double.parse(baseAmount) * double.parse(gst) / 100;
        var total = double.parse(baseAmount) + baseTotal;
        totalAmount = total.floorToDouble().toString();

        log('total amount is $totalAmount $gst $baseAmount');

        if (double.parse(walletBalance) < total) {
          var amount = total - double.parse(walletBalance);
          finalAmountForPayment = amount.toString();
          log('total amount is $finalAmountForPayment');
        }
      },
    );
  }

  @override
  void initState() {
    checkLogin();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handlePaymentWallet);
    getCoursePrice();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black.withOpacity(0.6),
        ),
        backgroundColor: whiteColor,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('courses')
            .where('course_id', isEqualTo: widget.courseId)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            documentSnapshot['image'],
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            documentSnapshot['name'],
                            style: TextStyle(
                              fontSize: maxSize,
                              color: Colors.black.withOpacity(0.6),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            documentSnapshot['short_description'],
                            style: TextStyle(
                              fontSize: minSize,
                              color: Colors.black.withOpacity(0.6),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                  horizontal: 10,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: purpleColor,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      "Language:",
                                      style: TextStyle(
                                        fontSize: minSize,
                                        color: whiteColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      documentSnapshot['language'],
                                      style: TextStyle(
                                        fontSize: minSize,
                                        color: whiteColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 30),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                  horizontal: 10,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: primeColor2,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      "Instructor:",
                                      style: TextStyle(
                                        fontSize: minSize,
                                        color: whiteColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      documentSnapshot['author_name'],
                                      style: TextStyle(
                                        fontSize: minSize,
                                        color: whiteColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          alreadyPurchased
                              ? MaterialButton(
                                  color: Colors.orange,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Dashboard(),
                                    ),
                                  ),
                                  child: Text(
                                    'This Course Is Already Purchased. Go To HomePage',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: whiteColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    MaterialButton(
                                      minWidth: 0,
                                      height: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 6,
                                        horizontal: 10,
                                      ),
                                      color: primeColor,
                                      onPressed: () {
                                        if (double.parse(walletBalance) <=
                                            double.parse(totalAmount)) {
                                          setState(() {
                                            exactTotalToPay =
                                                double.parse(totalAmount) -
                                                    double.parse(walletBalance);
                                          });
                                        } else if (double.parse(
                                                walletBalance) ==
                                            0.0) {
                                          setState(() {
                                            exactTotalToPay =
                                                double.parse(totalAmount);
                                          });
                                        } else if (double.parse(walletBalance) >
                                            double.parse(totalAmount)) {
                                          setState(() {
                                            exactWalletBalanceAfterDeduction =
                                                double.parse(walletBalance) -
                                                    double.parse(totalAmount);
                                          });
                                        }
                                        log('wallet exact is $exactTotalToPay $exactWalletBalanceAfterDeduction');
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Container(
                                              height: 240,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              color: whiteColor,
                                              padding: const EdgeInsets.all(10),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Image.asset(
                                                            'assets/icons/wallet.png',
                                                            height: 40,
                                                            width: 60,
                                                          ),
                                                          const Text(
                                                            'Wallet Balance',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Text(
                                                        "Rs.$walletBalance",
                                                        style: TextStyle(
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black
                                                              .withOpacity(0.5),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 20),
                                                  Expanded(
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      decoration: BoxDecoration(
                                                        color: whiteColor,
                                                        border: Border.all(
                                                          color: primeColor,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: primeColor
                                                                .withOpacity(
                                                                    0.2),
                                                            blurRadius: 10,
                                                            spreadRadius: 1,
                                                          ),
                                                        ],
                                                      ),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                'Base Amount :',
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.5),
                                                                ),
                                                              ),
                                                              Text(
                                                                baseAmount,
                                                                style:
                                                                    const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                'GST :',
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.5),
                                                                ),
                                                              ),
                                                              Text(
                                                                "$gst%",
                                                                style:
                                                                    const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              const Text(
                                                                'Total :',
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 15,
                                                                ),
                                                              ),
                                                              Text(
                                                                totalAmount,
                                                                style:
                                                                    const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 15,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 20),
                                                  userNumber.isEmpty
                                                      ? MaterialButton(
                                                          color: primeColor2,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                          onPressed: () {
                                                            context.pop();
                                                            context.pop();
                                                          },
                                                          child: Text(
                                                            'Please Login To Continue',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: whiteColor,
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                        )
                                                      : Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  exactTotalToPay
                                                                      .toString(),
                                                                  style:
                                                                      const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        16,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  'You have to pay',
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        10,
                                                                    color:
                                                                        primeColor2,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            MaterialButton(
                                                              color:
                                                                  primeColor2,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                              ),
                                                              onPressed: () {
                                                                if (double.parse(
                                                                        walletBalance) >=
                                                                    double.parse(
                                                                        totalAmount)) {
                                                                  updateUserWalletbalance(
                                                                    exactWalletBalanceAfterDeduction
                                                                        .toString(),
                                                                  );
                                                                } else {
                                                                  openCheckout(
                                                                    exactTotalToPay *
                                                                        100,
                                                                  );
                                                                }
                                                              },
                                                              child: Text(
                                                                'Buy Now',
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color:
                                                                      whiteColor,
                                                                  fontSize: 16,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Text(
                                        'Buy Now',
                                        style: TextStyle(
                                          color: whiteColor,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Text(
                                      "$rupeeSign${documentSnapshot['base_ammount']}",
                                      style: TextStyle(
                                        fontSize: maxSize,
                                        color: Colors.black.withOpacity(0.6),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: primeColor2.withOpacity(0.1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Text(
                            "Why this course?",
                            style: TextStyle(
                              fontSize: minSize - 2,
                              color: Colors.black.withOpacity(0.4),
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Course Description",
                            style: TextStyle(
                              fontSize: maxSize,
                              color: Colors.black.withOpacity(0.6),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Divider(),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            child: Text(
                              documentSnapshot['course_description'],
                              style: TextStyle(
                                fontSize: minSize,
                                color: Colors.black.withOpacity(0.4),
                                fontWeight: FontWeight.w500,
                                wordSpacing: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: primeColor2,
                      ),
                      child: Column(
                        children: [
                          Text(
                            "Course Curriculum",
                            style: TextStyle(
                              fontSize: maxSize,
                              color: whiteColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "${documentSnapshot['chapters']} Chapters",
                                style: TextStyle(
                                  fontSize: minSize,
                                  color: whiteColor,
                                  fontWeight: FontWeight.w600,
                                  wordSpacing: 1,
                                ),
                              ),
                              Container(
                                height: 18,
                                width: 4,
                                decoration: BoxDecoration(
                                  color: purpleColor,
                                ),
                              ),
                              Text(
                                // "${documentSnapshot['modules']} Modules",
                                "",
                                style: TextStyle(
                                  fontSize: minSize,
                                  color: whiteColor,
                                  fontWeight: FontWeight.w600,
                                  wordSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: primeColor2.withOpacity(0.1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 30,
                              bottom: 10,
                            ),
                            child: Text(
                              "How to Use",
                              style: TextStyle(
                                fontSize: maxSize,
                                color: Colors.black.withOpacity(0.6),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            child: Column(
                              children: [
                                Text(
                                  "After successful purchase, this item would be added to your courses section inside profile tab. You can access your courses in the following ways:",
                                  style: TextStyle(
                                    fontSize: minSize,
                                    color: Colors.black.withOpacity(0.4),
                                    fontWeight: FontWeight.w500,
                                    wordSpacing: 1,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.circle,
                                        size: 10,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    SizedBox(
                                      width: displayWidth(context) / 1.2,
                                      child: Text(
                                        "Go to profiles tab and click on my courses to check your purchased courses and learn by clicking on them.",
                                        style: TextStyle(
                                          fontSize: minSize,
                                          color: Colors.black.withOpacity(0.4),
                                          fontWeight: FontWeight.w500,
                                          wordSpacing: 1,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.circle,
                                        size: 10,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    SizedBox(
                                      width: displayWidth(context) / 1.2,
                                      child: Text(
                                        "Go to courses tab and click on my courses to check your purchased courses and learn by clicking on them.",
                                        style: TextStyle(
                                          fontSize: minSize,
                                          color: Colors.black.withOpacity(0.4),
                                          fontWeight: FontWeight.w500,
                                          wordSpacing: 1,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  checkLogin() async {
    String? token = await getToken();
    if (token != null) {
      setState(() {
        userNumber = token;
        getWalletBalance();
        getUserData();
        checkCourseAlreadyPurchasedOrnot();
      });
    }
  }
}
