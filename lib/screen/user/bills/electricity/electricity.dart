import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:browse_station/core/helper/helper.dart';
import 'package:browse_station/data/model/electricity_providers.dart';
import 'package:browse_station/screen/component/app_header2.dart';
import 'package:browse_station/screen/component/custom_input.dart';
import 'package:browse_station/screen/component/custom_scaffold.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:form_validator/form_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

import '../../../../core/config/color.constant.dart';
import '../../../../core/service/request/protected.dart';
import '../../../component/button.dart';

final PhoneController phoneController = PhoneController(
  initialValue: const PhoneNumber(isoCode: IsoCode.NG, nsn: ''),
);
final _airtimeFormKey = GlobalKey<FormState>();
final _meterTypeKey = GlobalKey<DropdownSearchState<String>>();
final _meterLocationKey =
    GlobalKey<DropdownSearchState<ElectricityProviders>>();

class Electricity extends HookWidget {
  const Electricity({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController amountController = useTextEditingController();
    final TextEditingController meterNumberController =
        useTextEditingController();
    final TextEditingController meterNameController =
        useTextEditingController();

    final TextEditingController meterTypeController =
        useTextEditingController();

    final ValueNotifier<bool> enableButton = useState(false);

    void _handleFormChange() {
      enableButton.value = _airtimeFormKey.currentState!.validate() ?? true;
    }

    final ValueNotifier<List<ElectricityProviders>> meterLocations =
        useState([]);
    final ValueNotifier<String?> meterType = useState(null);
    final ValueNotifier<ElectricityProviders?> selectedLocation =
        useState(null);
    final ValueNotifier<bool> dataIsLoading = useState(false);
    final FocusNode meterNumberFocus = useFocusNode();
    Future<void> onFocusChange() async {
      if (meterNumberFocus.hasFocus == false &&
          meterNumberController.value.text != '' &&
          meterTypeController.text.isNotEmpty &&
          selectedLocation.value != null) {
        context.loaderOverlay.show();
        try {
          final res = await verifyMeterRequest(context, meterNumberController,
              selectedLocation, meterTypeController);
          if (context.mounted) {
            context.loaderOverlay.hide();
            if (res.statusCode != HttpStatus.ok) {
              throw DioException(
                  requestOptions:
                      RequestOptions(data: {'message': res.data['message']}));
            } else {
              meterNameController.text = res.data['data']['customer_name'];
            }
          }
        } on DioException catch (error) {
          if (context.mounted) {
            context.loaderOverlay.hide();
            meterNameController.text = '';
            showToast(context,
                title: "Meter Lookup Failed",
                desc: error.response?.data['message']);
          }
        } on Exception catch (error) {
          if (context.mounted) {
            context.loaderOverlay.hide();
            meterNameController.text = '';
            showToast(
              context,
              title: "Meter Lookup Failed",
              desc: error.toString(),
            );
          }
        }
      }
    }

    useEffect(() {
      meterNumberFocus.addListener(onFocusChange);
      return () => meterNumberFocus.removeListener(onFocusChange);
    }, [meterNumberFocus]);

    useEffect(() {
      if (meterNumberController.text.isNotEmpty) {
        onFocusChange();
      }
      return null;
    }, [selectedLocation.value, meterType.value]);

    final FlutterNativeContactPicker _contactPicker =
        FlutterNativeContactPicker();
    return CustomScaffold(
      header: const AppHeader2(
        title: 'Buy Electricity',
      ),
      headerDesc: 'Buy electricity token instantly',
      child: Form(
        key: _airtimeFormKey,
        onChanged: _handleFormChange,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Select Disco",
                  style: TextStyle(
                    color: AppColor.greyLightColor,
                    height: 1.2,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                DropdownSearch<ElectricityProviders>(
                  items: (filter, infiniteScrollProps) => meterLocations.value,
                  compareFn: (item, selectedItem) {
                    return item.id == selectedItem.id;
                  },
                  onBeforePopupOpening: (selectedItem) async {
                    if (meterNumberController.text.isEmpty) {
                      showToast(
                        context,
                        title: "Validation Error",
                        desc: "Please Enter Meter Number",
                      );
                      return false;
                    } else if (meterLocations.value.isEmpty) {
                      await getMeterLocationRequest(context).then(
                        (value) {
                          meterLocations.value = value;
                          _meterLocationKey.currentState?.openDropDownSearch();
                        },
                      ).onError(
                        (error, stackTrace) {
                          if (context.mounted) {
                            showToast(context,
                                title: "error", desc: error.toString());
                          }
                        },
                      );
                      return false;
                    }
                  },
                  selectedItem: selectedLocation.value,
                  key: _meterLocationKey,
                  popupProps: PopupProps.modalBottomSheet(
                    // disabledItemFn: (item) => item.id == 'Item 3',
                    fit: FlexFit.loose,
                    showSearchBox: true,
                    title: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 28.0),
                        child: AutoSizeText(
                          "Select Meter Location".toUpperCase(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                          maxLines: 1,
                        ),
                      ),
                    ),
                    containerBuilder: (context, popupWidget) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
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
                                Text(item.name!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    )),
                                Spacer(),
                                if (_meterLocationKey
                                        .currentState?.getSelectedItem !=
                                    null)
                                  if (_meterLocationKey
                                          .currentState?.getSelectedItem?.id ==
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
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 14),
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
                    selectedLocation.value = value;
                    // selectedPlan.value = value;
                  },

                  // mode: Mode.form,
                  decoratorProps: const DropDownDecoratorProps(
                    decoration: InputDecoration(
                      hintText: "Select location",
                      isCollapsed: false,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 14),
                    ),
                  ),

                  itemAsString: (item) {
                    return "${item.name}";
                  },

                  // enabled: selectedPlan.value.isNotEmpty,
                ),
              ],
            ),
            CustomInput(
              labelText: 'Electricity Number',
              hintText: "Electricity Number",
              textInputType: TextInputType.numberWithOptions(),
              controller: meterNumberController,
              focusNode: meterNumberFocus,
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Meter Type",
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
                      ["Prepaid", 'Postpaid'],
                  compareFn: (item, selectedItem) {
                    return item == selectedItem;
                  },

                  // selectedItem: selectedLocation.value,
                  key: _meterTypeKey,
                  popupProps: PopupProps.modalBottomSheet(
                    fit: FlexFit.loose,
                    showSearchBox: true,
                    title: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 28.0),
                        child: AutoSizeText(
                          "Select Meter Type".toUpperCase(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                          maxLines: 1,
                        ),
                      ),
                    ),
                    containerBuilder: (context, popupWidget) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
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
                                if (_meterTypeKey
                                        .currentState?.getSelectedItem !=
                                    null)
                                  if (_meterTypeKey
                                          .currentState?.getSelectedItem ==
                                      item)
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
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 14),
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
                    print(_meterTypeKey.currentState?.getSelectedItem);
                    if (value != null) {
                      meterType.value = value;
                      meterTypeController.text = value;
                    }

                    // amountController.text = value;
                  },
                  onBeforePopupOpening: (selectedItem) async {
                    if (meterNumberController.text.isEmpty) {
                      showToast(
                        context,
                        title: "Validation Error",
                        desc: "Please Enter Meter Number",
                      );
                      return false;
                    } else if (selectedLocation.value == null) {
                      showToast(
                        context,
                        title: "Validation Error",
                        desc: "Please Enter Meter Number",
                      );
                      return false;
                    } else {
                      return true;
                    }
                  },
                  // mode: Mode.form,
                  decoratorProps: const DropDownDecoratorProps(
                    decoration: InputDecoration(
                      hintText: "Select meter type",
                      isCollapsed: false,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 14),
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
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            CustomInput(
              labelText: 'Customer Name',
              controller: meterNameController,
              hintText: "__",
              readOnly: true,
              validator: ValidationBuilder().required().build(),
              textInputType: const TextInputType.numberWithOptions(),
            ),
            CustomInput(
              labelText: 'Amount',
              controller: amountController,
              hintText: "Amount",
              validator: ValidationBuilder().required().build(),
              prefix: Text(
                currency(context),
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
              textInputType: const TextInputType.numberWithOptions(),
            ),
            const SizedBox(
              height: 20,
            ),
            Button(
              text: "Subscribe Now",
              press: enableButton.value && selectedLocation.value != ''
                  ? () {
                      final Map<String, String> data = {
                        "amount": amountController.text,
                        "meter_number": meterNumberController.text,
                        "trx_id": getTrx(),
                        "disco": selectedLocation.value!.id!.toString(),
                        "customer_name": meterNameController.text,
                        "meter_type": meterTypeController.text.toLowerCase()
                      };
                      final Map<String, String> viewData = {
                        "Meter Number": meterNumberController.text,
                        "Meter Type": meterTypeController.text,
                        "Meter Location": selectedLocation.value!.name!,
                        "Customer Name": meterNameController.text,
                        "Amount":
                            "${currency(context)}${amountController.text}",
                      };
                      context.push(
                        '/confirm/transaction',
                        extra: {
                          'function': buyMeterRequest,
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
