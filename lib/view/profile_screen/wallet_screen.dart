import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:primewayskills_app/view/helpers/alert_deialogs.dart';
import 'package:primewayskills_app/view/helpers/colors.dart';
import 'package:primewayskills_app/view/helpers/helping_widgets.dart';
import 'package:primewayskills_app/view/helpers/responsive_size_helper.dart';

class WalletScreen extends StatefulWidget {
  final String userNumber;
  const WalletScreen({
    super.key,
    required this.userNumber,
  });

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  String walletbalance = '';

  TextEditingController withdrawController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 5,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  primeColor,
                  primeColor.withOpacity(0.1),
                  // primeColor.withOpacity(0.3),
                ],
              ),
            ),
            child: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              iconTheme: IconThemeData(
                color: Colors.black.withOpacity(0.6),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 6.5,
              ),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.5,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(40),
                      bottomLeft: Radius.circular(40),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: primeColor.withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'TOTAL BALANCE',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          // color: whiteColor,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircleAvatar(
                            maxRadius: 14,
                            backgroundImage: AssetImage(
                              'assets/play_store_icon.png',
                            ),
                          ),
                          const SizedBox(width: 5),
                          StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('wallet')
                                .where('user_id', isEqualTo: widget.userNumber)
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                              if (streamSnapshot.hasData) {
                                for (var i = 0;
                                    i < streamSnapshot.data!.docs.length;
                                    i++) {
                                  DocumentSnapshot documentSnapshot =
                                      streamSnapshot.data!.docs[i];
                                  walletbalance =
                                      documentSnapshot['wallet_balance'];
                                  return Text(
                                    documentSnapshot['wallet_balance'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: primeColor2,
                                      letterSpacing: 0.3,
                                      fontSize: 24,
                                    ),
                                  );
                                }
                              }
                              return Container();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 2.2,
                      padding: const EdgeInsets.all(10),
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
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: primeColor2,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.arrow_upward_rounded,
                              color: whiteColor,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('wallet')
                                    .where('user_id',
                                        isEqualTo: widget.userNumber)
                                    .snapshots(),
                                builder: (context,
                                    AsyncSnapshot<QuerySnapshot>
                                        streamSnapshot) {
                                  if (streamSnapshot.hasData) {
                                    for (var i = 0;
                                        i < streamSnapshot.data!.docs.length;
                                        i++) {
                                      DocumentSnapshot documentSnapshot =
                                          streamSnapshot.data!.docs[i];
                                      return headingWidgetMethod(
                                        documentSnapshot['earned_pcoins'],
                                      );
                                    }
                                  }
                                  return headingWidgetMethod('0');
                                },
                              ),
                              headingWidgetMethodForResources(
                                'P Coins Earned',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2.2,
                      padding: const EdgeInsets.all(10),
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
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: primeColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.arrow_downward_rounded,
                              color: whiteColor,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('wallet')
                                    .where('user_id',
                                        isEqualTo: widget.userNumber)
                                    .snapshots(),
                                builder: (context,
                                    AsyncSnapshot<QuerySnapshot>
                                        streamSnapshot) {
                                  if (streamSnapshot.hasData) {
                                    for (var i = 0;
                                        i < streamSnapshot.data!.docs.length;
                                        i++) {
                                      DocumentSnapshot documentSnapshot =
                                          streamSnapshot.data!.docs[i];
                                      return headingWidgetMethod(
                                        documentSnapshot['total_withdrawal'],
                                      );
                                    }
                                  }
                                  return headingWidgetMethod('0');
                                },
                              ),
                              headingWidgetMethodForResources(
                                'Withdrawals',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: MaterialButton(
                  height: 50,
                  color: purpleColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      backgroundColor: whiteColor,
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => Padding(
                        padding: EdgeInsets.only(
                          top: 10,
                          right: 10,
                          left: 10,
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: purpleColor,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: purpleColor.withOpacity(0.2),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset(
                                            'assets/icons/wallet.png',
                                            height: 40,
                                            width: 60,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Wallet Balance',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10,
                                                ),
                                              ),
                                              Text(
                                                walletbalance,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 0.3,
                                                  fontSize: 16,
                                                  color: whiteColor
                                                      .withOpacity(0.6),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      MaterialButton(
                                        padding: const EdgeInsets.all(2),
                                        color: purpleColor,
                                        shape: const CircleBorder(),
                                        onPressed: () => Navigator.pop(context),
                                        child: FaIcon(
                                          FontAwesomeIcons.xmark,
                                          color: whiteColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(14),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      width: displayWidth(context),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: whiteColor,
                                        boxShadow: [
                                          BoxShadow(
                                            color: primeColor.withOpacity(0.2),
                                            blurRadius: 10,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                      child: TextFormField(
                                        controller: withdrawController,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                        ],
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Enter Points to withdraw',
                                          hintStyle: TextStyle(
                                            letterSpacing: 0.3,
                                            fontWeight: FontWeight.w600,
                                            color:
                                                Colors.black.withOpacity(0.3),
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Center(
                              child: MaterialButton(
                                color: primeColor2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  if (withdrawController.text.isEmpty) {
                                    Navigator.pop(context);
                                    setState(() {
                                      withdrawController.clear();
                                    });
                                    alertDialogWidget(
                                      context,
                                      primeColor,
                                      'Please enter coins to withdraw',
                                    );
                                  } else if (double.parse(
                                          withdrawController.text) >
                                      double.parse(walletbalance)) {
                                    Navigator.pop(context);
                                    setState(() {
                                      withdrawController.clear();
                                    });
                                    alertDialogWidget(
                                      context,
                                      primeColor,
                                      "Insufficient Balance",
                                    );
                                  } else {
                                    var bal = double.parse(walletbalance) -
                                        double.parse(withdrawController.text);
                                    withdrawBalance(bal.toString());
                                  }
                                },
                                child: Text(
                                  "Withdraw P Coins",
                                  style: TextStyle(
                                    color: whiteColor,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.sackDollar,
                        color: whiteColor,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Withdraw P Coins',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: whiteColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 20,
                    ),
                    child: paragraphWidgetMethodForResourcesBoldTitle(
                      'Transaction history',
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 2.3,
                width: MediaQuery.of(context).size.width,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('wallet')
                      .doc(widget.userNumber)
                      .collection('transactions')
                      .snapshots(),
                  builder:
                      (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                    if (streamSnapshot.hasData &&
                        streamSnapshot.data!.docs.isNotEmpty) {
                      return ListView.builder(
                        itemCount: streamSnapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot documentSnapshot =
                              streamSnapshot.data!.docs[index];
                          return Padding(
                            padding: const EdgeInsets.all(10),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.all(10),
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
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          color: documentSnapshot['status'] ==
                                                  "false"
                                              ? Colors.amber
                                              : documentSnapshot['status'] ==
                                                      "true"
                                                  ? primeColor2
                                                  : primeColor,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Icon(
                                          documentSnapshot['type'] ==
                                                  "withdrawal"
                                              ? Icons.arrow_downward_rounded
                                              : Icons.arrow_upward_rounded,
                                          color: whiteColor,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              paragraphWidgetMethodForResourcesBoldTitle(
                                                documentSnapshot['type'] ==
                                                        "withdrawal"
                                                    ? 'Withdrawal Request'
                                                    : 'P Coins Received',
                                              ),
                                              const SizedBox(width: 5),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 4,
                                                  vertical: 2,
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: documentSnapshot[
                                                              'status'] ==
                                                          "false"
                                                      ? Colors.amber
                                                      : documentSnapshot[
                                                                  'status'] ==
                                                              "true"
                                                          ? primeColor2
                                                          : primeColor,
                                                ),
                                                child: Text(
                                                  documentSnapshot['status'] ==
                                                          "false"
                                                      ? 'pending'
                                                      : documentSnapshot[
                                                                  'status'] ==
                                                              "true"
                                                          ? 'success'
                                                          : 'rejected',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10,
                                                    color: whiteColor,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          const SizedBox(height: 3),
                                          headingWidgetMethodForResources(
                                            documentSnapshot['date_time'],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        documentSnapshot['coins'],
                                        style: TextStyle(
                                          color: documentSnapshot['status'] ==
                                                  "false"
                                              ? Colors.amber
                                              : documentSnapshot['status'] ==
                                                      "true"
                                                  ? primeColor2
                                                  : primeColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      headingWidgetMethodForResources(
                                          'P Coins'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                    return Column(
                      children: [
                        Lottie.asset('assets/json/empty.json'),
                        Text(
                          'No record found',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                            color: Colors.black.withOpacity(0.6),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  withdrawBalance(String bal) {
    var formatter = DateFormat('MM/dd/yyyy hh:mm a');

    Navigator.pop(context);
    FirebaseFirestore.instance
        .collection('wallet')
        .doc(widget.userNumber)
        .collection('transactions')
        .add(
      {
        'status': 'false',
        'date_time': formatter.format(DateTime.now()).toString(),
        'type': 'withdrawal',
        'coins': withdrawController.text,
      },
    );
    FirebaseFirestore.instance
        .collection('wallet')
        .doc(widget.userNumber)
        .update(
      {
        'wallet_balance': bal,
      },
    );
    alertDialogWidget(
      context,
      purpleColor,
      'withdraw request send successfully',
    );
    setState(() {
      withdrawController.clear();
    });
  }
}
