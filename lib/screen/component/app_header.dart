import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

import '../../core/config/color.constant.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool? showAction;
  final void Function()? onpress;
  const AppHeader(
      {super.key, required this.title, this.showAction = true, this.onpress});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: AppColor.primaryColor,
        ),
      ),
      centerTitle: true,
      leading: TouchableOpacity(
        onTap: onpress,
        child: Container(
          // width: 20,
          // height: 20,
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColor.greyLightColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Center(
            child: Icon(
              Ionicons.chevron_back,
              size: 25,
              color: AppColor.secondaryColor,
            ),
          ),
        ),
      ),
      // leadingWidth: 40,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
