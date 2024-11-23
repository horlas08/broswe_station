import 'package:browse_station/core/helper/helper.dart';
import 'package:browse_station/screen/component/button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';

import '../../component/app_header2.dart';
import '../../component/custom_scaffold.dart';

class ConfirmTransaction extends StatelessWidget {
  final Map<String, String> data;
  final Map<String, String> viewData;
  final Function callback;
  const ConfirmTransaction(
      {super.key,
      required this.data,
      required this.callback,
      required this.viewData});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      header: const AppHeader2(
        title: 'Confirm Transaction',
      ),
      headerDesc:
          'Verify and confirm your transaction details before you proceed to pay.',
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.only(top: 40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                ...List.generate(
                  viewData.length,
                  (index) {
                    return RowList(
                      key: viewData.keys.toList()[index],
                      value: viewData.values.toList()[index],
                      showLine: viewData.values.length != index + 1,
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Button(
            text: "Complete",
            press: () async {
              print(data);
              var appBox = Hive.box('appDBox');
              // await appBox.put("transactionData", data);
              if (context.mounted) {
                context.push("/validate", extra: {
                  'data': data,
                  'function': callback,
                });
              }
            },
          )
        ],
      ),
    );
  }
}
