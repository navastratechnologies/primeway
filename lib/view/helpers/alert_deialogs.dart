import 'package:flutter/material.dart';
import 'package:primewayskills_app/view/helpers/colors.dart';

alertDialogWidget(context, color, msg) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: color,
      content: Text(
        msg,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: whiteColor,
        ),
      ),
    ),
  );
}
