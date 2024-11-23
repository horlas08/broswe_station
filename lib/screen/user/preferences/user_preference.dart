import 'package:browse_station/core/helper/helper.dart';
import 'package:browse_station/data/model/app_config.dart';
import 'package:browse_station/screen/component/app_header2.dart';
import 'package:browse_station/screen/component/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:go_router/go_router.dart';
import 'package:remixicon/remixicon.dart';

import '../../../core/config/color.constant.dart';
import '../../../core/state/cubic/app_config_cubit.dart';

class UserPreference extends HookWidget {
  const UserPreference({super.key});

  @override
  Widget build(BuildContext context) {
    final kycKey = GlobalKey<FormState>();
    final bvnController = useTextEditingController();
    return BlocBuilder<AppConfigCubit, AppConfig>(
      builder: (context, state) {
        return CustomScaffold(
          header: const AppHeader2(title: "Preference"),
          child: Form(
            key: kycKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListCard(
                  name: "Update Profile",
                  desc: "Update your personal information",
                  icon: Remix.user_3_line,
                  margin: EdgeInsets.zero,
                  onTap: () {
                    context.push('/update/profile');
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                ListCard(
                  name: "Change Pin",
                  desc: "Change your 4 digit pin easily",
                  icon: Remix.key_line,
                  margin: EdgeInsets.zero,
                  onTap: () {
                    context.push('/update/pin');
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                ListCard(
                  name: "Change Password",
                  desc: "Change your password easily",
                  icon: Remix.lock_line,
                  margin: EdgeInsets.zero,
                  onTap: () {
                    context.push('/update/password');
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 20,
                ),
                ListCard(
                  name: "Enable Biometric",
                  desc: "Enable or disable biometric",
                  icon: Remix.fingerprint_line,
                  margin: EdgeInsets.zero,
                  arrowEnd: FlutterSwitch(
                    width: 55.0,
                    height: 30.0,
                    valueFontSize: 15.0,
                    toggleSize: 20.0,
                    value: state.enableFingerPrint,
                    borderRadius: 30.0,
                    padding: 4.0,
                    activeIcon: const Icon(
                      Icons.check,
                      size: 15,
                      color: AppColor.primaryColor,
                    ),
                    inactiveIcon: const Icon(
                      Icons.close,
                      size: 15,
                      color: AppColor.primaryColor,
                    ),

                    activeColor: AppColor.primaryColor,
                    // activeToggleColor: AppColor.primaryColor,
                    showOnOff: true,
                    onToggle: (bool value) {
                      print(value);
                      context.read<AppConfigCubit>().enableFingerPrint(value);
                    },
                  ),
                  onTap: () {},
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
