import 'package:flutter/material.dart';
import 'package:primewayskills_app/view/helpers/colors.dart';
import 'package:primewayskills_app/view/profile_screen/affiliate_screens/affiliate_links_screen.dart';
import 'package:primewayskills_app/view/profile_screen/affiliate_screens/affiliate_refer_screen.dart';
import 'package:primewayskills_app/view/profile_screen/affiliate_screens/affiliate_sales_screens.dart';

class AffiliateScreen extends StatefulWidget {
  const AffiliateScreen({super.key});

  @override
  State<AffiliateScreen> createState() => _AffiliateScreenState();
}

class _AffiliateScreenState extends State<AffiliateScreen> {
  bool showSales = true;
  bool showLinks = false;
  bool showCodes = false;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.black.withOpacity(0.6),
          ),
          backgroundColor: whiteColor,
          title: Text(
            'Affiliate Dashboard',
            style: TextStyle(
              fontSize: maxSize,
              color: Colors.black.withOpacity(0.6),
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: TabBar(
            labelColor: primeColor2,
            unselectedLabelColor: Colors.black.withOpacity(0.4),
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            indicatorColor: primeColor2,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorWeight: 3,
            tabs: const [
              Tab(
                text: 'Sales',
              ),
              Tab(
                text: 'Links',
              ),
              Tab(
                text: 'Refferals',
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            AffiliateSalesScreen(),
            AffiliateLinksScreen(),
            AffiliateReferScreen(),
          ],
        ),
      ),
    );
  }
}
