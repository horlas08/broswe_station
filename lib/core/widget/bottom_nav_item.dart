import 'package:browse_station/core/config/color.constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BottomNavItem extends StatelessWidget {
  final void Function(int) onTap;
  final String icon;
  final String label;
  final int current;
  final int name;

  const BottomNavItem(
      {super.key,
      required this.onTap,
      required this.icon,
      required this.current,
      required this.name,
      required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            // print(name);
            // print(current);
            onTap(name);
          },
          child: name == 2
              ? SvgPicture.asset(
                  icon,
                  height: 22,
                )
              : SvgPicture.asset(
                  icon,
                  height: 22,
                  color: name == current
                      ? AppColor.secondaryColor.withOpacity(0.8)
                      : Colors.black.withOpacity(0.6),
                ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: name == current
                  ? AppColor.secondaryColor.withOpacity(0.8)
                  : Colors.black.withOpacity(0.6),
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
