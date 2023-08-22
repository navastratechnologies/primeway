import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:primewayskills_app/view/helpers/colors.dart';
import 'package:primewayskills_app/view/profile_screen/congrats_screen.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class CartScreen extends StatefulWidget {
  final String userNumber;
  final String userName;
  final String userAddress;
  final String userProfileImage;
  final String userPayment;
  final String userEmail;
  final String userWalletId;
  final String courseName;
  final String courseId;
  const CartScreen({
    super.key,
    required this.userNumber,
    required this.userName,
    required this.userAddress,
    required this.userProfileImage,
    required this.userPayment,
    required this.userEmail,
    required this.userWalletId,
    required this.courseName,
    required this.courseId,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Razorpay _razorpay;

  var formatter = DateFormat('MM/dd/yyyy hh:mm a');

  Future getCoursePrice() async {
    FirebaseFirestore.instance
        .collection("wallet")
        .doc(widget.userNumber)
        .get()
        .then(
      (value) {
        setState(() {
          walletBalance = value.get("wallet_balance");
        });
      },
    );
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore
        .collection('users')
        .doc(widget.userNumber)
        .collection('mycart');

    try {
      QuerySnapshot querySnapshot = await users.get();

      double totalBase = 0.0;

      for (var doc in querySnapshot.docs) {
        totalBase += double.parse(doc['base_ammount']);
      }
      setState(() {
        baseAmount = totalBase.toString();
        gst = '18';
        var baseTotal = double.parse(gst) * double.parse(baseAmount) / 100;
        var total = baseTotal + double.parse(baseAmount);
        totalAmount = total.toString();

        log('total base amount is $totalAmount');
      });

      log('Total of the field: $totalBase');
    } catch (e) {
      print('Error getting total: $e');
    }
  }

  String walletBalance = '0.0';
  String gst = '0.0';
  String baseAmount = '0.0';
  String totalAmount = '0.0';
  String finalAmountForPayment = '0.0';

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
    getAndUpdateCartDataIntoMyCourses(false);
  }

  void _handlePaymentError(PaymentFailureResponse response) {}

  void _handlePaymentWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("EXTERNAL WALLET"),
      ),
    );
  }

  Future getAndUpdateCartDataIntoMyCourses(walletGreater) async {
    if (walletGreater) {
      FirebaseFirestore.instance
          .collection('wallet')
          .doc(widget.userNumber)
          .update(
        {
          'wallet_balance':
              "${double.parse(walletBalance) - double.parse(totalAmount)}",
        },
      );
      FirebaseFirestore.instance
          .collection('wallet')
          .doc(widget.userNumber)
          .collection('transactions')
          .add(
        {
          'status': 'true',
          'date_time': formatter.format(DateTime.now()).toString(),
          'type': 'withdrawal',
          'coins': totalAmount,
          'reason': '$totalAmount p coins is used for purchasing courses',
        },
      );
    } else if (double.parse(walletBalance) > 1) {
      FirebaseFirestore.instance
          .collection('wallet')
          .doc(widget.userNumber)
          .update(
        {
          'wallet_balance':
              "${double.parse(totalAmount) - double.parse(walletBalance)}",
        },
      );
      FirebaseFirestore.instance
          .collection('wallet')
          .doc(widget.userNumber)
          .collection('transactions')
          .add(
        {
          'status': 'true',
          'date_time': formatter.format(DateTime.now()).toString(),
          'type': 'withdrawal',
          'coins': "${double.parse(totalAmount) - double.parse(walletBalance)}",
          'reason': 'Your purchased course',
        },
      );
    }
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userNumber)
        .collection('mycart')
        .get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      final a = querySnapshot.docs[i];
      FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userNumber)
          .collection('courses')
          .add(
        {
          'author_name': querySnapshot.docs[i]['author_name'],
          'courses_id': querySnapshot.docs[i]['courses_id'],
          'image': querySnapshot.docs[i]['image'],
          'name': querySnapshot.docs[i]['name'],
          'base_ammount': querySnapshot.docs[i]['base_ammount'],
        },
      );
      FirebaseFirestore.instance
          .collection("users")
          .doc(widget.userNumber)
          .collection('mycart')
          .doc(a.id)
          .delete();
    }

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

  bool cartIsEmpty = false;

  @override
  void initState() {
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
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black.withOpacity(0.6),
        ),
        backgroundColor: whiteColor,
        title: Text(
          "Checkout",
          style: TextStyle(
            fontSize: maxSize,
            color: Colors.black.withOpacity(0.6),
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: cartIsEmpty
              ? () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                }
              : () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userNumber)
            .collection('mycart')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData && streamSnapshot.data!.docs.isNotEmpty) {
            cartIsEmpty = false;

            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    height: 130,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: primeColor.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 100,
                              width: MediaQuery.of(context).size.width / 2.3,
                              child: Image.network(
                                documentSnapshot['image'],
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width /
                                        2.25,
                                    child: Text(
                                      documentSnapshot['name'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.person_rounded,
                                        color: Colors.black.withOpacity(0.6),
                                        size: 16,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        documentSnapshot['author_name'],
                                        style: TextStyle(
                                          color: Colors.black.withOpacity(0.4),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width /
                                        2.25,
                                    child: Text(
                                      'Rs. ${documentSnapshot['base_ammount']}',
                                      style: const TextStyle(
                                        color: Colors.amber,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: InkWell(
                            onTap: () {
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(widget.userNumber)
                                  .collection('mycart')
                                  .doc(documentSnapshot.id)
                                  .delete();
                              setState(() {
                                getCoursePrice();
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: primeColor,
                                borderRadius: const BorderRadius.only(
                                  bottomRight: Radius.circular(10),
                                  topLeft: Radius.circular(10),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: primeColor2.withOpacity(0.3),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.delete_forever_rounded,
                                color: whiteColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            cartIsEmpty = true;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Lottie.asset('assets/json/empty.json'),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    "Oh No! Cart is Empty.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black.withOpacity(0.4),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: MaterialButton(
                    color: primeColor2,
                    padding: const EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Add Course',
                      style: TextStyle(
                        color: whiteColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
      bottomNavigationBar: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userNumber)
            .collection('mycart')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: MaterialButton(
                color: purpleColor,
                padding: const EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onPressed: () {
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
                                              color:
                                                  Colors.black.withOpacity(0.5),
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
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                            ),
                                          ),
                                          Text(
                                            "$gst%",
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
                                      double.parse(walletBalance) >
                                                  double.parse(totalAmount) ||
                                              double.parse(walletBalance) ==
                                                  double.parse(totalAmount)
                                          ? const Text(
                                              "0.0",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            )
                                          : Text(
                                              "${double.parse(totalAmount) - double.parse(walletBalance)}",
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
                                      if (double.parse(walletBalance) >
                                              double.parse(totalAmount) ||
                                          double.parse(walletBalance) ==
                                              double.parse(totalAmount)) {
                                        getAndUpdateCartDataIntoMyCourses(true);
                                      } else {
                                        setState(
                                          () {
                                            double finalTA =
                                                double.parse(totalAmount) -
                                                    double.parse(walletBalance);
                                            openCheckout(
                                              finalTA * 100,
                                            );
                                          },
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
                      });
                },
                child: Text(
                  'Pay Now ',
                  style: TextStyle(
                    color: whiteColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }
          return const SizedBox(height: 10);
        },
      ),
    );
  }
}
