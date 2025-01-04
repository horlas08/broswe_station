import 'package:browse_station/core/config/color.constant.dart';
import 'package:browse_station/core/config/font.constant.dart';
import 'package:browse_station/core/state/bloc/repo/app/app_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:remixicon/remixicon.dart';
import 'package:widget_visibility_detector/widget_visibility_detector.dart';

import '../../../core/helper/helper.dart';
import '../../../core/service/request/protected.dart';
import '../../../core/state/bloc/repo/app/app_state.dart';

class BalanceCard extends HookWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final hideBalance = useState<bool>(false);
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        return WidgetVisibilityDetector(
          onAppear: () async {
            await refreshUserDetails(context, showLoading: false);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 10,
            ),
            decoration: BoxDecoration(
                color: AppColor.primaryColor,
                borderRadius: BorderRadius.circular(20)),
            constraints: const BoxConstraints(
              minHeight: 140,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    hideBalance.value
                        ? const Text(
                            "***.**",
                            style: TextStyle(
                              fontFamily: AppFont.segoui,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                          )
                        : Text(
                            "${currency(context)} ${state.user?.balance}",
                            style: TextStyle(
                              fontFamily: AppFont.segoui,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                          ),
                    const SizedBox(
                      width: 40,
                    ),
                    IconButton(
                      onPressed: () {
                        hideBalance.value = !hideBalance.value;
                      },
                      icon: Icon(
                        !hideBalance.value
                            ? Icons.remove_red_eye
                            : Icons.visibility_off,
                        color: Colors.white,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                        onPressed: () {
                          refreshUserDetails(context);
                        },
                        icon: Icon(
                          Ionicons.refresh,
                          color: Colors.white,
                        ))
                  ],
                ),
                const SizedBox(
                  height: 4,
                ),
                const Text(
                  "Total Balance",
                  style: TextStyle(
                    fontFamily: AppFont.segoui,
                    color: Colors.white,
                    // fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: ButtonStyle(
                          side: WidgetStatePropertyAll(
                            BorderSide(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        onPressed: () {
                          context.go('/deposit');
                        },
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Remix.add_circle_line,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Add Fund",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: OutlinedButton(
                        style: const ButtonStyle(
                          side: WidgetStatePropertyAll(
                            BorderSide(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        onPressed: () {
                          context.go('/withdraw');
                        },
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Remix.telegram_line,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Withdraw",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
