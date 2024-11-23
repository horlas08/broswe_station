import 'package:flutter/material.dart';

import '../../core/config/color.constant.dart';

class CustomScaffold extends StatelessWidget {
  final Widget header;
  final String? headerDesc;
  final Widget child;
  const CustomScaffold(
      {super.key, required this.header, this.headerDesc, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      body: Column(
        children: [
          header,
          if (headerDesc != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                headerDesc!,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColor.scaffordBg,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 100,
                    margin: const EdgeInsets.only(top: 20),
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColor.greyLightColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: child,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
