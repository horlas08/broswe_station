import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widget/bottom_nav.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  /// Constructs an [ScaffoldWithNavBar].
  const ScaffoldWithNavBar({
    required this.child,
    super.key,
  });

  /// The widget to display in the body of the Scaffold.
  /// In this sample, it is a Navigator.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: child,
      bottomNavigationBar: BottomNav(
        currentIndex: _calculateSelectedIndex(context),
        onTap: (int idx) => _onItemTapped(idx, context),
      ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    print(location);

    if (location == ('/all/bill')) {
      return 1;
    } else if (location == ('/portraitcuts')) {
      return 2;
    } else if (location == ('/user/transactions')) {
      return 3;
    } else if (location == ('/user/profile')) {
      return 4;
    } else if (location == '/user') {
      return 0;
    }
    return 1;
  }

  void _onItemTapped(int index, BuildContext context) {
    // final location = GoRouterState.of(context).uri;
    print(_calculateSelectedIndex(context));
    print(index);

    switch (index) {
      case 0:
        GoRouter.of(context).push('/user');
      case 1:
        GoRouter.of(context).push('/all/bill');
      case 2:
        GoRouter.of(context).push('/portraitcuts');
      case 3:
        GoRouter.of(context).push('/user/transactions');
      case 4:
        GoRouter.of(context).push('/user/profile');
    }
  }
}
