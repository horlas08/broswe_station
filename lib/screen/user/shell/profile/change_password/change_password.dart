import 'dart:io';

import 'package:browse_station/core/helper/helper.dart';
import 'package:browse_station/screen/component/app_header2.dart';
import 'package:browse_station/screen/component/custom_input.dart';
import 'package:browse_station/screen/component/custom_scaffold.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_validator/form_validator.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:toastification/toastification.dart';

import '../../../../../core/service/request/protected.dart';
import '../../../../component/button.dart';

final _changePasswordKey = GlobalKey<FormState>();

class ChangePassword extends HookWidget {
  const ChangePassword({super.key});

  @override
  Widget build(BuildContext context) {
    final oldPasswordController = useTextEditingController();
    final newPasswordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();
    return CustomScaffold(
      header: const AppHeader2(title: "Upgrade Kyc"),
      child: Form(
        key: _changePasswordKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomInput(
              labelText: "Old Password",
              controller: oldPasswordController,
              validator: ValidationBuilder().required().build(),
              hintText: "Enter your old old password",
            ),
            CustomInput(
              labelText: "New Password",
              controller: newPasswordController,
              validator: ValidationBuilder().required().build(),
              hintText: "Enter new password",
            ),
            CustomInput(
              labelText: "Confirm Password",
              controller: confirmPasswordController,
              validator: ValidationBuilder().required().build(),
              hintText: "Confirm Password",
            ),
            Button(
              text: "Update Now",
              press: () async {
                if (_changePasswordKey.currentState!.validate()) {
                  context.loaderOverlay.show();
                  try {
                    final res = await changePasswordRequest(
                      context,
                      old_password: oldPasswordController.text,
                      confirm_password: confirmPasswordController.text,
                      password: newPasswordController.text,
                    );
                    if (context.mounted) {
                      context.loaderOverlay.hide();
                      if (res.statusCode == HttpStatus.ok) {
                        showToast(
                          context,
                          title: "Error",
                          desc: res.data['message'],
                          type: ToastificationType.success,
                        );
                        oldPasswordController.text = '';
                        newPasswordController.text = '';
                        confirmPasswordController.text = '';
                      } else {
                        throw Exception(res.data['message']);
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
                      showToast(
                        context,
                        title: "Error",
                        desc: error.toString(),
                      );
                    }
                  }
                } else {
                  showToast(
                    context,
                    title: "Field Error",
                    desc: "Please fill all the field correctly",
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
