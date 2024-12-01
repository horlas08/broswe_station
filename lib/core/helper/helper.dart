import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:browse_station/core/config/color.constant.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

import '../config/app.constant.dart';
import '../config/font.constant.dart';
import '../service/http.dart';

void showToast(
  BuildContext context, {
  required String title,
  ToastificationType? type = ToastificationType.error,
  AlignmentGeometry? align,
  Duration? duration = const Duration(seconds: 5),
  required String desc,
}) {
  toastification.show(
    context: context,
    type: type,
    title: AutoSizeText(
      title,
      maxLines: 1,
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
    description: AutoSizeText(
      "$desc",
      maxLines: 2,
    ),
    style: ToastificationStyle.minimal,
    closeOnClick: true,
    showProgressBar: false,
    alignment: align,
    autoCloseDuration: duration,
    // primaryColor: AppColor.primaryColor,
  );
}

Future<Response?> refreshUSerDetail() async {
  var appBox = Hive.box("appBox");
  final res = await dio.get(getUserDetails, data: {
    'token': appBox.get('token'),
  });

  return res;
}

String currency(BuildContext context) {
  var format = NumberFormat.simpleCurrency(name: 'NGN');
  return format.currencySymbol;
}

Future<void> deleteFile(File file) async {
  try {
    if (await file.exists()) {
      await file.delete();
    }
  } catch (e) {
    // Error in getting access to the file.
  }
}

Future handleLogout() async {
  var appBox = Hive.box("appBox");
  var appDBox = Hive.box("appDBox");
  await appDBox.clear();
  await appBox.clear();
}

Future<String?> getLastTransactionId() async {
  var appBox = Hive.box("appBox");
  return appBox.get("lastTrxId");
}

Future<void> putLastTransactionId(String id) async {
  var appBox = Hive.box("appBox");
  return appBox.put("lastTrxId", id);
}

Map<String, String> getMapFromTransaction({required dynamic data}) {
  return Map.fromEntries(
    (data as Map).entries.where((entry) {
      return !(entry.key.toString() == 'id' ||
          entry.key.toString() == 'userid' ||
          entry.key.toString().contains('curr') ||
          entry.key.toString().contains('prev'));
    }).map((entry) {
      if (entry.key.toString() == 'status') {
        return MapEntry(
          entry.key.toString(),
          entry.value.toString() == '0'
              ? 'unsuccessful'
              : entry.value.toString() == '1'
                  ? 'successful'
                  : 'cancelled',
        );
      }
      if (entry.key.toString() == 'datetime') {
        return MapEntry("date", entry.value.toString());
      }
      return MapEntry(
        entry.key.toString(),
        entry.value.toString(),
      );
    }),
  );
}

Widget RowList(
    {required String key,
    required String value,
    bool showLine = true,
    Widget? suffixIcon}) {
  return Column(
    children: [
      Row(
        children: [
          Text(
            key.capitalize(),
            style: TextStyle(
              fontFamily: AppFont.futura,
              color: Colors.black.withOpacity(0.6),
              fontWeight: FontWeight.w100,
            ),
          ),
          const Spacer(),
          SizedBox(
            // width: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AutoSizeText(
                  "${value.toLowerCase().contains('amount') ? "₦" : ""}${value.capitalize()}",
                  style: TextStyle(
                    fontFamily: AppFont.segoui,
                    color: key == 'status'
                        ? value == 'successful'
                            ? AppColor.success
                            : AppColor.danger
                        : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.clip,
                  softWrap: true,
                  wrapWords: true,
                  textAlign: TextAlign.end,
                  maxLines: 2,
                ),
                if (suffixIcon != null) suffixIcon
              ],
            ),
          ),
        ],
      ),
      if (showLine)
        const SizedBox(
          height: 5,
        ),
      if (showLine) const Divider(),
      SizedBox(
        height: 15,
      )
    ],
  );
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}

Widget ListCard(
    {IconData? icon,
    String? svgPath,
    required String name,
    bool isSvg = false,
    Widget arrowEnd = const Icon(
      Icons.arrow_forward_ios_rounded,
      color: AppColor.primaryColor,
    ),
    Color? iconColor = AppColor.secondaryColor,
    EdgeInsetsGeometry margin =
        const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    required String desc,
    void Function()? onTap}) {
  return TouchableOpacity(
    onTap: onTap,
    child: Container(
      height: 70,
      margin: margin,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Row(
        children: [
          !isSvg
              ? Icon(
                  icon,
                  color: iconColor,
                  size: 35,
                )
              : SvgPicture.asset(
                  svgPath!,
                  width: 30,
                ),
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 15,
                  fontFamily: AppFont.segoui,
                  color: AppColor.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                desc,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColor.greyColor,
                  fontFamily: AppFont.segoui,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
          const Spacer(),
          arrowEnd
        ],
      ),
    ),
  );
}

void showAppDialog(
  BuildContext context, {
  double height = 200,
  required Widget child,
  EdgeInsetsGeometry? margin = const EdgeInsets.symmetric(horizontal: 20),
}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "true",
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 700),
    pageBuilder: (_, __, ___) {
      return Center(
        child: Container(
          height: height,
          margin: margin,
          child: SizedBox.expand(
            child: Material(
              borderRadius: BorderRadius.circular(10),
              child: child,
            ),
          ),
        ),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      Tween<double> tween;
      if (anim.status == AnimationStatus.reverse) {
        tween = Tween(begin: 0, end: 1);
      } else {
        tween = Tween(begin: 0, end: 1);
      }

      return ScaleTransition(
        scale: tween.animate(anim),
        // position: tween.animate(anim),
        child: FadeTransition(
          opacity: anim,
          child: child,
        ),
      );
    },
  );
}

String toDateTimeLocal(DateTime dateTime) {
  return "${dateTime.toLocal().year.toString().padLeft(4, '0')}-${dateTime.toLocal().month.toString().padLeft(2, '0')}-${dateTime.toLocal().day.toString().padLeft(2, '0')}T${dateTime.toLocal().hour.toString().padLeft(2, '0')}:${dateTime.toLocal().minute.toString().padLeft(2, '0')}";
}

int getNetworkIdByName({required String network}) {
  if (network == 'mtn') {
    return 1;
  } else if (network == 'glo') {
    return 2;
  } else if (network == 'airtel') {
    return 3;
  } else {
    return 4;
  }
}

int getCableIdByName({required String network}) {
  if (network == 'dstv') {
    return 1;
  } else if (network == 'gotv') {
    return 2;
  } else {
    return 3;
  }
}

String getTrx() {
  return "${DateTime.now().microsecondsSinceEpoch}";
}
