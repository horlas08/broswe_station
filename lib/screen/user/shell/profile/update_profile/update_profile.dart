import 'dart:io';

import 'package:browse_station/core/config/color.constant.dart';
import 'package:browse_station/core/helper/helper.dart';
import 'package:browse_station/screen/component/app_header2.dart';
import 'package:browse_station/screen/component/custom_input.dart';
import 'package:browse_station/screen/component/custom_scaffold.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_validator/form_validator.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:ripple_wave/ripple_wave.dart';
import 'package:toastification/toastification.dart';

import '../../../../../core/config/app.constant.dart';
import '../../../../../core/service/http.dart';
import '../../../../../core/service/request/protected.dart';
import '../../../../../core/state/bloc/repo/app/app_bloc.dart';
import '../../../../../core/state/bloc/repo/app/app_event.dart';
import '../../../../../core/state/bloc/repo/app/app_state.dart';
import '../../../../component/button.dart';

final ImagePicker picker = ImagePicker();

class UpdateProfile extends HookWidget {
  const UpdateProfile({super.key});

  @override
  Widget build(BuildContext context) {
    Future _pickImage({required ImageSource source}) async {
      final XFile? image = await picker.pickImage(
        source: source,
        imageQuality: 100,
        maxHeight: 500,
        maxWidth: 500,
      );
      if (image != null) {
        File file = File(image.path);
        String fileName = file.path.split('/').last;
        var appBox = Hive.box("appBox");
        var formData = FormData.fromMap({
          'token': appBox.get('token'),
          'photo': await MultipartFile.fromFile(
            file.path,
            filename: fileName,
          ),
        });
        if (context.mounted) {
          context.loaderOverlay.show();
          final resp = await dio.post(profileUpdate,
              data: formData,
              options: Options(
                contentType: Headers.multipartFormDataContentType,
                headers: {
                  Headers.contentTypeHeader:
                      Headers.multipartFormDataContentType
                },
              ),
              queryParameters: {'token': appBox.get("token")});
          print(resp);
          if (resp.statusCode == HttpStatus.ok && context.mounted) {
            final res = await refreshUSerDetail();

            if (res == null && context.mounted) {
              context.loaderOverlay.hide();
            }

            if (res?.statusCode == HttpStatus.ok && context.mounted) {
              final userData = res?.data['data']['user_data'];
              final alt_notification = res?.data['data']['alt_notification'];
              userData.addAll({"alt_notification": alt_notification});
              context.read<AppBloc>().add(
                    UpdateUserEvent(
                      userData: userData,
                    ),
                  );

              context.loaderOverlay.hide();

              showToast(
                context,
                title: "success",
                desc: resp.data['message'],
                type: ToastificationType.success,
              );
            } else {
              if (context.mounted) context.loaderOverlay.hide();
            }
          }
        }
      }
    }

    final profileKey = GlobalKey<FormState>();
    final firstNameController = useTextEditingController();
    final lastNameController = useTextEditingController();
    final phoneController = useTextEditingController();
    final emailController = useTextEditingController();
    return BlocConsumer<AppBloc, AppState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        firstNameController.text = state.user!.firstName;
        lastNameController.text = state.user!.lastName;
        phoneController.text = state.user!.phoneNumber;
        emailController.text = state.user!.email;
        return CustomScaffold(
          header: const AppHeader2(title: "Update Profile"),
          child: Form(
            key: profileKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Stack(
                    children: [
                      SizedBox(
                        height: 150,
                        width: 150,
                        child: RippleWave(
                          color: AppColor.primaryColor,
                          waveCount: 2,
                          child: Container(
                            height: 140,
                            width: 140,
                            decoration: BoxDecoration(
                              color: AppColor.primaryColor,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: CircleAvatar(
                              minRadius: 2,
                              maxRadius: 30,
                              child: state.user!.photo == null
                                  ? Image.asset(
                                      "assets/images/profile-picture.png",
                                      height: 130,
                                      width: 130,
                                    )
                                  : CachedNetworkImage(
                                      imageUrl: state.user!.photo!,
                                      height: 150,
                                      width: 150,
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator(
                                        color: AppColor.primaryColor,
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
                          style: const ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(AppColor.secondaryColor),
                          ),
                          onPressed: () async {
                            try {
                              _pickImage(source: ImageSource.gallery);
                            } catch (e) {
                              showToast(context,
                                  title: "error", desc: e.toString());
                            }
                          },
                          icon: const Icon(
                            Ionicons.pencil,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomInput(
                        labelText: "First Name",
                        controller: firstNameController,
                        validator: ValidationBuilder().required().build(),
                        hintText: "",
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: CustomInput(
                        labelText: "Last Name",
                        controller: lastNameController,
                        validator: ValidationBuilder().required().build(),
                        hintText: "",
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomInput(
                        labelText: "Email",
                        readOnly: true,
                        controller: emailController,
                        validator:
                            ValidationBuilder().required().email().build(),
                        hintText: "",
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: CustomInput(
                        labelText: "Phone",
                        controller: phoneController,
                        validator: ValidationBuilder().required().build(),
                        hintText: "",
                      ),
                    ),
                  ],
                ),
                Button(
                  text: "Update Now",
                  press: () async {
                    if (profileKey.currentState!.validate()) {
                      try {
                        context.loaderOverlay.show();
                        final resp = await updateProfileRequest(context,
                            firstName: firstNameController.text,
                            lastName: lastNameController.text,
                            phone: phoneController.text);
                        if (resp.statusCode == HttpStatus.ok &&
                            context.mounted) {
                          final res = await refreshUSerDetail();

                          if (res == null && context.mounted) {
                            context.loaderOverlay.hide();
                          }

                          if (res?.statusCode == HttpStatus.ok &&
                              context.mounted) {
                            final userData = res?.data['data']['user_data'];
                            final alt_notification =
                                res?.data['data']['alt_notification'];
                            userData
                                .addAll({"alt_notification": alt_notification});
                            context.read<AppBloc>().add(
                                  UpdateUserEvent(
                                    userData: userData,
                                  ),
                                );
                            // context.read<AppBloc>().add(UpdateUserEvent(
                            //     userData: res?.data['data']['user_data']));
                            context.loaderOverlay.hide();

                            showToast(context,
                                title: "success",
                                desc: resp.data['message'],
                                type: ToastificationType.success);
                            return;
                          } else {
                            if (context.mounted) context.loaderOverlay.hide();
                          }
                        }
                      } on DioException catch (error) {
                        if (context.mounted) {
                          showToast(context,
                              title: "error",
                              desc: error.response?.data['message'],
                              type: ToastificationType.error);
                        }
                      } on Exception catch (error) {
                        if (context.mounted) {
                          showToast(
                            context,
                            title: "error",
                            desc: error.toString(),
                          );
                        }
                      }
                    } else {
                      showToast(
                        context,
                        title: "Field Error",
                        desc: "Please fill all detail correctly",
                      );
                    }
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
