import 'package:flutter/material.dart';
import 'package:primewayskills_app/view/helpers/colors.dart';

headingWidgetMethod(heading) {
  return Text(
    heading,
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: maxSize,
    ),
  );
}

paragraphWidgetMethod(text, context) {
  var width = MediaQuery.of(context).size.width;
  return SizedBox(
    width: width / 1.15,
    child: Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w500,
        color: Colors.black.withOpacity(0.4),
      ),
    ),
  );
}

buttonWidget(text) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 10),
    width: 80,
    decoration: BoxDecoration(
      color: primeColor,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.4),
          blurRadius: 5,
          offset: const Offset(0.5, 0.5),
        ),
      ],
    ),
    child: Center(
      child: Text(
        text,
        style: TextStyle(
          color: whiteColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}

sidebarIconWidget(icon) {
  return Icon(
    icon,
    color: whiteColor.withOpacity(0.6),
  );
}

editProfileCardWidget(text) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: whiteColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'INCOMPLETE',
                style: TextStyle(
                  color: primeColor,
                  fontSize: 10,
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'EDIT',
                  style: TextStyle(
                    color: primeColor,
                    fontSize: 12,
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          headingWidgetMethod(text),
        ],
      ),
    ),
  );
}

listOrderWidget(text) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Container(
        padding: const EdgeInsets.all(4),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black,
        ),
      ),
      const SizedBox(width: 10),
      Text(
        text,
        style: TextStyle(
          color: Colors.black.withOpacity(0.4),
          fontWeight: FontWeight.w400,
        ),
      ),
    ],
  );
}

headingWidgetMethodForResources(heading) {
  return Text(
    heading,
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
      color: Colors.black.withOpacity(0.2),
    ),
  );
}

paragraphWidgetMethodForResources(text, context) {
  var width = MediaQuery.of(context).size.width;
  return SizedBox(
    width: width / 1.15,
    child: Text(
      text,
      style: TextStyle(
        color: whiteColor,
      ),
    ),
  );
}

paragraphWidgetMethodForResourcesBold(heading) {
  return Text(
    heading,
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: maxSize - 1,
    ),
  );
}

paragraphWidgetMethodForResourcesBoldTitle(heading) {
  return Text(
    heading,
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: maxSize - 3,
    ),
  );
}
