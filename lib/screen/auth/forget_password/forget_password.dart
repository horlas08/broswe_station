import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:browse_station/screen/component/button.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_validator/form_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:toastification/toastification.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

import '../../../core/config/color.constant.dart';
import '../../../core/config/string.constant.dart';
import '../../../core/helper/helper.dart';
import '../../../core/service/request/auth.dart';
import '../../component/custom_input.dart';

final _formKey = GlobalKey<FormState>();

class ForgetPassword extends HookWidget {
  final String email;

  const ForgetPassword({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final newPasswordController = useTextEditingController();
    final codeController = useTextEditingController();

    final enableButton = useState<bool>(false);
    final checkButton = useState<bool>(false);
    void _handleFormChange() {
      enableButton.value = _formKey.currentState!.validate() ?? true;
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/favicon.png",
                      width: 40,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      "${AppString.AppName}",
                      style: TextStyle(fontSize: 25),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                const AutoSizeText(
                  "Reset Password",
                  maxLines: 1,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: AppColor.primaryColor,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 30,
                ),
                Form(
                    key: _formKey,
                    onChanged: _handleFormChange,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: [
                        CustomInput(
                          labelText: "Email Address/Username",
                          needLabel: true,
                          readOnly: true,
                          isEnable: false,
                          validator: ValidationBuilder().maxLength(50).build(),
                          controller: useTextEditingController(text: email),
                          hintText: 'qozeem@gmail.com',
                        ),
                        CustomInput(
                          labelText: "Verification Code",
                          needLabel: true,
                          validator: ValidationBuilder().maxLength(50).build(),
                          controller: codeController,
                          hintText: 'QWZS',
                        ),
                        CustomInput(
                          labelText: "New Password",
                          needLabel: true,
                          isPassword: true,
                          validator: ValidationBuilder().maxLength(50).build(),
                          controller: newPasswordController,
                          hintText: '*****',
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Button(
                          text: "Reset Password",
                          press: enableButton.value
                              ? () async {
                                  if (_formKey.currentState!.validate()) {
                                    try {
                                      context.loaderOverlay.show();
                                      final res = await resetPasswordRequest(
                                        password: newPasswordController.text,
                                        otp: codeController.text,
                                        email: email,
                                      );
                                      if (context.mounted) {
                                        context.loaderOverlay.hide();
                                        if (res.statusCode == HttpStatus.ok) {
                                          showToast(
                                            context,
                                            title: "Email Sent",
                                            desc: res.data['message'],
                                            type: ToastificationType.success,
                                          );
                                          return context.go('/login');
                                        } else {
                                          if (context.mounted) {
                                            context.loaderOverlay.hide();
                                            showToast(
                                              context,
                                              title: "Reset Password Error",
                                              desc: res.data['message'],
                                            );
                                          }
                                        }
                                      }
                                    } on DioException catch (error) {
                                      if (context.mounted) {
                                        context.loaderOverlay.hide();
                                        showToast(
                                          context,
                                          title: "Reset Password Error",
                                          desc: error.response?.data['message'],
                                        );
                                      }
                                    }
                                  } else {
                                    return;
                                  }
                                }
                              : null,
                        ),
                      ],
                    )),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't Receive Email?",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    TouchableOpacity(
                      activeOpacity: 0.3,
                      onTap: () async {
                        try {
                          context.loaderOverlay.show();
                          final res = await sendOtpForResetPasswordRequest(
                            email: email,
                          );
                          if (context.mounted) {
                            context.loaderOverlay.hide();
                            if (res.statusCode == HttpStatus.ok) {
                              return showToast(
                                context,
                                title: "Email Sent",
                                desc: "Verification has been resend to $email",
                                type: ToastificationType.success,
                              );
                            } else {
                              return showToast(context,
                                  title: "Reset Password Error",
                                  desc: res.data['message']);
                            }
                          }
                        } on DioException catch (error) {
                          print(error.response?.data);
                          if (context.mounted) {
                            context.loaderOverlay.hide();
                            showToast(
                              context,
                              title: "Reset Password Error",
                              desc: error.response?.data['message'],
                            );
                          }
                        }
                      },
                      child: const Text(
                        "Resend",
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColor.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
