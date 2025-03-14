import 'package:browse_station/core/helper/helper.dart';
import 'package:browse_station/core/service/request/protected.dart';
import 'package:browse_station/screen/component/app_header2.dart';
import 'package:browse_station/screen/component/custom_input.dart';
import 'package:browse_station/screen/component/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

import '../../../../core/config/color.constant.dart';
import '../../../../core/state/bloc/repo/app/app_bloc.dart';
import '../../../../core/state/cubic/app_config_cubit.dart';
import '../../../../data/model/app_config.dart';
import '../../../component/button.dart';

final PhoneController phoneController = PhoneController(
  initialValue: const PhoneNumber(isoCode: IsoCode.NG, nsn: ''),
);
final _airtimeFormKey = GlobalKey<FormState>();

enum NsnFormat {
  national,
  international,
}

class Airtime extends HookWidget {
  const Airtime({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController amountController = useTextEditingController();
    final TextEditingController commissionController =
    useTextEditingController();
    final TextEditingController promotionController =
    useTextEditingController();
    final Map<String, String> userSettings =
    context
        .read<AppBloc>()
        .state
        .settings!;
    print(userSettings);
    final user = context
        .read<AppBloc>()
        .state
        .user!;
    useEffect(() {
      // amountController.text = '22';
      // phoneController.value =
      //     PhoneNumber(isoCode: IsoCode.NG, nsn: '9014985680');
      return null;
    }, []);
    final ValueNotifier<bool> enableButton = useState(false);
    final ValueNotifier<bool> haveCoupon = useState(false);

    void _handleFormChange() {
      enableButton.value = _airtimeFormKey.currentState!.validate() ?? true;
    }

    final ValueNotifier<String> selectedPlan = useState('');

    final FlutterNativeContactPicker _contactPicker =
    FlutterNativeContactPicker();

    return BlocConsumer<AppConfigCubit, AppConfig>(
      listener: (context, state) {
        if (state.pinState == true) {}
      },
      builder: (context, state) {
        return CustomScaffold(
          header: const AppHeader2(
            title: 'Buy Airtime',
          ),
          headerDesc: 'Buy Airtime for yourself and loved ones',
          child: Form(
            key: _airtimeFormKey,
            onChanged: _handleFormChange,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    NetworkCard(
                        image: "assets/images/network/mtn.png",
                        name: 'mtn',
                        selected: selectedPlan),
                    NetworkCard(
                        image: "assets/images/network/airtel.png",
                        name: 'airtel',
                        selected: selectedPlan),
                    NetworkCard(
                        image: "assets/images/network/glo.jpg",
                        name: 'glo',
                        selected: selectedPlan),
                    NetworkCard(
                        image: "assets/images/network/9mobile.png",
                        name: '9mobile',
                        selected: selectedPlan),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                CustomInput(
                  labelText: 'Phone Number',
                  isPhone: true,
                  phoneController: phoneController,
                  hintText: "Phone Number",
                  suffixIcon: IconButton(
                    onPressed: () async {
                      final contact = await _contactPicker.selectContact();
                      if (contact != null) {
                        phoneController.value = PhoneNumber(
                          isoCode: IsoCode.NG,
                          nsn: contact.phoneNumbers!.last,
                        );
                      }
                    },
                    icon: const Icon(
                      Ionicons.person_circle_outline,
                      size: 35,
                    ),
                  ),
                ),
                CustomInput(
                  labelText: 'Amount',
                  controller: amountController,
                  hintText: "Amount",
                  textInputType: const TextInputType.numberWithOptions(),
                ),
                const SizedBox(
                  height: 20,
                ),
                if (selectedPlan.value.isNotEmpty)
                  CustomInput(
                    labelText: 'Commission',
                    controller: commissionController
                      ..value = TextEditingValue(
                          text: userSettings[getCommissionHelperByNetwork(
                              selectedPlan.value, user)]!),
                    hintText: "",
                    readOnly: true,
                    textInputType: const TextInputType.numberWithOptions(),
                  ),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "You can get up to",
                        style: TextStyle(
                          color: AppColor.danger,
                        ),
                      ),
                      TextSpan(
                        text: userSettings[getCommissionHelperByNetwork(
                            selectedPlan.value, user)]!,
                        style: TextStyle(
                          color: AppColor.success,
                        ),
                      ),
                      TextSpan(
                        text: "% as commission,",
                        style: TextStyle(
                          color: AppColor.danger,
                        ),
                      ),
                      WidgetSpan(
                        child: TouchableOpacity(
                          onTap: () {
                            context.pushNamed("agent");
                          },
                          child: Text(
                            " click here",
                            style: TextStyle(
                              color: AppColor.blueColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      TextSpan(
                        text: " to upgrade your account to agent account",
                        style: TextStyle(
                          color: AppColor.danger,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                // Row(
                //   children: [
                //     Checkbox.adaptive(
                //       value: haveCoupon.value,
                //       tristate: false,
                //       fillColor: WidgetStatePropertyAll(Colors.white),
                //       checkColor: AppColor.primaryColor,
                //       onChanged: (value) => haveCoupon.value = value!,
                //       shape: CircleBorder(
                //         side: BorderSide(
                //           width: 1,
                //           color: AppColor.primaryColor,
                //           style: BorderStyle.solid,
                //         ),
                //       ),
                //       side: BorderSide(
                //         color: AppColor.primaryColor,
                //         width: 2,
                //         style: BorderStyle.solid,
                //       ),
                //     ),
                //     Text("Do you have a promo code ?"),
                //   ],
                // ),
                // if (haveCoupon.value)
                //   TouchableOpacity(
                //     onTap: () async {
                //       if (promotionController.text.isEmpty) {
                //         return showToast(
                //           context,
                //           title: "error",
                //           desc: "Please enter code to validate",
                //         );
                //       }
                //       try {
                //         context.loaderOverlay.show();
                //         final response = await validatePromoCode(
                //           context,
                //           code: promotionController.text,
                //         );
                //         if (!context.mounted) return;
                //         if (response.statusCode == HttpStatus.ok) {
                //           context.loaderOverlay.hide();
                //           return showToast(
                //             context,
                //             title: "success",
                //             desc: response.data['message'],
                //             type: ToastificationType.success,
                //           );
                //         } else {
                //           context.loaderOverlay.hide();
                //           throw new Exception(response.data['message']);
                //         }
                //       } on DioException catch (error) {
                //         context.loaderOverlay.hide();
                //         showToast(
                //           context,
                //           title: "success",
                //           desc: error.response?.data['message'],
                //         );
                //       } catch (error) {
                //         context.loaderOverlay.hide();
                //         showToast(
                //           context,
                //           title: "success",
                //           desc: error.toString(),
                //         );
                //       }
                //     },
                //     child: SizedBox(
                //       child: Row(
                //         crossAxisAlignment: CrossAxisAlignment.center,
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: [
                //           Expanded(
                //             flex: 5,
                //             child: CustomInput(
                //               labelText: "Promo Code (optional)",
                //               controller: promotionController,
                //               validator: haveCoupon.value
                //                   ? ValidationBuilder().required().build()
                //                   : ValidationBuilder().build(),
                //             ),
                //           ),
                //           SizedBox(
                //             width: 15,
                //           ),
                //           Expanded(
                //             flex: 1,
                //             child: Container(
                //               height: 60,
                //               decoration: BoxDecoration(
                //                 color: AppColor.primaryColor,
                //                 borderRadius: BorderRadius.circular(20),
                //               ),
                //               child: Icon(
                //                 Icons.check,
                //                 size: 24,
                //                 color: Colors.white,
                //               ),
                //             ),
                //           )
                //         ],
                //       ),
                //     ),
                //   ),
                // const SizedBox(
                //   height: 20,
                // ),
                Button(
                  text: "Recharge Now",
                  press: enableButton.value && selectedPlan.value != ''
                      ? () {
                    final phone = "0${phoneController.value.nsn}";
                    final Map<String, String> data = {
                      "amount": amountController.text,
                      "phone": phone,
                      "trx_id":
                      "${DateTime
                          .now()
                          .microsecondsSinceEpoch}",
                      "airtime_type": "vtu",
                      "network": selectedPlan.value,
                      // "promocode": promotionController.text.isNotEmpty
                      //     ? promotionController.text
                      //     : ''
                    };
                    final Map<String, String> viewData = {
                      "Product Type": "Airtime",
                      "Phone Number": phone,
                      "Amount":
                      "${currency(context)}${amountController.text}",
                      "Network": selectedPlan.value,
                      // "promo code": promotionController.text.isNotEmpty
                      //     ? promotionController.text
                      //     : 'No Code'
                    };
                    context.push(
                      '/confirm/transaction',
                      extra: {
                        'function': buyAirtimeRequest,
                        'data': data,
                        'viewData': viewData,
                      },
                    );
                  }
                      : null,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

Widget NetworkCard({required String image,
  required String name,
  required ValueNotifier<String> selected}) {
  return TouchableOpacity(
    onTap: () {
      selected.value = name;
    },
    child: Stack(
      children: [
        Positioned(
          right: 0,
          child: Icon(
            Ionicons.checkmark_done_circle,
            size: 20,
            color: selected.value != name
                ? AppColor.greyColor.withOpacity(0.6)
                : AppColor.secondaryColor,
          ),
        ),
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected.value != name
                  ? AppColor.greyColor.withOpacity(0.6)
                  : AppColor.secondaryColor,
              width: 2,
            ),
          ),
          child: Center(
            child: SizedBox(
              width: 25,
              height: 25,
              child: Image.asset(
                image,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
