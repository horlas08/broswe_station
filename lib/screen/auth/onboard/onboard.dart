import 'package:auto_size_text/auto_size_text.dart';
import 'package:browse_station/core/config/color.constant.dart';
import 'package:browse_station/core/config/font.constant.dart';
import 'package:browse_station/screen/component/button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

class Onboard extends StatelessWidget {
  const Onboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 14,
              child: Stack(
                children: [
                  Positioned(
                    top: -40,
                    bottom: 1,
                    left: 1,
                    right: 1,
                    child: Image.asset(
                      "assets/images/box_bg.png",
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 14,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const AutoSizeText(
                      "All your data, airtime, and bill needs in one app.",
                      maxLines: 2,
                      minFontSize: 30,
                      maxFontSize: 35,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: AppColor.primaryColor,
                        fontFamily: AppFont.futura,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const AutoSizeText(
                      "Simplify your life with easy access to data, airtime, cable TV, electricity bills, betting top-ups, and education pins—all in one place.",
                      maxLines: 2,
                      minFontSize: 10,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: AppColor.primaryColor,
                        fontFamily: AppFont.futura,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    Button(
                      text: "Get Started",
                      press: () {
                        context.go('/register');
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Aleady have an account?",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        TouchableOpacity(
                          activeOpacity: 0.3,
                          onTap: () {
                            context.go('/login');
                          },
                          child: Text(
                            "Sign In",
                            style: TextStyle(
                              fontSize: 15,
                              color: AppColor.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
