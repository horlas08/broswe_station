import 'package:browse_station/core/config/color.constant.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

class AllServices extends StatelessWidget {
  const AllServices({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> allServices = [
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
        "name": "Power",
        "desc": 'Top up prepaid electricity meter',
        "route": "/electricity"
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
        "icon": Ionicons.basketball,
        "name": "Fund Betting Wallet",
        "desc": 'Fund your betting wallet',
        "route": "/betting"
      }
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Flex(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            direction: Axis.horizontal,
            children: [
              TouchableOpacity(
                onTap: () {
                  context.go('/airtime');
                },
                child: Column(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Center(
                        child: Icon(
                          Ionicons.phone_portrait_outline,
                          size: 30,
                          color: AppColor.secondaryColor,
                        ),
                      ),
                    ),
                    Text("Airtime"),
                  ],
                ),
              ),
              TouchableOpacity(
                onTap: () {
                  context.go('/data');
                },
                child: Column(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColor.primaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Center(
                        child: Icon(
                          Ionicons.phone_portrait,
                          size: 30,
                          color: AppColor.secondaryColor,
                        ),
                      ),
                    ),
                    Text("Data"),
                  ],
                ),
              ),
              TouchableOpacity(
                onTap: () {
                  context.go('/cable');
                },
                child: Column(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColor.primaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Center(
                        child: Icon(
                          Ionicons.tv,
                          size: 30,
                          color: AppColor.secondaryColor,
                        ),
                      ),
                    ),
                    Text("TV"),
                  ],
                ),
              ),
              TouchableOpacity(
                onTap: () {
                  context.go('/electricity');
                },
                child: Column(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColor.primaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Center(
                        child: Icon(
                          Ionicons.flash_outline,
                          size: 30,
                          color: AppColor.secondaryColor,
                        ),
                      ),
                    ),
                    Text("Power"),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Flex(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            direction: Axis.horizontal,
            children: [
              TouchableOpacity(
                onTap: () {
                  context.go('/esim');
                },
                child: Column(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColor.primaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Center(
                        child: Icon(
                          Ionicons.extension_puzzle_outline,
                          size: 30,
                          color: AppColor.secondaryColor,
                        ),
                      ),
                    ),
                    const Text("E-SIM"),
                  ],
                ),
              ),
              TouchableOpacity(
                onTap: () {
                  context.go('/gift-card');
                },
                child: Column(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColor.primaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Center(
                        child: Icon(
                          Ionicons.gift_outline,
                          size: 30,
                          color: AppColor.secondaryColor,
                        ),
                      ),
                    ),
                    Text("Gift Card"),
                  ],
                ),
              ),
              TouchableOpacity(
                onTap: () {
                  context.go('/betting');
                },
                child: Column(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColor.primaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Center(
                        child: Icon(
                          Ionicons.basketball,
                          size: 30,
                          color: AppColor.secondaryColor,
                        ),
                      ),
                    ),
                    Text("Betting"),
                  ],
                ),
              ),
              TouchableOpacity(
                onTap: () {
                  context.go('/all/bill');
                },
                child: Column(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColor.primaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Center(
                        child: Icon(
                          Ionicons.ellipsis_horizontal,
                          size: 30,
                          color: AppColor.secondaryColor,
                        ),
                      ),
                    ),
                    Text("More"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
