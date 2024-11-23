import 'package:browse_station/core/config/color.constant.dart';
import 'package:browse_station/screen/component/dashboard/all_services.dart';
import 'package:browse_station/screen/component/dashboard/balance_card.dart';
import 'package:browse_station/screen/component/dashboard/dashboard_header.dart';
import 'package:browse_station/screen/component/dashboard/transaction.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffordBg,
      body: const SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(18),
            child: Column(
              children: [
                DashboardHeader(),
                SizedBox(
                  height: 20,
                ),
                BalanceCard(),
                SizedBox(
                  height: 50,
                ),
                AllServices(),
                SizedBox(
                  height: 50,
                ),
                Transaction()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
