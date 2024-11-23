import 'package:flutter/material.dart';

import 'bottom_nav_item.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;
  const BottomNav({required this.currentIndex, super.key, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        children: [
          Expanded(
            child: BottomNavItem(
              onTap: onTap,
              icon: "assets/svg/bx-home-alt.svg",
              current: currentIndex,
              name: 0,
              label: 'Home',
            ),
          ),
          Expanded(
            child: BottomNavItem(
              onTap: onTap,
              icon: "assets/svg/bx-store.svg",
              current: currentIndex,
              name: 1,
              label: 'Purchase',
            ),
          ),
          Expanded(
            child: BottomNavItem(
              onTap: onTap,
              icon: "assets/svg/bonfire.svg",
              current: currentIndex,
              name: 2,
              label: 'Portraitcuts',
            ),
          ),
          Expanded(
            child: BottomNavItem(
              onTap: onTap,
              icon: "assets/svg/bx-transfer.svg",
              current: currentIndex,
              name: 3,
              label: 'Transaction',
            ),
          ),
          Expanded(
            child: BottomNavItem(
              onTap: onTap,
              icon: "assets/svg/bx-user.svg",
              current: currentIndex,
              name: 4,
              label: 'Profile',
            ),
          ),
        ],
      ),
    );
  }
}
