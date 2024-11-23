import 'dart:io';

import 'package:browse_station/core/helper/helper.dart';
import 'package:browse_station/core/service/request/protected.dart';
import 'package:browse_station/screen/component/app_header2.dart';
import 'package:browse_station/screen/component/custom_input.dart';
import 'package:browse_station/screen/component/custom_scaffold.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_validator/form_validator.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:toastification/toastification.dart';

import '../../../../component/button.dart';

final _changePinKey = GlobalKey<FormState>();

class ChangePin extends HookWidget {
  const ChangePin({super.key});

  @override
  Widget build(BuildContext context) {
    final oldPinController = useTextEditingController();
    final newPinController = useTextEditingController();
    final confirmPinController = useTextEditingController();
    return CustomScaffold(
      header: const AppHeader2(title: "Change Pin"),
      child: Form(
        key: _changePinKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomInput(
              labelText: "Old Pin",
              controller: oldPinController,
              textInputType: TextInputType.numberWithOptions(),
              validator: ValidationBuilder()
                  .required()
                  .minLength(4)
                  .maxLength(4)
                  .build(),
              hintText: "Enter Your old 4 digit Pin Here",
            ),
            CustomInput(
              labelText: "New Pin",
              textInputType: TextInputType.numberWithOptions(),
              controller: newPinController,
              validator: ValidationBuilder()
                  .required()
                  .minLength(4)
                  .maxLength(4)
                  .build(),
              hintText: "Enter new 4 digit pin",
            ),
            CustomInput(
              labelText: "Confirm Pin",
              textInputType: const TextInputType.numberWithOptions(),
              controller: confirmPinController,
              validator: ValidationBuilder()
                  .required()
                  .minLength(4)
                  .maxLength(4)
                  .build(),
              hintText: "Confirm Pin",
            ),
            Button(
              text: "Update Now",
              press: () async {
                if (_changePinKey.currentState!.validate()) {
                  context.loaderOverlay.show();
                  try {
                    final res = await changePinRequest(
                      context,
                      old_pin: oldPinController.text,
                      confirm_pin: confirmPinController.text,
                      pin: newPinController.text,
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
                        oldPinController.text = '';
                        newPinController.text = '';
                        confirmPinController.text = '';
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
