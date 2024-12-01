import 'package:browse_station/core/config/color.constant.dart';
import 'package:browse_station/core/config/font.constant.dart';
import 'package:flutter/material.dart';

import '../../../../core/helper/helper.dart';

class Receipt extends StatelessWidget {
  final Map<String, String> data;
  const Receipt({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Container(
          height: 1000,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          decoration: const BoxDecoration(
            color: AppColor.primaryColor,
          ),
          child: IntrinsicHeight(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Image.asset(
                        "assets/images/favicon.png",
                        width: 50,
                      ),
                      const Spacer(),
                      const Text(
                        "Transaction Receipt",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: AppFont.segoui,
                            color: AppColor.greyColor,
                            fontSize: 20),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "${currency(context)} ${data['amount']!}",
                    style: TextStyle(
                        fontSize: 25,
                        color: AppColor.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppFont.segoui),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    data['status']!.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    data['date']!,
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColor.greyColor,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Column(
                    children: [
                      ...List.generate(
                        data.length,
                        (index) {
                          return RowList(
                            key: data.keys.toList()[index],
                            value: data.values.toList()[index],
                            showLine: data.values.length != index + 1,
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  const Text("Support"),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "browsestations@gmail.com",
                    style: TextStyle(color: AppColor.primaryColor),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Thanks for using Browse stations. Dont forget to refer and earn",
                    style: TextStyle(color: AppColor.greyColor),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
