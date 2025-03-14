import 'package:auto_size_text/auto_size_text.dart';
import 'package:browse_station/core/state/bloc/repo/app/app_state.dart';
import 'package:browse_station/core/state/cubic/app_config_cubit.dart';
import 'package:browse_station/data/model/app_config.dart';
import 'package:browse_station/screen/component/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Dashboardoverlayscreen extends StatelessWidget {
  final AppConfig state;
  final AppState appState;

  const Dashboardoverlayscreen(
      {super.key, required this.state, required this.appState});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          const Image(
            image: AssetImage(
              "assets/images/news.png",
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AutoSizeText(appState.user?.alt_notification?['message']),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Button(
              text: "Ok",
              press: () {
                context
                    .read<AppConfigCubit>()
                    .changeShowOverlayNotifyMode(false);
              },
            ),
          ),
        ],
      )),
    );
  }
}
