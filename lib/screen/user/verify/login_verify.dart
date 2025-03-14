import 'package:auto_size_text/auto_size_text.dart';
import 'package:browse_station/core/config/color.constant.dart';
import 'package:browse_station/core/config/font.constant.dart';
import 'package:browse_station/core/helper/helper.dart';
import 'package:browse_station/screen/component/button.dart';
import 'package:browse_station/screen/component/custom_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_validator/form_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';
import 'package:remixicon/remixicon.dart';
import 'package:toastification/toastification.dart';
import 'package:touchable_opacity/touchable_opacity.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

import '../../../core/state/bloc/repo/app/app_bloc.dart';
import '../../../core/state/bloc/repo/app/app_event.dart';
import '../../../core/state/cubic/app_config_cubit.dart';
import '../../../core/state/cubic/login_verify/login_verify_cubit.dart';
import '../../../core/state/cubic/login_verify/login_verify_state.dart';
import '../../component/app_header.dart';

final _formKey = GlobalKey<FormState>();

final LocalAuthentication auth = LocalAuthentication();

Future<bool> canAuth() async {
  return await auth.canCheckBiometrics && await auth.isDeviceSupported();
}

Future<List<BiometricType>> availableBiometrics() async {
  final List<BiometricType> availableBiometrics =
      await auth.getAvailableBiometrics();
  return availableBiometrics;
}

class LoginVerify extends HookWidget {
  const LoginVerify({super.key});

  @override
  Widget build(BuildContext context) {
    final pinController = useTextEditingController();
    final enableButton = useState<bool>(false);
    final biometricAvailable = useState<bool>(false);
    final appSetting = context.read<AppConfigCubit>().state;

    void _handleFormChange() {
      enableButton.value = _formKey.currentState!.validate() ?? true;
    }

    useEffect(() {
      canAuth().then(
        (value) {
          if (value) {
            availableBiometrics().then(
              (availableBiometric) {
                if (availableBiometric.isNotEmpty &&
                        (availableBiometric.contains(BiometricType.face) ||
                            availableBiometric
                                .contains(BiometricType.strong)) ||
                    (availableBiometric.contains(BiometricType.weak) ||
                        availableBiometric
                            .contains(BiometricType.fingerprint))) {
                  biometricAvailable.value = true;
                }
              },
            );
          }
        },
      );

      return null;
    });
    return BlocConsumer<LoginVerifyCubit, LoginVerifyState>(
      listener: (context, state) async {
        if (state is LoginVerifyLoading) {
          context.loaderOverlay.show();
        } else if (state is LoginVerifyFailed) {
          context.loaderOverlay.hide();
          showToast(context, title: "Verification Error", desc: state.message);
        } else if (state is LoginVerifySuccess) {
          try {
            context.loaderOverlay.hide();
            context.read<AppConfigCubit>().changeAuthState(true);
            final userData = state.userData;

            try {
              userData.addAll({"alt_notification": state.alt_notification});
              print("+++++++++");
              print(state.alt_notification.runtimeType);
              print(userData);
            } catch (error) {
              print(error);
            }

            print("_______");
            context.read<AppBloc>().add(
                  AddUserEvent(userData: userData),
                );
            context
                .read<AppBloc>()
                .add(AddUserSettingsEvent(settings: state.settings));
            context
                .read<AppBloc>()
                .add(AddAccountEvent(accounts: state.accounts));

            context.go('/user');
            showToast(
              context,
              title: "Login Info",
              desc: "Login Successful",
              type: ToastificationType.success,
            );
          } catch (error) {
            print(error);
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppHeader(
            title: 'Unique Pin',
            onpress: () {
              showAppDialog(
                context,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18.0,
                    vertical: 10,
                  ),
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      const Text(
                        "Are you sure you want to proceed ?\nBy continue you will be logout from the app",
                        textAlign: TextAlign.center,
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () async {
                              var appBox = Hive.box("appBox");
                              await appBox.clear();
                              if (context.mounted) context.go("/");
                            },
                            child: const Text("Yes Continue"),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              context.pop();
                            },
                            child: const Text("Cancel"),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          ),
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Form(
              key: _formKey,
              onChanged: _handleFormChange,
              child: Column(
                children: [
                  const AutoSizeText(
                    "Sign in with your 4 digit unique pin or sign in with your device verification,",
                    maxLines: 2,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppFont.segoui),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  CustomInput(
                    labelText: "",
                    hintText: '4 digit pin',
                    controller: pinController,
                    autofocus: true,
                    showCursor: true,
                    validator: ValidationBuilder()
                        .required()
                        .minLength(4)
                        .maxLength(4)
                        .build(),
                    readOnly: true,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  if (appSetting.enableFingerPrint)
                    if (biometricAvailable.value)
                      TouchableOpacity(
                        onTap: () async {
                          try {
                            final bool didAuthenticate =
                                await auth.authenticate(
                              localizedReason:
                                  'Please authenticate access your account',
                              options: const AuthenticationOptions(
                                biometricOnly: true,
                                useErrorDialogs: true,
                                stickyAuth: true,
                                sensitiveTransaction: true,
                              ),
                              authMessages: const <AuthMessages>[
                                AndroidAuthMessages(
                                  signInTitle:
                                      'Oops! Biometric authentication required!',
                                  cancelButton: 'No thanks',
                                ),
                                IOSAuthMessages(
                                  cancelButton: 'No thanks',
                                ),
                              ],
                            );
                            if (context.mounted) {
                              if (didAuthenticate) {
                                context
                                    .read<LoginVerifyCubit>()
                                    .onLoginVerifyRequested(null);
                              } else {
                                showToast(context,
                                    title: "error",
                                    desc: "Biometric verification failed");
                              }
                            }

                            // ···
                          } on PlatformException catch (error) {
                            if (context.mounted)
                              showToast(context,
                                  title: "error", desc: error.toString());
                          }
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Remix.fingerprint_line,
                              size: 25,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "verification",
                              style: TextStyle(fontSize: 25),
                            ),
                          ],
                        ),
                      ),
                  const SizedBox(
                    height: 25,
                  ),
                  VirtualKeyboard(
                    // [0-9] + .
                    type: VirtualKeyboardType.Numeric,

                    fontSize: 20,
                    textController: pinController,
                    textColor: AppColor.primaryColor,
                    preKeyPress: (key) {},

                    // Callback for key press event
                    // postKeyPress: (key) =>
                    //     pinController.text = "${pinController.text}${key.text}",
                  ),
                  const Spacer(),
                  Button(
                    text: "Continue",
                    press: enableButton.value
                        ? () {
                            context
                                .read<LoginVerifyCubit>()
                                .onLoginVerifyRequested(pinController.text);
                          }
                        : null,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
