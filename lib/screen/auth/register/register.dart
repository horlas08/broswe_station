import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:browse_station/core/helper/helper.dart';
import 'package:browse_station/core/state/cubic/app_config_cubit.dart';
import 'package:browse_station/screen/component/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_validator/form_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:toastification/toastification.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

import '../../../core/config/app.constant.dart';
import '../../../core/config/color.constant.dart';
import '../../../core/config/string.constant.dart';
import '../../../core/service/http.dart';
import '../../../core/state/bloc/register/register_bloc.dart';
import '../../../core/state/bloc/register/register_event.dart';
import '../../../core/state/bloc/register/register_state.dart';
import '../../../core/state/bloc/repo/app/app_bloc.dart';
import '../../../core/state/bloc/repo/app/app_event.dart';
import '../../component/custom_input.dart';

final _formKey = GlobalKey<FormState>();
final phoneController = PhoneController(
  initialValue: const PhoneNumber(isoCode: IsoCode.NG, nsn: ''),
);
final timeController = CountdownController();

class Register extends HookWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final firstNameController = useTextEditingController();
    final lastNameController = useTextEditingController();
    final usernameController = useTextEditingController();
    final verificationFieldController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();
    final refController = useTextEditingController();

    final enableButton = useState<bool>(false);
    final checkButton = useState<bool>(false);
    void _handleFormChange() {
      print('i run');
      enableButton.value = _formKey.currentState!.validate() ?? true;
    }

    final ValueNotifier<bool> timeCount = useState(false);
    final ValueNotifier<bool> phoneValid = useState(false);
    final ValueNotifier<bool> smsRequestPending = useState(false);
    Future<void> sendOtpToPhone(BuildContext context) async {
      smsRequestPending.value = true;
      final res = await dio.post(sendSms,
          data: {'phonenumber': "0${phoneController.value.nsn}"});
      print(res);
      smsRequestPending.value = false;
      if (res.statusCode == HttpStatus.ok) {
        timeCount.value = true;
        timeController.restart();
        if (context.mounted) {
          showToast(
            context,
            title: 'success',
            desc: res.data['message'],
            type: ToastificationType.success,
          );
        }
      } else {
        timeCount.value = false;
        if (context.mounted) {
          showToast(
            context,
            title: 'error',
            desc: res.data['message'],
            type: ToastificationType.error,
          );
        }
      }
    }

    return BlocConsumer<RegisterBloc, RegisterState>(
      listener: (context, state) async {
        if (state is RegisterLoading) {
          context.loaderOverlay.show();
        } else if (state is RegisterFailed) {
          context.loaderOverlay.hide();
          showToast(context, title: "Registration Error", desc: state.message);
        } else if (state is RegisterSuccess) {
          print("register suucessfully");
          _formKey.currentState?.reset();
          context.loaderOverlay.hide();
          showToast(
            context,
            title: "Registration Successful",
            desc: state.message,
            type: ToastificationType.success,
          );

          if (context.mounted) {
            final userData = state.userData;
            userData.addAll({"alt_notification": state.alt_notification});
            context.read<AppBloc>().add(AddUserEvent(userData: userData));

            context
                .read<AppBloc>()
                .add(AddAccountEvent(accounts: state.accounts));
            context.read<AppConfigCubit>().changeAuthState(true);
            context.pushNamed('regSuccessful');
          }
        } else {
          // context.loaderOverlay.hide();
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
                      "Welcome To ${AppString.AppName}",
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
                      "Create Your Account Now and start enjoying faster and better payment experience",
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
                        // autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          children: [
                            CustomInput(
                              labelText: "First Name",
                              needLabel: true,
                              hintText: "Mikes",
                              validator: ValidationBuilder().required().build(),
                              controller: firstNameController,
                            ),
                            CustomInput(
                              labelText: "Last Name",
                              needLabel: true,
                              controller: lastNameController,
                              validator: ValidationBuilder().required().build(),
                              hintText: "John",
                            ),
                            CustomInput(
                              labelText: "Username",
                              hintText: "horlas08",
                              validator: ValidationBuilder().required().build(),
                              controller: usernameController,
                            ),
                            CustomInput(
                              labelText: "Phone Number",
                              isPhone: true,
                              needLabel: true,
                              onPhoneChanged: (phone) {
                                if (phone.isValid() && phone.isValidLength()) {
                                  phoneValid.value = true;
                                } else {
                                  phoneValid.value = false;
                                }
                              },
                              suffixIcon: phoneValid.value
                                  ? SizedBox(
                                      height: 7,
                                      width: 55,
                                      child: TextButton(
                                        onPressed: !timeCount.value
                                            ? () async {
                                                if (!timeCount.value) {
                                                  await sendOtpToPhone(context);
                                                }
                                              }
                                            : null,
                                        child: timeCount.value
                                            ? Countdown(
                                                seconds: 60,
                                                build: (BuildContext context,
                                                        double time) =>
                                                    Text(
                                                  time.toString(),
                                                  // style: TextStyle(
                                                  //   fontSize: 4,
                                                  //   color: Colors.black,
                                                  // ),
                                                ),
                                                interval:
                                                    const Duration(seconds: 1),
                                                // controller:
                                                //     timeController,
                                                onFinished: () {
                                                  timeCount.value = false;

                                                  print('Timer is done!');
                                                },
                                              )
                                            : smsRequestPending.value
                                                ? const Center(
                                                    child: SizedBox(
                                                      height: 10,
                                                      width: 10,
                                                      child:
                                                          CircularProgressIndicator(
                                                        color: AppColor
                                                            .primaryColor,
                                                      ),
                                                    ),
                                                  )
                                                : const Text(
                                                    "Get Codes",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                      ),
                                    )
                                  : null,
                              phoneController: phoneController,
                              hintText: "9014876757",
                            ),
                            CustomInput(
                              labelText: "Verification Code",
                              validator: ValidationBuilder().required().build(),
                              controller: verificationFieldController,
                            ),
                            CustomInput(
                              labelText: "Email Address",
                              needLabel: true,
                              validator: ValidationBuilder()
                                  .email('')
                                  .maxLength(50, '')
                                  .build(),
                              controller: emailController,
                              hintText: 'test@gmail.com',
                            ),
                            CustomInput(
                              labelText: "Password",
                              isPassword: true,
                              validator: ValidationBuilder()
                                  .required()
                                  .minLength(8)
                                  .build(),
                              controller: passwordController,
                              hintText: "*****",
                            ),
                            CustomInput(
                              labelText: "Confirm Password",
                              hintText: "*****",
                              validator: ValidationBuilder()
                                  .required('')
                                  .minLength(8)
                                  .build(),
                              controller: confirmPasswordController,
                              isPassword: true,
                            ),
                            CustomInput(
                              labelText: "Referral Code",
                              controller: refController,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: checkButton.value,
                                  onChanged: (value) {
                                    if (value != null)
                                      checkButton.value = value;
                                  },
                                ),
                                const Expanded(
                                  child: Text.rich(
                                    softWrap: true,
                                    overflow: TextOverflow.fade,
                                    TextSpan(
                                      text:
                                          "By Register, You are agree with our ",
                                      children: [
                                        WidgetSpan(
                                          child: Text(
                                            "terms & conditions ",
                                            style: TextStyle(
                                              color: AppColor.primaryColor,
                                            ),
                                          ),
                                        ),
                                        WidgetSpan(
                                          child: Text("and"),
                                        ),
                                        WidgetSpan(
                                          child: Text(
                                            "privacy and policy",
                                            style: TextStyle(
                                              color: AppColor.primaryColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    // "By Register, You are agree with our terms & conditions and privacy and policy",
                                    // style: TextStyle(
                                    //   fontSize: 15,
                                    // ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Button(
                              text: "Sign Up",
                              press: enableButton.value && checkButton.value
                                  ? () {
                                      if (_formKey.currentState!.validate()) {
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                        context.read<RegisterBloc>().add(
                                              RegisterRequestEvent(
                                                firstname:
                                                    firstNameController.text,
                                                lastname:
                                                    lastNameController.text,
                                                password:
                                                    passwordController.text,
                                                email: emailController.text,
                                                username:
                                                    usernameController.text,
                                                phone:
                                                    "0${phoneController.value.nsn}",
                                                code:
                                                    verificationFieldController
                                                        .text,
                                                ref_code: refController.text,
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
                          "Already have an account?",
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
                            context.go('/login');
                          },
                          child: const Text(
                            "Sign In",
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
