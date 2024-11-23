import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ripple_wave/ripple_wave.dart';

import '../../../core/config/color.constant.dart';
import '../../../core/state/bloc/repo/app/app_bloc.dart';
import '../../../core/state/bloc/repo/app/app_state.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            state.user!.photo == null
                ? RippleWave(
                    child: CircleAvatar(
                      child: Image.asset("assets/images/profile-picture.png"),
                      minRadius: 2,
                      maxRadius: 30,
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

            SizedBox(width: 4,),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Hello Ayo"),
                Text(
                  "Welcome Back",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Spacer(),
            IconButton(
                onPressed: () {},
                style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                        AppColor.secondaryColor.withOpacity(0.3))),
                icon: const Icon(
                  Icons.notification_add_outlined,
                  color: AppColor.secondaryColor,
                ))
          ],
        );
      },
    );
  }
}
