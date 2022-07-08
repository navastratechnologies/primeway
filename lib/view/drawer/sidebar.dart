import 'package:flutter/material.dart';
import 'package:primewayskills_app/view/dashboard/home.dart';
import 'package:primewayskills_app/view/drawer/resources/resources.dart';
import 'package:primewayskills_app/view/drawer/setting/setting.dart';
import 'package:primewayskills_app/view/drawer/tools/tools.dart';
import 'package:primewayskills_app/view/helpers/colors.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Drawer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              header(context),
              MenuItem(context),
            ],
          ),
        ),
      );
  Widget header(BuildContext context) => Container( 
    color: whiteColor,

        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Row(
          children: [
            InkWell(
  child: Icon(Icons.person,size: 100,color: primeColor,),
  onTap: (){
      //action code when clicked
     
  },
),
           
     SizedBox(
     height: 12,
    ),
    Column(
      children: [
        Text("Rohit", style: TextStyle(color: primeColor,fontSize: 20,fontWeight: FontWeight.w400),),
        Text("Emailoftheerson@gmail.com", style: TextStyle(color: primeColor,fontSize: 15,fontWeight: FontWeight.w400),),
      ],
    ),


          ],
        ),
      );
  Widget MenuItem(BuildContext buildContext) => Wrap(
        runSpacing: 30,
        children: [

          ListTile(               
            leading: const Icon(Icons.home_outlined),
            title: const Text("Home"),
            onTap: () => {

              Navigator.pop(buildContext),
              Navigator.of(buildContext).push(
                MaterialPageRoute(
                  builder: (context) =>  Homescreen(),
                ),
              ),
            },
          ),
          ListTile(
            leading: const Icon(Icons.handyman),
            title: const Text(
              "Tools",
            ),
            onTap: () => {
              Navigator.pop(buildContext),
              Navigator.of(buildContext).push(
                MaterialPageRoute(
                  builder: (context) => const ToolsScreen(),
                ),
              ),
            },
          ),
          ListTile(
            leading: const Icon(Icons.tips_and_updates),
            title: const Text("Resources"),
            onTap: () => {
              Navigator.pop(buildContext),
              Navigator.of(buildContext).push(
                MaterialPageRoute(
                  builder: (context) => const ResourcesScreen(),
                ),
              ),
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Setting"),
            onTap: () => {
              Navigator.pop(buildContext),
              Navigator.of(buildContext).push(
                MaterialPageRoute(
                  builder: (context) => const SettingScreen(),
                ),
              ),
            },
          ),
          SizedBox(
            height: 300,
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () {},
          ),
        ],
      );
}
