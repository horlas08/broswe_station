import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:browse_station/core/config/font.constant.dart';
import 'package:browse_station/core/helper/helper.dart';
import 'package:browse_station/core/service/http.dart';
import 'package:browse_station/screen/component/button.dart';
import 'package:browse_station/screen/component/custom_input.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_validator/form_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:toastification/toastification.dart';

import '../../../core/state/bloc/repo/app/app_bloc.dart';
import '../../../core/state/bloc/repo/app/app_event.dart';
import '../../../core/state/cubic/app_config_cubit.dart';
import '../../../core/state/cubic/login_verify/login_verify_cubit.dart';
import '../../../core/state/cubic/login_verify/login_verify_state.dart';
import '../../component/app_header.dart';

final _formKey = GlobalKey<FormState>();

class CreatePin extends HookWidget {
  const CreatePin({super.key});

  @override
  Widget build(BuildContext context) {
    final pinController = useTextEditingController();
    final confirmPinController = useTextEditingController();
    final enableButton = useState<bool>(false);
    final biometricAvailable = useState<bool>(false);
    final appSetting = context.read<AppConfigCubit>().state;

    void _handleFormChange() {
      enableButton.value = _formKey.currentState!.validate() ?? true;
    }

    return BlocConsumer<LoginVerifyCubit, LoginVerifyState>(
      listener: (context, state) async {
        if (state is LoginVerifyLoading) {
          context.loaderOverlay.show();
        } else if (state is LoginVerifyFailed) {
          context.loaderOverlay.hide();
          showToast(context, title: "Verification Error", desc: state.message);
        } else if (state is LoginVerifySuccess) {
          context.loaderOverlay.hide();
          context.read<AppConfigCubit>().changeAuthState(true);
          context.read<AppBloc>().add(AddUserEvent(userData: state.userData));
          context
              .read<AppBloc>()
              .add(AddAccountEvent(accounts: state.accounts));

          context.go('/user');
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppHeader(
            title: 'Create Pin',
            onpress: () {
              exit(0);
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
                    "Create your  4 digit sign in pin",
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
                    labelText: "Enter Pin",
                    hintText: '4 digit pin',
                    controller: pinController,
                    autofocus: true,
                    textInputType: TextInputType.numberWithOptions(),

                    showCursor: true,
                    validator: ValidationBuilder()
                        .required()
                        .minLength(4)
                        .maxLength(4)
                        .build(),
                    // readOnly: true,
                  ),
                  CustomInput(
                    labelText: "Confirm Pin",
                    hintText: '4 digit pin',
                    textInputType: TextInputType.numberWithOptions(),
                    controller: confirmPinController,
                    // autofocus: true,
                    // showCursor: true,
                    validator: ValidationBuilder()
                        .required()
                        .minLength(4)
                        .maxLength(4)
                        .build(),
                    // readOnly: true,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Button(
                    text: "Continue",
                    press: enableButton.value
                        ? () async {
                            try {
                              context.loaderOverlay.show();
                              var appBox = Hive.box("appBox");

                              final res = await dio.post(
                                "/setpin",
                                data: {
                                  'pin': pinController.text,
                                  'confirm_pin': confirmPinController.text,
                                  'token': appBox.get('token'),
                                },
                              );
                              if (context.mounted) {
                                context.loaderOverlay.hide();
                                if (res.statusCode == HttpStatus.ok) {
                                  showToast(
                                    context,
                                    title: "success",
                                    desc: res.data['message'],
                                    type: ToastificationType.success,
                                  );
                                  appBox.put("hasPin", true);
                                  context.go("/login/verify");
                                } else {
                                  context.loaderOverlay.hide();
                                  throw Exception(res.data['message']);
                                }
                              }
                            } on DioException catch (error) {
                              if (context.mounted) {
                                context.loaderOverlay.hide();
                                showToast(context,
                                    title: "error",
                                    desc: error.response?.data['message']);
                              }
                            } on Exception catch (error) {
                              if (context.mounted) {
                                context.loaderOverlay.hide();
                                showToast(context,
                                    title: "error", desc: error.toString());
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
