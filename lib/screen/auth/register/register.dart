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
import 'package:toastification/toastification.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

import '../../../core/config/color.constant.dart';
import '../../../core/config/string.constant.dart';
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
class Register extends HookWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final firstNameController = useTextEditingController();
    final lastNameController = useTextEditingController();
    final usernameController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();

    final enableButton = useState<bool>(false);
    final checkButton = useState<bool>(false);
    void _handleFormChange() {
      print('i run');
      enableButton.value = _formKey.currentState!.validate() ?? true;
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
          showToast(context,
              title: "Registration Successful",
              desc: state.message,
              type: ToastificationType.success);

          if (context.mounted) {
            // context.read<AppConfigCubit>().changeOnboardStatus(true);
            print(state.userData);
            context.read<AppBloc>().add(AddUserEvent(userData: state.userData));

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
                              phoneController: phoneController,
                              hintText: "9014876757",
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
                                            " privacy and policy",
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
