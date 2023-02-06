import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:primewayskills_app/view/dashboard/courses_screens/cart_screen.dart';
import 'package:primewayskills_app/view/dashboard/courses_screens/widgets/course_chapter_screen.dart';
import 'package:primewayskills_app/view/drawer/sidebar.dart';
import 'package:primewayskills_app/view/helpers/colors.dart';
import 'package:primewayskills_app/view/profile_screen/congrats_screen.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class CourseDetailScreen extends StatefulWidget {
  final String userNumber;
  final String userName;
  final String userAddress;
  final String userProfileImage;
  final String userPayment;
  final String userEmail;
  final String userWalletId;
  final String courseName;
  final String courseId;
  final String courseAuthor;
  final String courseImage;
  final String courseAmount;
  final String pageType;
  const CourseDetailScreen({
    super.key,
    required this.courseName,
    required this.courseId,
    required this.userNumber,
    required this.userName,
    required this.userAddress,
    required this.userProfileImage,
    required this.userPayment,
    required this.userEmail,
    required this.userWalletId,
    required this.courseAuthor,
    required this.courseImage,
    required this.courseAmount,
    required this.pageType,
  });

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  final CollectionReference chapters = FirebaseFirestore.instance
      .collection('courses')
      .doc()
      .collection('chapters');

  Future updateUserWalletbalance(String walletBalance) async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userNumber)
        .collection('courses')
        .doc(widget.courseId)
        .set(
      {
        "author_name": widget.courseAuthor,
        "courses_id": widget.courseId,
        "image": widget.courseImage,
        "name": widget.courseName,
        "base_ammount": widget.courseAmount,
      },
    );
    FirebaseFirestore.instance
        .collection('wallet')
        .doc(widget.userNumber)
        .update(
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

  Future getcartDataCount() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userNumber)
        .collection('mycart')
        .get();
    setState(
      () {
        cartCount = querySnapshot.docs.length.toString();
      },
    );
  }

  Future getWalletBalance() async {
    FirebaseFirestore.instance
        .collection("wallet")
        .doc(widget.userNumber)
        .get()
        .then(
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
        gst = value.get("gst_rate");
        isLive = value.get('islive');
        baseAmount = value.get("base_ammount");
        var total = double.parse(gst) + double.parse(baseAmount);
        totalAmount = total.toString();

        log('total amount is $totalAmount');

        if (double.parse(walletBalance) < total) {
          var amount = total - double.parse(walletBalance);
          finalAmountForPayment = amount.toString();
          log('total amount is $finalAmountForPayment');
        }
      },
    );
  }

  String isLive = '';
  String walletBalance = '';
  String gst = '';
  String baseAmount = '';
  String totalAmount = '';
  String finalAmountForPayment = '';
  double exactTotalToPay = 0.0;
  double exactWalletBalanceAfterDeduction = 0.0;

  String cartCount = '0';

  late Razorpay _razorpay;

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
        'email': widget.userEmail,
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
    updateUserWalletbalance(
      exactWalletBalanceAfterDeduction.toString(),
    );
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

  @override
  void initState() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handlePaymentWallet);
    getcartDataCount();
    getWalletBalance();
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
      drawer: NavigationDrawer(
        userAddress: widget.userAddress,
        userEmail: widget.userEmail,
        userName: widget.userName,
        userNumber: widget.userNumber,
        userPayment: widget.userPayment,
        userProfileImage: widget.userProfileImage,
        userWalletId: widget.userWalletId,
      ),
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black.withOpacity(0.6),
        ),
        backgroundColor: whiteColor,
        title: Text(
          widget.courseName,
          style: TextStyle(
            fontSize: maxSize,
            color: Colors.black.withOpacity(0.6),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartScreen(
                    userAddress: widget.userAddress,
                    userEmail: widget.userEmail,
                    userName: widget.userName,
                    userNumber: widget.userNumber,
                    userPayment: widget.userPayment,
                    userProfileImage: widget.userProfileImage,
                    userWalletId: widget.userWalletId,
                    courseName: widget.courseName,
                    courseId: widget.courseId,
                  ),
                ),
              );
            },
            child: SizedBox(
              width: 40,
              height: 100,
              child: Stack(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CartScreen(
                            userAddress: widget.userAddress,
                            userEmail: widget.userEmail,
                            userName: widget.userName,
                            userNumber: widget.userNumber,
                            userPayment: widget.userPayment,
                            userProfileImage: widget.userProfileImage,
                            userWalletId: widget.userWalletId,
                            courseName: widget.courseName,
                            courseId: widget.courseId,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.shopping_cart_rounded,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5, right: 5),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: primeColor,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          cartCount,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: CourseChapterScreen(
        courseId: widget.courseId,
        courseName: widget.courseName,
        userAddress: widget.userAddress,
        userEmail: widget.userEmail,
        userName: widget.userName,
        userNumber: widget.userNumber,
        userPayment: widget.userPayment,
        userProfileImage: widget.userProfileImage,
        userWalletId: widget.userWalletId,
        pageType: widget.pageType,
        isLive: isLive,
      ),
      bottomNavigationBar: widget.pageType == "my_course"
          ? null
          : Container(
              width: MediaQuery.of(context).size.width,
              height: 70,
              decoration: BoxDecoration(
                color: whiteColor,
                boxShadow: [
                  BoxShadow(
                    color: primeColor.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  MaterialButton(
                    color: purpleColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(widget.userNumber)
                          .collection('mycart')
                          .add({
                        'author_name': widget.courseAuthor,
                        'courses_id': widget.courseId,
                        'image': widget.courseImage,
                        'name': widget.courseName,
                        'base_ammount': widget.courseAmount,
                      }).whenComplete(
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CartScreen(
                              userAddress: widget.userAddress,
                              userEmail: widget.userEmail,
                              userName: widget.userName,
                              userNumber: widget.userNumber,
                              userPayment: widget.userPayment,
                              userProfileImage: widget.userProfileImage,
                              userWalletId: widget.userWalletId,
                              courseName: widget.courseName,
                              courseId: widget.courseId,
                            ),
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'Add To Cart',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: whiteColor,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  MaterialButton(
                    color: primeColor2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onPressed: () {
                      if (double.parse(walletBalance) <=
                          double.parse(totalAmount)) {
                        setState(() {
                          exactTotalToPay = double.parse(totalAmount) -
                              double.parse(walletBalance);
                        });
                      } else if (double.parse(walletBalance) == 0.0) {
                        setState(() {
                          exactTotalToPay = double.parse(totalAmount);
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
                            width: MediaQuery.of(context).size.width,
                            color: whiteColor,
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "Rs.$walletBalance",
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black.withOpacity(0.5),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: whiteColor,
                                      border: Border.all(
                                        color: primeColor,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: primeColor.withOpacity(0.2),
                                          blurRadius: 10,
                                          spreadRadius: 1,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Base Amount :',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black
                                                    .withOpacity(0.5),
                                              ),
                                            ),
                                            Text(
                                              baseAmount,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'GST :',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black
                                                    .withOpacity(0.5),
                                              ),
                                            ),
                                            Text(
                                              gst,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Total :',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),
                                            Text(
                                              totalAmount,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          exactTotalToPay.toString(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          'You have to pay',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 10,
                                            color: primeColor2,
                                          ),
                                        ),
                                      ],
                                    ),
                                    MaterialButton(
                                      color: primeColor2,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      onPressed: () {
                                        if (double.parse(walletBalance) >=
                                            double.parse(totalAmount)) {
                                          updateUserWalletbalance(
                                            exactWalletBalanceAfterDeduction
                                                .toString(),
                                          );
                                        } else {
                                          openCheckout(
                                            exactTotalToPay * 100,
                                          );
                                        }
                                      },
                                      child: Text(
                                        'Buy Now',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: whiteColor,
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
                        fontWeight: FontWeight.bold,
                        color: whiteColor,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
