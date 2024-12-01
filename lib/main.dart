import 'package:browse_station/core/config/color.constant.dart';
import 'package:browse_station/core/service/http.dart';
import 'package:browse_station/core/state/bloc/login/login_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:toastification/toastification.dart';

import 'core/routes/routes.dart';
import 'core/state/bloc/login/login_event.dart';
import 'core/state/bloc/register/register_bloc.dart';
import 'core/state/bloc/repo/app/app_bloc.dart';
import 'core/state/cubic/app_config_cubit.dart';
import 'core/state/cubic/login_verify/login_verify_cubit.dart';
import 'core/themes/light.dart';
import 'firebase_options.dart';

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
  await initialization();
  await Hive.initFlutter();
  await configureDio();
  //Remove this method to stop OneSignal Debugging
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

  OneSignal.initialize("d422c9a3-d6c0-49ed-97be-e8e728bfbf12");

// The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt.
// We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  await OneSignal.Notifications.requestPermission(true);
  await SentryFlutter.init((options) {
    options.dsn =
        'https://de15a9fa737c8f989ae0a8f34b3436b5@o4507321451937792.ingest.us.sentry.io/4508356298866688';
    // Set tracesSampleRate to 1.0 to capture 100% of transactions for tracing.
    // We recommend adjusting this value in production.
    options.tracesSampleRate = 1.0;
    // The sampling rate for profiling is relative to tracesSampleRate
    // Setting to 1.0 will profile 100% of sampled transactions:
    options.profilesSampleRate = 1.0;
  }, appRunner: () => runApp(const MyApp()));
  // runApp(const MyApp());
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
            title: 'Browse Stations',
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

Future<void> initialization() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}
