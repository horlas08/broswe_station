import 'package:browse_station/core/routes/scaffold_with_nav_bar.dart';
import 'package:browse_station/screen/auth/login/login.dart';
import 'package:browse_station/screen/auth/onboard/onboard.dart';
import 'package:browse_station/screen/auth/register/register.dart';
import 'package:browse_station/screen/auth/register/registration_successful.dart';
import 'package:browse_station/screen/user/agent/agent.dart';
import 'package:browse_station/screen/user/bills/airtime/airtime.dart';
import 'package:browse_station/screen/user/bills/betting/betting.dart';
import 'package:browse_station/screen/user/bills/cable/cable.dart';
import 'package:browse_station/screen/user/bills/education/education.dart';
import 'package:browse_station/screen/user/bills/electricity/electricity.dart';
import 'package:browse_station/screen/user/bills/esim/esim.dart';
import 'package:browse_station/screen/user/bills/giftcard/gift_card.dart';
import 'package:browse_station/screen/user/bills/status/sucessful/successful.dart';
import 'package:browse_station/screen/user/confirm_page/confirm_transaction.dart';
import 'package:browse_station/screen/user/crypto/crypto.dart';
import 'package:browse_station/screen/user/deposit/account_details.dart';
import 'package:browse_station/screen/user/deposit/deposit.dart';
import 'package:browse_station/screen/user/preferences/user_preference.dart';
import 'package:browse_station/screen/user/shell/profile/change_password/change_password.dart';
import 'package:browse_station/screen/user/shell/profile/change_pin/change_pin.dart';
import 'package:browse_station/screen/user/shell/profile/profile.dart';
import 'package:browse_station/screen/user/shell/profile/update_profile/update_profile.dart';
import 'package:browse_station/screen/user/shell/purchase/all_bills.dart';
import 'package:browse_station/screen/user/shell/transaction/transaction_details.dart';
import 'package:browse_station/screen/user/shell/transaction/transactions.dart';
import 'package:browse_station/screen/user/verify/create_pin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';

import '../../screen/auth/forget_password/forget_password.dart';
import '../../screen/user/bills/data/data.dart';
import '../../screen/user/confirm_page/validate_transaction.dart';
import '../../screen/user/dashboard/dashboard.dart';
import '../../screen/user/kyc/kyc.dart';
import '../../screen/user/shell/portraitcuts/portraitcuts.dart';
import '../../screen/user/verify/login_verify.dart';
import '../../screen/user/withdraw/withdraw.dart';
import '../state/cubic/app_config_cubit.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    navigatorKey: _rootNavigatorKey,
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const Onboard();
        },
        routes: <RouteBase>[
          GoRoute(
            path: "login",
            name: "login",
            builder: (context, state) {
              return const Login();
            },
            redirect: (context, state) async {
              var appBox = Hive.box("appBox");
              if (context.read<AppConfigCubit>().state.authState &&
                  appBox.get("token") != null) {
                return '/user';
              } else if (!context.read<AppConfigCubit>().state.authState &&
                  appBox.get("token") != null) {
                return 'login/verify';
              }
              return null;
            },
          ),
          GoRoute(
            path: "register",
            name: "register",
            builder: (context, state) {
              return const Register();
            },
            redirect: (context, state) async {
              var appBox = Hive.box("appBox");
              if (context.read<AppConfigCubit>().state.authState &&
                  appBox.get("token") != null) {
                return '/user';
              } else if (!context.read<AppConfigCubit>().state.authState &&
                  appBox.get("token") != null) {
                return 'login/verify';
              }
              return null;
            },
          ),
          GoRoute(
            path: "forgetPassword/:email",
            name: "forgetPassword",
            builder: (context, state) {
              final String? email = state.pathParameters['email'];
              return ForgetPassword(
                email: email ?? '',
              );
            },
            redirect: (context, state) async {
              var appBox = Hive.box("appBox");
              if (context.read<AppConfigCubit>().state.authState &&
                  appBox.get("token") != null) {
                return '/user';
              } else if (!context.read<AppConfigCubit>().state.authState &&
                  appBox.get("token") != null) {
                return 'login/verify';
              }
              return null;
            },
          ),
        ],
        redirect: (context, state) async {
          var appBox = Hive.box("appBox");
          if (context.read<AppConfigCubit>().state.authState &&
              appBox.get("token") != null) {
            return '/user';
          } else if (!context.read<AppConfigCubit>().state.authState &&
              appBox.get("token") != null) {
            if (appBox.get("hasPin") == false || appBox.get("hasPin") == null) {
              return "/create/pin";
            }
            return '/login/verify';
          }
          return null;
        },
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (BuildContext context, GoRouterState state, Widget child) {
          return ScaffoldWithNavBar(child: child);
        },
        routes: <RouteBase>[
          GoRoute(
            path: '/user',
            name: 'dashboard',
            builder: (BuildContext context, GoRouterState state) {
              return const Dashboard();
            },
          ),
          GoRoute(
            path: '/all/bill',
            name: 'allBills',
            builder: (BuildContext context, GoRouterState state) {
              return const AllBills();
            },
          ),
          GoRoute(
            path: '/portraitcuts',
            name: 'portraitcuts',
            builder: (BuildContext context, GoRouterState state) {
              return const Portraitcuts();
            },
          ),
          GoRoute(
            path: '/user/transactions',
            name: 'transactions',
            builder: (BuildContext context, GoRouterState state) {
              return const Transactions();
            },
          ),
          GoRoute(
            path: '/user/profile',
            name: 'profile',
            builder: (BuildContext context, GoRouterState state) {
              return const Profile();
            },
          ),
        ],
        redirect: (context, state) {
          var appBox = Hive.box("appBox");
          if (appBox.get("hasPin") == false || appBox.get("hasPin") == null) {
            return "/create/pin";
          }
          return null;
        },
      ),
      GoRoute(
        path: "/regSuccessful",
        name: "regSuccessful",
        builder: (context, state) {
          return const RegistrationSuccessful();
        },
      ),
      GoRoute(
        path: "/login/verify",
        name: "loginVerify",
        builder: (context, state) {
          return const LoginVerify();
        },
        redirect: (context, state) async {
          var appBox = Hive.box("appBox");
          if (context.read<AppConfigCubit>().state.authState &&
              appBox.get("token") != null) {
            return '/user';
          }
          return null;
        },
      ),
      GoRoute(
        path: "/airtime",
        name: "airtime",
        builder: (context, state) {
          return const Airtime();
        },
        redirect: (context, state) async {
          // var appBox = Hive.box("appBox");
          // if (context.read<AppConfigCubit>().state.authState &&
          //     appBox.get("token") != null) {
          //   return '/user';
          // }
          return null;
        },
      ),
      GoRoute(
        path: "/data",
        name: "data",
        builder: (context, state) {
          return const Data();
        },
        redirect: (context, state) async {
          // var appBox = Hive.box("appBox");
          // if (context.read<AppConfigCubit>().state.authState &&
          //     appBox.get("token") != null) {
          //   return '/user';
          // }
          return null;
        },
      ),
      GoRoute(
        path: "/cable",
        name: "cable",
        builder: (context, state) {
          return const Cable();
        },
        redirect: (context, state) async {
          // var appBox = Hive.box("appBox");
          // if (context.read<AppConfigCubit>().state.authState &&
          //     appBox.get("token") != null) {
          //   return '/user';
          // }
          return null;
        },
      ),
      GoRoute(
        path: "/electricity",
        name: "electricity",
        builder: (context, state) {
          return const Electricity();
        },
        redirect: (context, state) async {
          // var appBox = Hive.box("appBox");
          // if (context.read<AppConfigCubit>().state.authState &&
          //     appBox.get("token") != null) {
          //   return '/user';
          // }
          return null;
        },
      ),
      GoRoute(
        path: "/education",
        name: "education",
        builder: (context, state) {
          return const Education();
        },
        redirect: (context, state) async {
          return null;
        },
      ),
      GoRoute(
        path: "/betting",
        name: "betting",
        builder: (context, state) {
          return const Betting();
        },
        redirect: (context, state) async {
          // var appBox = Hive.box("appBox");
          // if (context.read<AppConfigCubit>().state.authState &&
          //     appBox.get("token") != null) {
          //   return '/user';
          // }
          return null;
        },
      ),
      GoRoute(
        path: '/withdraw',
        name: 'withdraw',
        builder: (BuildContext context, GoRouterState state) {
          return const Withdraw();
        },
      ),
      GoRoute(
        path: '/create/pin',
        name: 'createPin',
        builder: (BuildContext context, GoRouterState state) {
          return const CreatePin();
        },
      ),
      GoRoute(
        path: "/confirm/transaction",
        name: "confirmTransaction",
        builder: (context, state) {
          return ConfirmTransaction(
            callback: (state.extra as Map)['function'] as Function,
            data: (state.extra as Map)['data'] as Map<String, String>,
            viewData: (state.extra as Map)['viewData'] as Map<String, String>,
          );
        },
        redirect: (context, state) async {
          return null;
        },
      ),
      GoRoute(
        path: "/validate",
        name: "validate",
        builder: (context, state) {
          return ValidateTransaction(
            callback: (state.extra as Map)['function'] as Function,
            data: (state.extra as Map)['data'] as Map<String, String>,
          );
        },
        redirect: (context, state) async {
          return null;
        },
      ),
      GoRoute(
        path: "/transaction/successful",
        name: "successfulPage",
        builder: (context, state) {
          return Successful(
            message: state.extra as String,
          );
        },
        redirect: (context, state) async {
          return null;
        },
      ),
      GoRoute(
        path: "/transaction/details",
        name: "transactionDetails",
        builder: (context, state) {
          return TransactionDetails(data: state.extra as Map<String, String>);
        },
        redirect: (context, state) async {
          return null;
        },
      ),
      GoRoute(
        path: "/deposit",
        name: "deposit",
        builder: (context, state) {
          return const Deposit();
        },
        redirect: (context, state) async {
          return null;
        },
      ),
      GoRoute(
        path: "/gift-card",
        name: "giftCard",
        builder: (context, state) {
          return const GiftCard();
        },
        redirect: (context, state) async {
          return null;
        },
      ),
      GoRoute(
        path: "/esim",
        name: "esim",
        builder: (context, state) {
          return const Esim();
        },
        redirect: (context, state) async {
          return null;
        },
      ),
      GoRoute(
        path: "/crypto",
        name: "crypto",
        builder: (context, state) {
          return const Crypto();
        },
        redirect: (context, state) async {
          return null;
        },
      ),
      GoRoute(
        path: "/user/accountDetails",
        name: "myAccount",
        builder: (context, state) {
          return AccountDetails(
            accountDetail: state.extra as Map<String, String>,
          );
        },
        redirect: (context, state) async {
          return null;
        },
      ),
      GoRoute(
        path: "/user/kyc",
        name: "kyc",
        builder: (context, state) {
          return const Kyc();
        },
        redirect: (context, state) async {
          return null;
        },
      ),
      GoRoute(
        path: "/user/agent",
        name: "agent",
        builder: (context, state) {
          return const Agent();
        },
        redirect: (context, state) async {
          return null;
        },
      ),
      GoRoute(
        path: "/preference",
        name: "preference",
        builder: (context, state) {
          return const UserPreference();
        },
        redirect: (context, state) async {
          return null;
        },
      ),
      GoRoute(
        path: "/update/password",
        name: "updatePassword",
        builder: (context, state) {
          return const ChangePassword();
        },
        redirect: (context, state) async {
          return null;
        },
      ),
      GoRoute(
        path: "/update/pin",
        name: "updatePin",
        builder: (context, state) {
          return const ChangePin();
        },
        redirect: (context, state) async {
          return null;
        },
      ),
      GoRoute(
        path: "/update/profile",
        name: "updateProfile",
        builder: (context, state) {
          return const UpdateProfile();
        },
        redirect: (context, state) async {
          return null;
        },
      ),
    ],
  );
}
