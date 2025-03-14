import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:browse_station/core/config/color.constant.dart';
import 'package:browse_station/core/config/font.constant.dart';
import 'package:browse_station/core/helper/helper.dart';
import 'package:browse_station/core/state/bloc/repo/app/app_bloc.dart';
import 'package:browse_station/screen/component/custom_input.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:remixicon/remixicon.dart';
import 'package:toastification/toastification.dart';
import 'package:widget_visibility_detector/widget_visibility_detector.dart';

import '../../../core/service/request/protected.dart';
import '../../../core/state/bloc/repo/app/app_state.dart';
import '../button.dart';

class BalanceCard extends HookWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final hideBalance = useState<bool>(false);
    final commissionController = useTextEditingController();
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        final List<Map<String, dynamic>> userData = [
          {
            'text': 'My Balance',
            'Number': state.user!.balance,
          },
          {
            'text': 'Referral Balance',
            'Number': state.user?.referrals,
          },
        ];
        final balance = double.tryParse(state.user!.balance.toString());
        final commission = double.tryParse(state.user!.commission.toString());
        final currencyFormatter =
            NumberFormat.currency(locale: "en_NG", symbol: "₦");
        String formattedCurrency = currencyFormatter.format(balance ?? 0.0);
        String formattedCurrency2 = currencyFormatter.format(commission ?? 0.0);
        return WidgetVisibilityDetector(
          onAppear: () async {
            await refreshUserDetails(context, showLoading: false);
          },
          child: Swiper(
            itemCount: 2,
            scrollDirection: Axis.horizontal,
            axisDirection: AxisDirection.right,
            pagination: const SwiperPagination(
              alignment: Alignment.bottomCenter,
              builder: RectSwiperPaginationBuilder(
                color: Colors.white,
                // space: 1,
                size: Size(15, 10),
                activeSize: Size(25, 10),
                activeColor: AppColor.primaryColor,
              ),
              margin: EdgeInsets.only(top: 20),
            ),
            layout: SwiperLayout.TINDER,
            itemWidth: double.infinity,
            itemHeight: 200,
            onIndexChanged: (value) {
              print(value);
            },
            itemBuilder: (context, index) => SizedBox(
              height: 200,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 10,
                ),
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: index == 0
                        ? AppColor.primaryColor
                        : AppColor.secondaryColor,
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
                                index == 0
                                    ? formattedCurrency
                                    : formattedCurrency2,
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
                    Text(
                      index == 0 ? "Total Balance" : "Commission Balance",
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
                                AutoSizeText(
                                  "Add Money",
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
                            onPressed: index == 1
                                ? () {
                                    showAppDialog(
                                      context,
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        child: Column(
                                          children: [
                                            CustomInput(
                                              labelText: "Amount",
                                              controller: commissionController,
                                              textInputType: TextInputType
                                                  .numberWithOptions(),
                                            ),
                                            Button(
                                              text: "Convert Now",
                                              press: () async {
                                                if (commissionController
                                                    .text.isEmpty) {
                                                  showToast(context,
                                                      title: "error",
                                                      desc:
                                                          "Please Enter amount");
                                                } else {
                                                  context.loaderOverlay.show();
                                                  try {
                                                    final response =
                                                        await commissionWithdrawRequest(
                                                      context,
                                                      amount:
                                                          commissionController
                                                              .text,
                                                    );
                                                    if (context.mounted) {
                                                      context.loaderOverlay
                                                          .hide();

                                                      if (response.statusCode !=
                                                          HttpStatus.ok) {
                                                        if (context.mounted) {
                                                          showToast(context,
                                                              title: "Error",
                                                              desc: response
                                                                      .data[
                                                                  'message']);
                                                        }
                                                      } else {
                                                        if (context.mounted) {
                                                          context.pop();
                                                          showToast(context,
                                                              title: "Success",
                                                              desc: response
                                                                      .data[
                                                                  'message'],
                                                              type:
                                                                  ToastificationType
                                                                      .success);
                                                        }
                                                      }
                                                    }
                                                  } on DioException catch (error) {
                                                    if (context.mounted) {
                                                      context.loaderOverlay
                                                          .hide();
                                                      showToast(
                                                        context,
                                                        title: "error",
                                                        desc: error.response
                                                                    ?.data[
                                                                'message'] ??
                                                            error.response?.data
                                                                .toString(),
                                                      );
                                                    }
                                                  }
                                                }
                                              },
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                : () {
                                    if (state.user!.kyc > 1) {
                                      context.go('/withdraw');
                                    } else {
                                      context.go('/user/kyc');
                                    }
                                  },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  Remix.telegram_line,
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  index == 0 ? "Withdraw" : "Convert",
                                  style: const TextStyle(
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
            ),
          ),
        );
      },
    );
  }
}
