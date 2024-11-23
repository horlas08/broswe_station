import 'package:browse_station/core/config/color.constant.dart';
import 'package:browse_station/core/service/http.dart';
import 'package:browse_station/core/state/bloc/login/login_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:toastification/toastification.dart';

import 'core/routes/routes.dart';
import 'core/state/bloc/login/login_event.dart';
import 'core/state/bloc/register/register_bloc.dart';
import 'core/state/bloc/repo/app/app_bloc.dart';
import 'core/state/cubic/app_config_cubit.dart';
import 'core/state/cubic/login_verify/login_verify_cubit.dart';
import 'core/themes/light.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('appBox');
  await Hive.openBox<dynamic>('appDBox');
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );
  await Hive.initFlutter();
  await configureDio();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (contents) => RegisterBloc(),
        ),
        BlocProvider(
          create: (contents) => LoginBloc()..add(LoginInitEvent()),
        ),
        BlocProvider(
          create: (contents) => AppBloc(),
        ),
        BlocProvider(
          create: (contents) => LoginVerifyCubit(),
        ),
        BlocProvider(create: (contents) => AppConfigCubit())
      ],
      child: ToastificationWrapper(
        config: ToastificationConfig(),
        child: GlobalLoaderOverlay(
          useDefaultLoading: false,
          overlayColor: AppColor.greyLightColor.withOpacity(0.7),
          overlayWholeScreen: true,
          // duration: Durations.extralong4,
          // closeOnBackButton: true,
          overlayWidgetBuilder: (_) {
            return Center(
              child: LoadingAnimationWidget.inkDrop(
                color: AppColor.primaryColor,
                size: 50.0,
              ),
            );
          },
          child: MaterialApp.router(
            title: 'Browse Station',
            theme: lightTheme,
            themeMode: ThemeMode.light,
            routerConfig: AppRouter.router,
            debugShowCheckedModeBanner: false,
          ),
        ),
      ),
    );
  }
}
