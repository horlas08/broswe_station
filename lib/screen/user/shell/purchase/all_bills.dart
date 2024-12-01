import 'package:browse_station/core/config/color.constant.dart';
import 'package:browse_station/screen/component/app_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';

import '../../../component/all_bill_items.dart';

class AllBills extends StatelessWidget {
  const AllBills({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffordBg,
      appBar: AppHeader(title: "Bills & Utilities"),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemBuilder: (BuildContext context, index) {
                  return AllBillItems(
                    name: allBills[index]['name'],
                    icon: allBills[index]['icon'],
                    onTap: () {
                      context.push(
                        allBills[index]['route'],
                      );
                    },
                    desc: allBills[index]['desc'],
                  );
                },
                itemCount: allBills.length,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final List<Map<String, dynamic>> allBills = [
  {
    "icon": Ionicons.phone_portrait_outline,
    "name": "Airtime",
    "desc": 'Buy airtime for all Network',
    "route": "/airtime"
  },
  {
    "icon": Ionicons.phone_portrait,
    "name": "Data",
    "desc": 'Buy cheap data bundle',
    "route": "/data"
  },
  {
    "icon": Ionicons.tv,
    "name": "Cable Tv",
    "desc": 'Pay for cable tv subscription',
    "route": "/cable"
  },
  {
    "icon": Ionicons.flash_outline,
    "name": "Electricity",
    "desc": 'Top up prepaid electricity meter',
    "route": "/electricity"
  },
  {
    "icon": Ionicons.card_outline,
    "name": "Deposit",
    "desc": 'Deposit fund to your account',
    "route": "/deposit"
  },
  {
    "icon": Ionicons.gift_outline,
    "name": "Gift Card",
    "desc": 'Buying and selling of gift-card here',
    "route": "/gift-card"
  },
  {
    "icon": Ionicons.extension_puzzle_outline,
    "name": "E-SIM",
    "desc": 'Get your esim instantly',
    "route": "/esim"
  },
  {
    "icon": Ionicons.school,
    "name": "Education",
    "desc": 'Buy education services',
    "route": "/education"
  },
  {
    "icon": Ionicons.basketball,
    "name": "Fund Betting Wallet",
    "desc": 'Fund your betting wallet',
    "route": "/betting"
  },
  {
    "icon": Boxicons.bxs_bank,
    "name": "Withdraw",
    "desc": 'Withdraw your Funds',
    "route": "/withdraw"
  },
];
