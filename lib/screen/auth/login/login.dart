import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:browse_station/core/config/color.constant.dart';
import 'package:browse_station/core/config/string.constant.dart';
import 'package:browse_station/core/helper/helper.dart';
import 'package:browse_station/core/state/bloc/login/login_state.dart';
import 'package:browse_station/screen/component/custom_input.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_validator/form_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:toastification/toastification.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

import '../../../core/service/request/auth.dart';
import '../../../core/state/bloc/login/login_bloc.dart';
import '../../../core/state/bloc/login/login_event.dart';
import '../../../core/state/bloc/repo/app/app_bloc.dart';
import '../../../core/state/bloc/repo/app/app_event.dart';
import '../../../core/state/cubic/app_config_cubit.dart';
import '../../component/button.dart';

final _formKey = GlobalKey<FormState>();

class Login extends HookWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    final enableButton = useState<bool>(false);

    void _handleFormChange() {
      enableButton.value = _formKey.currentState!.validate() ?? true;
    }

    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) async {
        if (state is LoginLoadingState) {
          context.loaderOverlay.show();
        } else if (state is LoginFailed) {
          context.loaderOverlay.hide();
          showToast(context, title: "Login Error", desc: state.message);
        } else if (state is LoginSuccess) {
          context.read<AppBloc>().add(AddUserEvent(userData: state.userData));
          context
              .read<AppBloc>()
              .add(AddAccountEvent(accounts: state.accounts));
          // if (!context.read<AppConfigCubit>().state.onboardSkip) {
          //   context.read<AppConfigCubit>().changeOnboardStatus(true);
          // }
          context.read<AppConfigCubit>().changeAuthState(true);
          context.go('/user');
          context.loaderOverlay.hide();
          showToast(
            context,
            title: "Login Info",
            desc: "Welcome Back ${state.userData['username']}",
            type: ToastificationType.success,
          );
        } else {
          print("i mistake enter here");
        }
      },
      builder: (context, state) {
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
                      "Welcome Back",
                      maxLines: 1,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: AppColor.primaryColor,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    const AutoSizeText(
                      "Please enter your details ",
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Form(
                        key: _formKey,
                        onChanged: _handleFormChange,
                        child: Column(
                          children: [
                            CustomInput(
                              labelText: "Email or Username",
                              needLabel: true,
                              validator:
                                  ValidationBuilder().maxLength(50, '').build(),
                              controller: emailController,
                              hintText: 'test@gmail.com',
                            ),
                            CustomInput(
                              labelText: "Password",
                              isPassword: true,
                              validator:
                                  ValidationBuilder().required('').build(),
                              controller: passwordController,
                              hintText: "*****",
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TouchableOpacity(
                                activeOpacity: 0.3,
                                onTap: () async {
                                  if (emailController.text.isEmpty) {
                                    return showToast(
                                      context,
                                      title: "Reset Password Error",
                                      desc: "Please enter email to continue",
                                    );
                                  }
                                  try {
                                    context.loaderOverlay.show();
                                    final res =
                                        await sendOtpForResetPasswordRequest(
                                      email: emailController.text,
                                    );
                                    if (context.mounted) {
                                      context.loaderOverlay.hide();
                                      if (res.statusCode == HttpStatus.ok) {
                                        showToast(
                                          context,
                                          title: "Email Sent",
                                          desc:
                                              "Verification has been sent to ${emailController.text}",
                                          type: ToastificationType.success,
                                        );
                                        return context.go(
                                          '/forgetPassword/${emailController.text}',
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
                                  "Forget Password",
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: AppColor.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Button(
                              text: "Sign In",
                              press: enableButton.value
                                  ? () async {
                                      if (_formKey.currentState!.validate()) {
                                        context.read<LoginBloc>().add(
                                              LoginRequestEvent(
                                                username: emailController.text,
                                                password:
                                                    passwordController.text,
                                              ),
                                            );
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
                          "Aleady have an account?",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        TouchableOpacity(
                          activeOpacity: 0.3,
                          onTap: () {
                            context.go('/register');
                          },
                          child: const Text(
                            "Sign Up",
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
      },
    );
  }
}
