import 'package:flutter/material.dart';
import 'package:primewayskills_app/view/drawer/sidebar.dart';
import 'package:primewayskills_app/view/helpers/colors.dart';
import 'package:primewayskills_app/view/helpers/helping_widgets.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool isSwitched = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawer(),
      appBar: AppBar(
        backgroundColor: primeColor,
        title: Text("Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                headingWidgetMethod('Terms Of Service'),
                SizedBox(height: 5),
                paragraphWidgetMethod('Read Terms Of Service', context),
                SizedBox(height: 14),
                Divider(),
              ],
            ),
            SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                headingWidgetMethod('Privacy Policy'),
                SizedBox(height: 5),
                paragraphWidgetMethod('Read Privacy Policy', context),
                SizedBox(height: 20),
                Divider(),
              ],
            ),
            SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                headingWidgetMethod('Contact Us'),
                SizedBox(height: 20),
                Divider(),
              ],
            ),
            SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                headingWidgetMethod('App Version'),
                SizedBox(height: 5),
                paragraphWidgetMethod('1.0.0', context),
                SizedBox(height: 20),
                Divider(),
              ],
            ),
            SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    headingWidgetMethod('Push Notifications'),
                    Switch(
                      value: isSwitched,
                      onChanged: (value) {
                        setState(
                          () {
                            isSwitched = value;
                            print(isSwitched);
                          },
                        );
                      },
                      activeTrackColor: Colors.blue.withOpacity(0.5),
                      activeColor: Colors.blue,
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Divider(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
