import 'package:browse_station/core/config/color.constant.dart';
import 'package:browse_station/core/state/cubic/app_config_cubit.dart';
import 'package:browse_station/data/model/app_config.dart';
import 'package:browse_station/screen/component/dashboard/all_services.dart';
import 'package:browse_station/screen/component/dashboard/dashboard_header.dart';
import 'package:browse_station/screen/component/dashboard/transaction.dart';
import 'package:browse_station/screen/user/dashboard/DashboardOverlayScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/state/bloc/repo/app/app_bloc.dart';
import '../../../core/state/bloc/repo/app/app_state.dart';
import '../../component/dashboard/balance_card.dart';
import '../referral/ref_design.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppConfigCubit, AppConfig>(
      builder: (context, configState) {
        return BlocBuilder<AppBloc, AppState>(
          builder: (context, state) {
            if (state.user!.alt_notification != null) if (state
                        .user?.alt_notification?['status'] ==
                    '1' &&
                configState.showOverlayNotify) {
              return Dashboardoverlayscreen(
                state: configState,
                appState: state,
              );
            }
            return Scaffold(
              backgroundColor: AppColor.scaffordBg,
              body: const SingleChildScrollView(
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(18),
                    child: Column(
                      children: [
                        DashboardHeader(),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(height: 200, child: BalanceCard()),
                        SizedBox(
                          height: 50,
                        ),
                        AllServices(),
                        SizedBox(
                          height: 30,
                        ),
                        RefDesign(),
                        SizedBox(
                          height: 50,
                        ),
                        Transaction()
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
