import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:browse_station/core/helper/helper.dart';
import 'package:browse_station/core/service/request/protected.dart';
import 'package:browse_station/data/model/data_plan.dart';
import 'package:browse_station/screen/component/app_header2.dart';
import 'package:browse_station/screen/component/custom_input.dart';
import 'package:browse_station/screen/component/custom_scaffold.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:form_validator/form_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:toastification/toastification.dart';
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
final _dataTypeKey = GlobalKey<DropdownSearchState<String>>();
final _dataPlanKey = GlobalKey<DropdownSearchState<DataPlan>>();

enum NsnFormat {
  national,
  international,
}

class Data extends HookWidget {
  const Data({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController amountController =
        useTextEditingController(text: '');

    final ValueNotifier<Map<String, dynamic>> dataResponse = useState({});
    final user = context.read<AppBloc>().state.user;

    final ValueNotifier<bool> enableButton = useState(false);
    final ValueNotifier<bool> haveCoupon = useState(false);
    void _handleFormChange() {
      enableButton.value = _airtimeFormKey.currentState!.validate() ?? true;
    }

    final ValueNotifier<String> selectedNetwork = useState('');
    final ValueNotifier<String> selectedDataType = useState('');
    final ValueNotifier<DataPlan?> selectedDataPlan = useState(null);
    final ValueNotifier<List<DataPlan>> dataPlans = useState([]);
    final ValueNotifier<bool> dataIsLoading = useState(false);
    final TextEditingController commissionController =
        useTextEditingController();
    final TextEditingController promotionController =
        useTextEditingController();
    final Map<String, String> userSettings =
        context.read<AppBloc>().state.settings!;
    print(userSettings);

    useEffect(() {
      if (selectedNetwork.value != '') {
        getDataPlanRequest(context, selectedNetwork).then(
          (value) {
            if (value != null) {
              dataResponse.value = value;
            }
          },
        ).onError(
          (error, stackTrace) {
            if (context.mounted)
              showToast(context, title: "error", desc: error.toString());
          },
        );
      }

      return null;
    }, [selectedNetwork.value]);
    final FlutterNativeContactPicker _contactPicker =
        FlutterNativeContactPicker();

    return BlocConsumer<AppConfigCubit, AppConfig>(
      listener: (context, state) {
        if (state.pinState == true) {}
      },
      builder: (context, state) {
        return CustomScaffold(
          header: const AppHeader2(
            title: 'Buy Data',
          ),
          headerDesc: 'Buy Data for yourself and loved ones',
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
                        selected: selectedNetwork),
                    NetworkCard(
                        image: "assets/images/network/airtel.png",
                        name: 'airtel',
                        selected: selectedNetwork),
                    NetworkCard(
                        image: "assets/images/network/glo.jpg",
                        name: 'glo',
                        selected: selectedNetwork),
                    NetworkCard(
                        image: "assets/images/network/9mobile.png",
                        name: '9mobile',
                        selected: selectedNetwork),
                  ],
                ),
                const SizedBox(
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
                const SizedBox(
                  height: 20,
                ),
                if (dataResponse.value.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Select Type",
                        style: TextStyle(
                          color: AppColor.greyLightColor,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      DropdownSearch<String>(
                        items: (filter, infiniteScrollProps) =>
                            dataResponse.value.keys.toList(),
                        compareFn: (item, selectedItem) {
                          return item.toUpperCase().trim() ==
                              selectedItem.toUpperCase().trim();
                        },

                        selectedItem: selectedDataType.value,
                        key: _dataTypeKey,
                        popupProps: PopupProps.modalBottomSheet(
                          // disabledItemFn: (item) => item.id == 'Item 3',
                          fit: FlexFit.loose,
                          showSearchBox: true,
                          title: Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 28.0),
                              child: AutoSizeText(
                                "Data Type list for ${selectedNetwork.value}"
                                    .toUpperCase(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                                maxLines: 1,
                              ),
                            ),
                          ),
                          containerBuilder: (context, popupWidget) {
                            return Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: popupWidget,
                            );
                          },

                          disabledItemFn: (item) {
                            return false;
                          },
                          itemBuilder: (context, item, isDisabled, isSelected) {
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(item,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          )),
                                      Spacer(),
                                      if (_dataTypeKey
                                              .currentState?.getSelectedItem !=
                                          null)
                                        if (_dataTypeKey
                                                .currentState?.getSelectedItem
                                                ?.toUpperCase()
                                                .trim() ==
                                            item.toUpperCase().trim())
                                          const Icon(
                                            Ionicons.checkmark,
                                            color: AppColor.primaryColor,
                                          )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  const Divider()
                                ],
                              ),
                            );
                          },
                          searchFieldProps: const TextFieldProps(
                            decoration: InputDecoration(
                              suffixIcon: Icon(Ionicons.search),
                              hintText: 'Search here',
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 14),
                            ),
                          ),
                        ),

                        validator: (value) {
                          if (value == null) {
                            return 'required';
                          }
                          return null;
                        },
                        suffixProps: DropdownSuffixProps(
                          dropdownButtonProps: DropdownButtonProps(
                            color: AppColor.primaryColor,
                            iconClosed: !dataIsLoading.value
                                ? const Icon(
                                    Ionicons.chevron_down_outline,
                                    size: 24,
                                  )
                                : const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator()),
                          ),
                        ),

                        onChanged: (value) {
                          print(_dataTypeKey.currentState?.getSelectedItem);
                          selectedDataType.value = value!;
                          final List<DataPlan> dataPlan = DataPlan.fromJsonList(
                              dataResponse.value[value] as List);
                          dataPlans.value = dataPlan;
                          print(dataPlans.value);
                          // selectedPlan.value = value;
                          // amountController.text = value!.amount.toString();
                        },

                        // mode: Mode.form,
                        decoratorProps: const DropDownDecoratorProps(
                          decoration: InputDecoration(
                            hintText: "Select Data Plan",
                            isCollapsed: false,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 14),
                          ),
                        ),

                        clickProps: ClickProps(
                          onTapUp: (details) async {
                            // if (selectedNetwork.value == '' ||
                            //     selectedNetwork.value.isEmpty) {
                            //   showToast(
                            //     context,
                            //     title: "Validation Error",
                            //     desc: "Please Select Network",
                            //   );
                            // } else {
                            //   dataIsLoading.value = true;
                            //   final data = await getDataPlanRequest();
                            //   if (data.isNotEmpty) {
                            //     dataPlans.value = data;
                            //     dataIsLoading.value = false;
                            //   }
                            // }
                          },
                        ),

                        itemAsString: (item) {
                          return "${item}";
                        },

                        // enabled: selectedPlan.value.isNotEmpty,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                if (dataResponse.value.isNotEmpty &&
                    selectedDataType.value.isNotEmpty &&
                    dataPlans.value.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Select Plan",
                        style: TextStyle(
                          color: AppColor.greyLightColor,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      DropdownSearch<DataPlan>(
                        items: (filter, infiniteScrollProps) => dataPlans.value,
                        compareFn: (item, selectedItem) {
                          return item.id == selectedItem.id;
                        },

                        selectedItem: selectedDataPlan.value,
                        key: _dataPlanKey,
                        popupProps: PopupProps.modalBottomSheet(
                          // disabledItemFn: (item) => item.id == 'Item 3',
                          fit: FlexFit.loose,
                          showSearchBox: true,
                          title: Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 28.0),
                              child: AutoSizeText(
                                "Data Plan list for ${selectedNetwork.value}  ${selectedDataType.value}"
                                    .toUpperCase(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                                maxLines: 1,
                              ),
                            ),
                          ),
                          containerBuilder: (context, popupWidget) {
                            return Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: popupWidget,
                            );
                          },

                          disabledItemFn: (item) {
                            return false;
                          },
                          itemBuilder: (context, item, isDisabled, isSelected) {
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text("${item.plan} ${item.validity!}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          )),
                                      Spacer(),
                                      if (_dataPlanKey
                                              .currentState?.getSelectedItem !=
                                          null)
                                        if (_dataPlanKey.currentState
                                                ?.getSelectedItem?.id ==
                                            item.id)
                                          const Icon(
                                            Ionicons.checkmark,
                                            color: AppColor.primaryColor,
                                          )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  const Divider()
                                ],
                              ),
                            );
                          },
                          searchFieldProps: const TextFieldProps(
                            decoration: InputDecoration(
                              suffixIcon: Icon(Ionicons.search),
                              hintText: 'Search here',
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 14),
                            ),
                          ),
                        ),

                        validator: (value) {
                          if (value == null) {
                            return 'required';
                          }
                          return null;
                        },
                        suffixProps: DropdownSuffixProps(
                          dropdownButtonProps: DropdownButtonProps(
                            color: AppColor.primaryColor,
                            iconClosed: !dataIsLoading.value
                                ? const Icon(
                                    Ionicons.chevron_down_outline,
                                    size: 24,
                                  )
                                : const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator()),
                          ),
                        ),

                        onChanged: (value) {
                          print(_dataPlanKey.currentState?.getSelectedItem);
                          selectedDataPlan.value = value!;
                          amountController.text = user!.userType
                              ? value.amount_agent.toString()
                              : value.amount.toString();
                        },

                        // mode: Mode.form,
                        decoratorProps: const DropDownDecoratorProps(
                          decoration: InputDecoration(
                            hintText: "Select Data Plan",
                            isCollapsed: false,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 14),
                          ),
                        ),

                        clickProps: ClickProps(
                          onTapUp: (details) async {},
                        ),

                        itemAsString: (item) {
                          return "${item.toString()}";
                        },

                        // enabled: selectedPlan.value.isNotEmpty,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                if (selectedDataPlan.value?.amount != null)
                  CustomInput(
                    labelText: 'Amount',
                    controller: amountController,
                    hintText: "Amount",
                    readOnly: true,
                    prefix: Text(
                      currency(context),
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    textInputType: const TextInputType.numberWithOptions(),
                  ),
                const SizedBox(
                  height: 20,
                ),
                if (selectedNetwork.value.isNotEmpty &&
                    selectedDataPlan.value?.id != null)
                  CustomInput(
                    labelText: 'Commission',
                    controller: commissionController
                      ..value = TextEditingValue(
                          text: user!.userType
                              ? selectedDataPlan.value!.cashback_agent!
                              : selectedDataPlan.value!.cashback_user!),
                    hintText: "",
                    readOnly: true,
                    textInputType: const TextInputType.numberWithOptions(),
                  ),
                if (!user!.userType &&
                    selectedNetwork.value.isNotEmpty &&
                    selectedDataPlan.value?.id != null)
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "You can get up to ",
                          style: TextStyle(
                            color: AppColor.danger,
                          ),
                        ),
                        TextSpan(
                          text: "${selectedDataPlan.value!.cashback_agent!}NGN",
                          style: TextStyle(
                            color: AppColor.success,
                          ),
                        ),
                        TextSpan(
                          text: " as commission,",
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
                if (!user!.userType &&
                    selectedNetwork.value.isNotEmpty &&
                    selectedDataPlan.value?.id != null)
                  const SizedBox(
                    height: 20,
                  ),
                Row(
                  children: [
                    Checkbox.adaptive(
                      value: haveCoupon.value,
                      tristate: false,
                      fillColor: WidgetStatePropertyAll(Colors.white),
                      checkColor: AppColor.primaryColor,
                      onChanged: (value) => haveCoupon.value = value!,
                      shape: CircleBorder(
                        side: BorderSide(
                          width: 1,
                          color: AppColor.primaryColor,
                          style: BorderStyle.solid,
                        ),
                      ),
                      side: BorderSide(
                        color: AppColor.primaryColor,
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                    ),
                    Text("Do you have a promo code ?"),
                  ],
                ),
                if (haveCoupon.value)
                  TouchableOpacity(
                    onTap: () async {
                      if (promotionController.text.isEmpty) {
                        return showToast(
                          context,
                          title: "error",
                          desc: "Please enter code to validate",
                        );
                      }
                      try {
                        context.loaderOverlay.show();
                        final response = await validatePromoCode(
                          context,
                          code: promotionController.text,
                        );

                        if (!context.mounted) return;
                        if (response.statusCode == HttpStatus.ok) {
                          context.loaderOverlay.hide();
                          return showToast(
                            context,
                            title: "success",
                            desc: response.data['message'],
                            type: ToastificationType.success,
                          );
                        } else {
                          context.loaderOverlay.hide();
                          throw new Exception(response.data['message']);
                        }
                      } on DioException catch (error) {
                        context.loaderOverlay.hide();

                        showToast(
                          context,
                          title: "error",
                          desc: error.response?.data['message'],
                        );
                      } catch (error) {
                        context.loaderOverlay.hide();
                        showToast(
                          context,
                          title: "error",
                          desc: error.toString(),
                        );
                      }
                    },
                    child: SizedBox(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 5,
                            child: CustomInput(
                              labelText: "Promo Code (optional)",
                              controller: promotionController,
                              validator: haveCoupon.value
                                  ? ValidationBuilder().required().build()
                                  : ValidationBuilder().build(),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                color: AppColor.primaryColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(
                                Icons.check,
                                size: 24,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                Button(
                  text: "Subscribe Now",
                  press: enableButton.value && selectedNetwork.value != ''
                      ? () {
                          final phone = phoneController.value.countryCode +
                              phoneController.value.nsn;

                          final Map<String, String> data = {
                            "variation_id":
                                selectedDataPlan.value!.id!.toString(),
                            "phone": "0${phoneController.value.nsn}",
                            "trx_id": getTrx(),
                            "data_type": selectedDataType.value,
                            "network_id":
                                "${getNetworkIdByName(network: selectedNetwork.value)}",
                            "promocode": promotionController.text.isNotEmpty
                                ? promotionController.text
                                : ''
                          };
                          print(data);
                          // return;
                          final Map<String, String> viewData = {
                            "Product Type": "Data",
                            "Phone Number": phone,
                            "Amount":
                                "${currency(context)}${amountController.text}",
                            "Validity": selectedDataPlan.value!.validity!,
                            "Plan": selectedDataPlan.value!.plan!,
                            "Network": selectedNetwork.value,
                            "promo code": promotionController.text.isNotEmpty
                                ? promotionController.text
                                : 'No Code'
                          };
                          context.push(
                            '/confirm/transaction',
                            extra: {
                              'function': buyDataRequest,
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
