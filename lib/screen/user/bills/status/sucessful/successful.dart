import 'package:auto_size_text/auto_size_text.dart';
import 'package:browse_station/screen/component/button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ripple_wave/ripple_wave.dart';

import '../../../../../core/config/color.constant.dart';
import '../../../../../core/config/font.constant.dart';

class Successful extends StatelessWidget {
  final String message;
  const Successful({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 28.0, horizontal: 20),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 200,
                  height: 200,
                  child: RippleWave(
                    color: AppColor.primaryColor,
                    child: Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        color: AppColor.primaryColor,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 70,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const AutoSizeText(
                  "Transaction Successful",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                ),
                AutoSizeText(
                  message,
                  style: const TextStyle(
                    // fontSize: 30,
                    fontFamily: AppFont.segoui,
                    fontWeight: FontWeight.w500,
                    color: AppColor.greyColor,
                  ),
                  maxLines: 3,
                ),
                const SizedBox(
                  height: 30,
                ),
                Button(
                  text: "View Details",
                  press: () {
                    context.goNamed('transactions');
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextButton(
                    onPressed: () {
                      context.go('/user');
                    },
                    child: const Text(
                      "Go home",
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
