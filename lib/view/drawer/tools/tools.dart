import 'package:flutter/material.dart';
import 'package:primewayskills_app/view/drawer/sidebar.dart';
import 'package:primewayskills_app/view/helpers/colors.dart';

class ToolsScreen
 extends StatelessWidget {
  const ToolsScreen
  ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavigationDrawer(),  
    appBar: AppBar(
      backgroundColor: primeColor,
      title: Text("ToolsScreen"),
    ),


    );
  }
}