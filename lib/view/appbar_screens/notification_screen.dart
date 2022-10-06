import 'package:flutter/material.dart';
import 'package:primewayskills_app/view/helpers/colors.dart';
import 'package:primewayskills_app/view/helpers/helping_widgets.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primeColor,
        title: Text(
          'Notifications',
          style: TextStyle(
            fontSize: maxSize,
            color: whiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SizedBox(
        height: height,
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: height / 3,
              child: Image.asset(
                'assets/icons/bell_icon.png',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 30),
            headingWidgetMethod("You don't have any notifications yet!"),
          ],
        ),
      ),
    );
  }
}
