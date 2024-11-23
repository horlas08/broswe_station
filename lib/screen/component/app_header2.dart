import 'package:browse_station/core/config/color.constant.dart';
import 'package:browse_station/core/config/font.constant.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

class AppHeader2 extends StatelessWidget {
  final String title;
  final double topSpace;
  final Color titleColor;
  final bool? showAction;
  final bool? showBack;
  final IconData? iconData;
  final void Function()? onPress;
  final void Function()? onIconPress;

  const AppHeader2(
      {super.key,
      required this.title,
      this.showAction = true,
      this.showBack = true,
      this.topSpace = 20,
      this.onPress,
      this.iconData,
      this.onIconPress,
      this.titleColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).viewPadding.top;
    return Column(
      children: [
        SizedBox(
          height: topSpace + height,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: showBack == true
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.center,
            children: [
              if (showBack != null && showBack == true)
                TouchableOpacity(
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Icon(
                        Ionicons.chevron_back,
                        size: 35,
                        color: AppColor.secondaryColor,
                      ),
                    ),
                  ),
                  onTap: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go("/");
                    }
                  },
                ),
              Text(
                title,
                style: TextStyle(
                  color: titleColor,
                  fontSize: 25,
                  fontFamily: AppFont.segoui,
                ),
              ),
              if (onIconPress != null)
                IconButton(
                  onPressed: onIconPress,
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.white),
                  ),
                  icon: Icon(
                    iconData,
                    size: 30,
                    color: Colors.black,
                  ),
                )
              else
                const SizedBox()
            ],
          ),
        ),
      ],
    );
  }
}
