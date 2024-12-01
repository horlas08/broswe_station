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

    useEffect(() {
      // amountController.text = '22';
      // phoneController.value =
      //     PhoneNumber(isoCode: IsoCode.NG, nsn: '9014985680');
      return null;
    }, []);
    final ValueNotifier<bool> enableButton = useState(false);

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
                Button(
                  text: "Recharge Now",
                  press: enableButton.value && selectedPlan.value != ''
                      ? () {
                          final phone = "0${phoneController.value.nsn}";
                          final Map<String, String> data = {
                            "amount": amountController.text,
                            "phone": phone,
                            "trx_id":
                                "${DateTime.now().microsecondsSinceEpoch}",
                            "airtime_type": "vtu",
                            "network": selectedPlan.value
                          };
                          final Map<String, String> viewData = {
                            "Product Type": "Airtime",
                            "Phone Number": phone,
                            "Amount":
                                "${currency(context)}${amountController.text}",
                            "Network": selectedPlan.value
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

Widget NetworkCard(
    {required String image,
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
