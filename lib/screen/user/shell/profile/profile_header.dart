import 'package:browse_station/core/helper/helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ripple_wave/ripple_wave.dart';

import '../../../../core/config/color.constant.dart';
import '../../../../core/state/bloc/repo/app/app_bloc.dart';
import '../../../../core/state/bloc/repo/app/app_state.dart';
import '../../../component/app_header2.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    // final user = context.read<AppBloc>().state.user;

    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        return Container(
          height: 200,
          decoration: const BoxDecoration(
            color: AppColor.secondaryColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
          ),
          child: Column(
            children: [
              AppHeader2(
                title: "",
                topSpace: 2,
                onIconPress: () {},
                iconData: Ionicons.notifications,
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    state.user!.photo == null
                        ? RippleWave(
                            child: CircleAvatar(
                              minRadius: 2,
                              maxRadius: 30,
                              child: Image.asset(
                                  "assets/images/profile-picture.png"),
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(color: AppColor.primaryColor),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(150.0),
                              child: CachedNetworkImage(
                                imageUrl: state.user!.photo!,
                                height: 40,
                                width: 40,
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(
                                  color: AppColor.primaryColor,
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                          ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          state.user!.firstName.capitalize(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                              text: "@${state.user!.username} ",
                              children: [
                                WidgetSpan(
                                  child: Icon(
                                    Ionicons.ribbon,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                                TextSpan(
                                    text: state.user!.hasMonnify
                                        ? " Tier 1"
                                        : "Tier 2")
                              ]),
                          style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    const Spacer(),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
