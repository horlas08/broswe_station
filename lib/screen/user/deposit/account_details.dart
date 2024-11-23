import 'package:browse_station/screen/component/app_header2.dart';
import 'package:browse_station/screen/component/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:share_plus/share_plus.dart';
import 'package:toastification/toastification.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

import '../../../core/helper/helper.dart';
import '../../component/button.dart';

class AccountDetails extends StatelessWidget {
  final Map<String, String> accountDetail;
  const AccountDetails({super.key, required this.accountDetail});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      header: AppHeader2(title: "My ${accountDetail['type']} Account"),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Your account details",
          ),
          const SizedBox(
            height: 20,
          ),
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
                  accountDetail.length,
                  (index) {
                    if (accountDetail.keys
                        .toList()[index]
                        .contains("account number")) {
                      return RowList(
                        key: accountDetail.keys.toList()[index],
                        value: accountDetail.values.toList()[index],
                        showLine: accountDetail.values.length != index + 1,
                        suffixIcon: TouchableOpacity(
                          onTap: () {
                            Clipboard.setData(
                              ClipboardData(
                                text: accountDetail['account number']!,
                              ),
                            ).then(
                              (value) {
                                if (context.mounted) {
                                  showToast(context,
                                      title: "Account Number Copy",
                                      desc:
                                          "Account Number ${accountDetail['account number']} Copy Successful",
                                      type: ToastificationType.success);
                                }
                              },
                            );
                          },
                          child: const Icon(
                            Ionicons.copy_outline,
                            size: 15,
                          ),
                        ),
                      );
                    }
                    ;
                    return RowList(
                      key: accountDetail.keys.toList()[index],
                      value: accountDetail.values.toList()[index],
                      showLine: accountDetail.values.length != index + 1,
                    );
                  },
                ),
              ],
            ),
          ),
          /*
          * onTap: () async {
                                  final result = await Share.share(
                                      'Account Number: ${account.accountNumber}  \n Account Name: ${account.accountName} \n Bank Name: ${account.bankName}');

                                  if (result.status ==
                                      ShareResultStatus.success) {
                                    print(
                                        'Thank you for sharing your account details');
                                  }
                                },
          * */
          const SizedBox(
            height: 20,
          ),
          Button(
            text: "Share Account",
            press: () async {
              final result = await Share.share(
                  'Account Number: ${accountDetail['account number']}  \n Account Name: ${accountDetail['account name']} \n Bank Name: ${accountDetail['bank name']}');

              if (result.status == ShareResultStatus.success) {
                if (context.mounted) {
                  showToast(
                    context,
                    title: "account sharing",
                    desc: "Thank you for sharing your account details",
                  );
                }
              }
            },
          )
        ],
      ),
    );
  }
}
