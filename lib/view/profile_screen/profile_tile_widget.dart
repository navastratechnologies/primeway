import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:primewayskills_app/view/helpers/colors.dart';
import 'package:primewayskills_app/view/helpers/helping_widgets.dart';

class ProfileTileWidget extends StatelessWidget {
  final String heading;
  final IconData icons;
  const ProfileTileWidget({
    Key? key,
    required this.heading,
    required this.icons,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
        top: 20,
        bottom: 10,
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: primeColor.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                paragraphWidgetMethodForResourcesBoldTitle(heading),
                const SizedBox(height: 20),
                Row(
                  children: [
                    headingWidgetMethodForResources(
                      'Go Next',
                    ),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.black.withOpacity(0.4),
                      size: 18,
                    ),
                  ],
                ),
              ],
            ),
            FaIcon(
              icons,
              color: Colors.black,
              size: 30,
            ),
          ],
        ),
      ),
    );
  }
}
