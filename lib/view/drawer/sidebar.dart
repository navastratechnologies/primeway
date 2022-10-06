import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:primewayskills_app/view/dashboard/dashboard.dart';
import 'package:primewayskills_app/view/drawer/resources/resources.dart';
import 'package:primewayskills_app/view/drawer/setting/setting.dart';
import 'package:primewayskills_app/view/helpers/colors.dart';
import 'package:primewayskills_app/view/helpers/helping_widgets.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Drawer(
        backgroundColor: primeColor,
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SafeArea(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: primeColor,
                          border: Border(
                            bottom: BorderSide(
                              color: whiteColor.withOpacity(0.6),
                              width: 2,
                            ),
                          ),
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                InkWell(
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: whiteColor,
                                      shape: BoxShape.circle,
                                      image: const DecorationImage(
                                        image: NetworkImage(
                                          'https://images.unsplash.com/photo-1593104547489-5cfb3839a3b5?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1706&q=80',
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Username",
                                      style: TextStyle(
                                        color: whiteColor,
                                        fontSize: maxSize,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "useremail@gmail.com",
                                      style: TextStyle(
                                        color: whiteColor.withOpacity(0.6),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Icon(
                              Icons.edit,
                              color: whiteColor.withOpacity(0.6),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Wrap(
                        runSpacing: 10,
                        children: [
                          ListTile(
                            leading: sidebarIconWidget(Icons.home_filled),
                            title: Text(
                              "Home",
                              style: TextStyle(
                                color: whiteColor,
                              ),
                            ),
                            onTap: () => {
                              Navigator.pop(context),
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const Dashboard(),
                                ),
                              ),
                            },
                            trailing: FaIcon(
                              FontAwesomeIcons.chevronRight,
                              color: whiteColor.withOpacity(0.6),
                              size: 16,
                            ),
                          ),
                          ListTile(
                            leading: sidebarIconWidget(Icons.tips_and_updates),
                            title: Text(
                              "Resources",
                              style: TextStyle(
                                color: whiteColor,
                              ),
                            ),
                            onTap: () => {
                              Navigator.pop(context),
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ResourcesScreen(),
                                ),
                              ),
                            },
                            trailing: FaIcon(
                              FontAwesomeIcons.chevronRight,
                              color: whiteColor.withOpacity(0.6),
                              size: 18,
                            ),
                          ),
                          ListTile(
                            leading: sidebarIconWidget(Icons.settings),
                            title: Text(
                              "Settings",
                              style: TextStyle(
                                color: whiteColor,
                              ),
                            ),
                            onTap: () => {
                              Navigator.pop(context),
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const SettingScreen(),
                                ),
                              ),
                            },
                            trailing: FaIcon(
                              FontAwesomeIcons.chevronRight,
                              color: whiteColor.withOpacity(0.6),
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    ListTile(
                      leading: sidebarIconWidget(Icons.logout),
                      title: Text(
                        "Logout",
                        style: TextStyle(
                          color: whiteColor,
                        ),
                      ),
                      onTap: () => {
                        Navigator.pop(context),
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const Dashboard(),
                          ),
                        ),
                      },
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
}
