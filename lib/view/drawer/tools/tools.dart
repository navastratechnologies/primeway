import 'package:flutter/material.dart';
import 'package:primewayskills_app/view/drawer/sidebar.dart';
import 'package:primewayskills_app/view/helpers/colors.dart';

class ToolsScreen extends StatelessWidget {
  final String userNumber;
  final String userName;
  final String userAddress;
  final String userProfileImage;
  final String userPayment;
  final String userEmail;
  final String userWalletId;
  const ToolsScreen(
      {Key? key,
      required this.userNumber,
      required this.userName,
      required this.userAddress,
      required this.userProfileImage,
      required this.userPayment,
      required this.userEmail,
      required this.userWalletId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawer(
        userAddress: userAddress,
        userEmail: userEmail,
        userName: userName,
        userNumber: userNumber,
        userPayment: userPayment,
        userProfileImage: userProfileImage,
        userWalletId: userWalletId,
      ),
      appBar: AppBar(
        backgroundColor: primeColor,
        title: const Text("ToolsScreen"),
      ),
    );
  }
}
