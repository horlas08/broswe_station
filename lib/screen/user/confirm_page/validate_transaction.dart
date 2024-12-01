import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:browse_station/core/config/color.constant.dart';
import 'package:browse_station/core/config/font.constant.dart';
import 'package:browse_station/core/helper/helper.dart';
import 'package:browse_station/data/model/app_config.dart';
import 'package:browse_station/screen/component/button.dart';
import 'package:browse_station/screen/component/custom_input.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_validator/form_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';
import 'package:remixicon/remixicon.dart';
import 'package:touchable_opacity/touchable_opacity.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

import '../../../core/service/request/protected.dart';
import '../../../core/state/cubic/app_config_cubit.dart';
import '../../component/app_header.dart';
import '../verify/login_verify.dart';

final _formKey = GlobalKey<FormState>();

class ValidateTransaction extends HookWidget {
  final Function callback;
  final Map<String, String> data;
  const ValidateTransaction({
    super.key,
    required this.callback,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final pinController = useTextEditingController();
    final enableButton = useState<bool>(false);
    final biometricAvailable = useState<bool>(false);
    // final appSetting = context.read<AppConfigCubit>().state;

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
    return BlocBuilder<AppConfigCubit, AppConfig>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppHeader(
            title: 'Validate Transaction',
            onpress: () {
              context.pop();
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
                    "Enter your Browsestation unique pin to validate the transaction",
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppFont.segoui,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  CustomInput(
                    labelText: "",
                    hintText: '4 digit pin',
                    autofocus: true,
                    showCursor: true,
                    controller: pinController,
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
                  if (state.enableFingerPrint)
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
                                try {
                                  context.loaderOverlay.show();

                                  var parameter = data.map((key, value) =>
                                      MapEntry(Symbol(key), value));

                                  final Response<dynamic> res =
                                      await Function.apply(callback, [context],
                                          parameter as Map<Symbol, dynamic>?);
                                  if (context.mounted) {
                                    if (res.statusCode == HttpStatus.ok) {
                                      context.loaderOverlay.hide();
                                      context.go("/transaction/successful",
                                          extra: res.data['message']);
                                    } else {
                                      throw Exception(res.data['message']);
                                    }
                                  }
                                } on DioException catch (error) {
                                  if (context.mounted) {
                                    context.loaderOverlay.hide();
                                    showToast(context,
                                        title: " Validate Error",
                                        desc: error.response?.data['message'] ??
                                            error.toString());
                                  }
                                } on Exception catch (error) {
                                  if (context.mounted) {
                                    context.loaderOverlay.hide();
                                    showToast(context,
                                        title: " Validate Error",
                                        desc: error.toString());
                                  }
                                } finally {
                                  if (context.mounted) {
                                    context.loaderOverlay.hide();
                                  }
                                }
                              } else {
                                showToast(context,
                                    title: "error",
                                    desc: "Biometric verification failed");
                              }
                            }

                            // ···
                          } on PlatformException catch (error) {
                            if (context.mounted) {
                              showToast(context,
                                  title: "error", desc: error.toString());
                            }
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
                    // Callback for key press event
                    // preKeyPress: (key) {
                    //   print(key);
                    // },
                    // postKeyPress: (key) =>
                    //     pinController.text = "${pinController.text}${key.text}",
                  ),
                  Spacer(),
                  Button(
                    text: "Continue",
                    press: enableButton.value
                        ? () async {
                            try {
                              context.loaderOverlay.show();
                              final response = await validatePinRequest(
                                  pin: pinController.text);
                              if (context.mounted) {
                                if (response.statusCode == HttpStatus.ok) {
                                  var parameter = data.map((key, value) =>
                                      MapEntry(Symbol(key), value));
                                  print(parameter);
                                  final Response<dynamic> res =
                                      await Function.apply(callback, [context],
                                          parameter as Map<Symbol, dynamic>?);
                                  if (context.mounted) {
                                    if (res.statusCode == HttpStatus.ok) {
                                      context.loaderOverlay.hide();
                                      context.go("/transaction/successful",
                                          extra: res.data['message']);
                                    } else {
                                      throw Exception(res.data['message']);
                                    }
                                  }
                                } else {
                                  if (context.mounted) {
                                    pinController.text = '';
                                    throw Exception(response.data['message']);
                                  }
                                }
                              }
                            } on DioException catch (error) {
                              if (context.mounted) {
                                context.loaderOverlay.hide();
                                showToast(context,
                                    title: "Error",
                                    desc: error.response?.data['message'] ??
                                        error.toString());
                              }
                            } on Exception catch (error) {
                              if (context.mounted) {
                                context.loaderOverlay.hide();
                                showToast(context,
                                    title: " Error", desc: error.toString());
                              }
                            } finally {
                              if (context.mounted) {
                                context.loaderOverlay.hide();
                              }
                            }
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
