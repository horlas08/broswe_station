import 'package:browse_station/core/config/color.constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:remixicon/remixicon.dart';

import '../../core/config/font.constant.dart';
import '../../core/helper/helper.dart';

List<String> transactionList = [];
String getTimeFromDateAndTime(String date) {
  DateTime dateTime;
  try {
    dateTime = DateTime.parse(date).toLocal();
    return DateFormat.jm().format(dateTime).toString(); //5:08 PM
// String formattedTime = DateFormat.Hms().format(now);
// String formattedTime = DateFormat.Hm().format(now);   // //17:08  force 24 hour time
  } catch (e) {
    return date;
  }
}

String getDateAndYearWordFromString(String date) {
  DateTime dateTime;
  try {
    dateTime = DateTime.parse(date).toLocal();
    return DateFormat.yMMMEd('en_US').format(dateTime).toString(); //5:08 PM
//     yMMMMd
// String formattedTime = DateFormat.Hms().format(now);
// String formattedTime = DateFormat.Hm().format(now);   // //17:08  force 24 hour time
  } catch (e) {
    return date;
  }
}

class TransactionItem extends StatelessWidget {
  final Map<String, dynamic> data;
  const TransactionItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    data['status'] == 1 ? AppColor.successBg : AppColor.danger,
              ),
              child: _getIconByStatusAndName(
                  name: data['type'].toString().toLowerCase(),
                  status: data['status'])),
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data['type'],
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontFamily: AppFont.segoui, fontWeight: FontWeight.bold),
              ),
              Text(
                "${getDateAndYearWordFromString(data['datetime'])} ${getTimeFromDateAndTime(data['datetime'])}",
                style: Theme.of(context).textTheme.labelSmall,
              )
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${currency(context)}${data['amount'].toString()}',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontFamily: AppFont.segoui, fontWeight: FontWeight.bold),
              ),
              Text(
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: data['status'] == 1
                          ? AppColor.success
                          : AppColor.danger,
                    ),
                data['status'] == 1
                    ? "successful"
                    : data['status'] == 0
                        ? "failed"
                        : "cancelled",
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget _getIconByStatusAndName({required String name, required num status}) {
  if (name.contains('airtime')) {
    return const Icon(
      Ionicons.phone_portrait_outline,
      color: AppColor.success,
    );
  } else if (name.contains('data')) {
    return const Icon(
      Ionicons.wifi,
      color: AppColor.success,
    );
  } else if (name.contains('epin')) {
    return const Icon(
      Ionicons.pricetag,
      color: AppColor.success,
    );
  } else if (name.contains('betting')) {
    return const Icon(
      Ionicons.wifi_outline,
      color: AppColor.success,
    );
  } else if (name.contains('upgrade')) {
    return const Icon(
      Ionicons.wifi_outline,
      color: AppColor.success,
    );
  } else if (name.contains('portraitcuts')) {
    return const Icon(
      Ionicons.bonfire_outline,
      color: AppColor.success,
    );
  } else if (name.contains('monnify')) {
    return const Icon(
      Remix.bank_line,
      color: AppColor.success,
    );
  } else if (name.contains('upgrade')) {
    return const Icon(
      Ionicons.wifi_outline,
      color: AppColor.success,
    );
  } else if (name.contains("admin debit")) {
    return const Icon(
      Boxicons.bx_user_minus,
      color: AppColor.success,
    );
  } else if (name.contains("admin credit")) {
    return const Icon(
      Boxicons.bx_user_plus,
      color: AppColor.success,
    );
  } else {
    return const Icon(
      Ionicons.extension_puzzle_outline,
      color: AppColor.success,
    );
  }
}
