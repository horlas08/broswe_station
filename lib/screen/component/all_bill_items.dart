import 'package:browse_station/core/config/color.constant.dart';
import 'package:flutter/material.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

import '../../core/config/font.constant.dart';

class AllBillItems extends StatelessWidget {
  final String name;
  final String desc;
  final IconData icon;
  final IconData? arrow;
  final VoidCallback onTap;
  const AllBillItems(
      {super.key,
      required this.name,
      required this.icon,
      this.arrow,
      required this.onTap,
      required this.desc});

  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      onTap: onTap,
      child: Container(
        height: 70,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColor.primaryColor,
              size: 35,
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 20,
                    color: AppColor.primaryColor,
                    fontFamily: AppFont.segoui,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  desc,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColor.greyColor,
                    fontFamily: AppFont.segoui,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
            Spacer(),
            Icon(
              arrow ?? Icons.arrow_forward_ios_rounded,
            )
          ],
        ),
      ),
    );
  }
}
