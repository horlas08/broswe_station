import 'package:browse_station/core/config/color.constant.dart';
import 'package:browse_station/core/config/font.constant.dart';
import 'package:browse_station/core/state/bloc/repo/app/app_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:remixicon/remixicon.dart';

import '../../../core/helper/helper.dart';

class BalanceCard extends HookWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AppBloc>().state.user;
    return Container(
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
              Text(
                "${currency(context)} ${user?.balance}",
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
                onPressed: () {},
                icon: const Icon(
                  Icons.remove_red_eye,
                  color: Colors.white,
                ),
              )
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
    );
  }
}
