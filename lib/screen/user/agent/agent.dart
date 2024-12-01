import 'package:auto_size_text/auto_size_text.dart';
import 'package:browse_station/core/config/color.constant.dart';
import 'package:browse_station/core/helper/helper.dart';
import 'package:browse_station/core/state/bloc/repo/app/app_bloc.dart';
import 'package:browse_station/screen/component/app_header2.dart';
import 'package:browse_station/screen/component/custom_scaffold.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../core/service/request/protected.dart';
import '../../../core/state/bloc/repo/app/app_state.dart';
import '../../component/button.dart';

class Agent extends HookWidget {
  const Agent({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      header: const AppHeader2(title: "Upgrade Account"),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Let know you more",
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.only(top: 40),
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColor.secondaryColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.secondaryColor.withOpacity(0.5),
                    offset: Offset(10, 10),
                  ),
                ],
              ),
              child: Icon(
                Ionicons.ribbon,
                color: Colors.white,
                size: 50,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const AutoSizeText(
            "By continue we are migratiog your account from user to agent account and you will be charge N1000 for the upgrade",
            maxLines: 3,
          ),
          const SizedBox(
            height: 15,
          ),
          BlocBuilder<AppBloc, AppState>(
            builder: (context, state) {
              return Button(
                text: state.user!.userType
                    ? "You are already an agent"
                    : "Upgrade Now",
                press: !state.user!.userType
                    ? () async {
                        try {
                          await handleUpgrade(context);
                        } on DioException catch (error) {
                          if (context.mounted) {
                            showToast(context,
                                title: "error",
                                desc: error.response?.data['message'] ??
                                    error.toString());
                          }
                        } catch (error) {
                          if (context.mounted)
                            showToast(context,
                                title: "error", desc: error.toString());
                        } finally {
                          if (context.mounted) {
                            if (context.loaderOverlay.visible) {
                              context.loaderOverlay.hide();
                            }
                          }
                        }
                      }
                    : null,
              );
            },
          )
        ],
      ),
    );
  }
}
