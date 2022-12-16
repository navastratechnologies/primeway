import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:primewayskills_app/view/helpers/colors.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class AddToCartScreen extends StatefulWidget {
  final String userNumber;
  final String userName;
  final String userAddress;
  final String userProfileImage;
  final String userPayment;
  final String userEmail;
  final String userWalletId;
  final String courseName;
  final String courseId;
  const AddToCartScreen({
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
  State<AddToCartScreen> createState() => _AddToCartScreenState();
}

class _AddToCartScreenState extends State<AddToCartScreen> {
  final CollectionReference course =
      FirebaseFirestore.instance.collection('courses');

  late Razorpay _razorpay;

  void openCheckout(price, description) async {
    var options = {
      'key': 'rzp_live_uk8FMXyEL6QH6L',
      'amount': price,
      'name': 'Primeway Skills - Influencing & Marketing',
      'description': description,
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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Payment Successful"),
      ),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Payment Failed ${response.message}"),
      ),
    );
  }

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
      ),
      body: StreamBuilder(
        stream: course.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    height: 100,
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
                                  Text(
                                    'Rs. ${documentSnapshot['base_ammount']}',
                                    style: const TextStyle(
                                      color: Colors.amber,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
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
                      ],
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: MaterialButton(
          color: purpleColor,
          padding: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          onPressed: () {
            openCheckout('100', 'Place Order');
          },
          child: Text(
            'Pay Now ',
            style: TextStyle(
              color: whiteColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
