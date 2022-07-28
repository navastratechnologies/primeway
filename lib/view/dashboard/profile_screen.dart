import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:primewayskills_app/view/helpers/colors.dart';
import 'package:primewayskills_app/view/helpers/helping_widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: whiteColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 14, right: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: primeColor,
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(
                          'https://images.unsplash.com/photo-1593104547489-5cfb3839a3b5?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1706&q=80',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    color: primeColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 5,
                        offset: Offset(0.5, 0.5),
                      ),
                    ],
                  ),
                  child: Text(
                    "Download Media Kit",
                    style: TextStyle(
                      color: whiteColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  headingWidgetMethod('About my work'),
                  buttonWidget('Edit'),
                ],
              ),
              SizedBox(height: 10),
              paragraphWidgetMethod(
                'Update this section with more information about the kind of work you do and the content you create',
                context,
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  headingWidgetMethod('Brands Collaborated With'),
                  buttonWidget('Manage'),
                ],
              ),
              SizedBox(height: 10),
              paragraphWidgetMethod(
                'Update this section if you have worked on brand collaborations.',
                context,
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  headingWidgetMethod('Recommendations'),
                  buttonWidget('Manage'),
                ],
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  headingWidgetMethod('Best Work & Achievements'),
                  buttonWidget('Add'),
                ],
              ),
              SizedBox(height: 30),
              Container(
                width: width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        height: 2,
                        decoration: BoxDecoration(
                          color: primeColor,
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    Row(
                      children: [
                        Icon(
                          Icons.lock,
                          color: primeColor,
                        ),
                        SizedBox(width: 5),
                      ],
                    ),
                    Text(
                      'VISIBLE TO YOU & BRANDS',
                      style: TextStyle(
                        color: primeColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: Container(
                        height: 2,
                        decoration: BoxDecoration(
                          color: primeColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  headingWidgetMethod('My Terms & Conditions'),
                  buttonWidget('Edit'),
                ],
              ),
              SizedBox(height: 10),
              paragraphWidgetMethod(
                'Please add your T&C if any when working with a brand.',
                context,
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  headingWidgetMethod('Services'),
                  buttonWidget('Edit'),
                ],
              ),
              SizedBox(height: 10),
              paragraphWidgetMethod(
                'Add pricing for services you may want to provide a brand with. This information is private and only visible to you and the brands you share with.',
                context,
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
