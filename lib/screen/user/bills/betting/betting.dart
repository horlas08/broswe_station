import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:browse_station/core/helper/helper.dart';
import 'package:browse_station/core/service/request/protected.dart';
import 'package:browse_station/data/model/betting_providers.dart';
import 'package:browse_station/data/model/cable_plan.dart';
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
import '../../../component/button.dart';

final PhoneController phoneController = PhoneController(
  initialValue: const PhoneNumber(isoCode: IsoCode.NG, nsn: '9014985680'),
);
final _airtimeFormKey = GlobalKey<FormState>();

enum NsnFormat {
  national,
  international,
}

final _dropDownCustomBGKey = GlobalKey<DropdownSearchState<CablePlan>>();

class Betting extends HookWidget {
  const Betting({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController amountController =
        useTextEditingController(text: '');
    final TextEditingController bettingNameController =
        useTextEditingController();
    final TextEditingController bettingNumberController =
        useTextEditingController(text: '');

    final ValueNotifier<bool> enableButton = useState(false);

    void _handleFormChange() {
      enableButton.value = _airtimeFormKey.currentState!.validate() ?? true;
    }

    final FocusNode bettingNumberFocus = useFocusNode();
    final ValueNotifier<BettingProviders?> selectedBiller = useState(null);

    final ValueNotifier<List<BettingProviders>> bettingBillers = useState([]);
    final ValueNotifier<bool> dataIsLoading = useState(false);

    Future<void> onFocusChange() async {
      if (bettingNumberFocus.hasFocus == false &&
          bettingNumberController.value.text != '' &&
          selectedBiller.value != null) {
        context.loaderOverlay.show();
        try {
          final res = await verifyBettingRequest(
              context, bettingNumberController, selectedBiller);
          if (context.mounted) {
            context.loaderOverlay.hide();
            if (res.statusCode != HttpStatus.ok) {
              throw DioException(
                  requestOptions:
                      RequestOptions(data: {'message': res.data['message']}));
            } else {
              bettingNameController.text = res.data['data']['customer_name'];
            }
          }
        } on DioException catch (error) {
          if (context.mounted) {
            context.loaderOverlay.hide();
            bettingNameController.text = '';
            showToast(context,
                title: "Betting Name Lookup Failed",
                desc: error.response?.data['message']);
          }
        } on Exception catch (error) {
          if (context.mounted) {
            context.loaderOverlay.hide();
            bettingNameController.text = '';
            showToast(
              context,
              title: "Betting Name Lookup Failed",
              desc: error.toString(),
            );
          }
        }
      }
    }

    useEffect(() {
      bettingNumberFocus.addListener(onFocusChange);
      return () => bettingNumberFocus.removeListener(onFocusChange);
    }, [bettingNumberFocus]);

    useEffect(() {
      if (bettingNumberController.text.isNotEmpty) {
        onFocusChange();
      }
      return null;
    }, [selectedBiller.value, bettingNumberController.text]);

    final FlutterNativeContactPicker _contactPicker =
        FlutterNativeContactPicker();
    return CustomScaffold(
      header: const AppHeader2(
        title: 'Betting',
      ),
      headerDesc: 'Fund your betting account & loved ones',
      child: Form(
        key: _airtimeFormKey,
        onChanged: _handleFormChange,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomInput(
              labelText: 'Betting Number',
              isPhone: false,
              controller: bettingNumberController,
              hintText: "Betting Number",
              focusNode: bettingNumberFocus,
              textInputType: TextInputType.numberWithOptions(),
              validator: ValidationBuilder().required().build(),
              suffixIcon: IconButton(
                onPressed: () async {
                  final contact = await _contactPicker.selectContact();
                  if (contact != null) {
                    bettingNumberController.text = contact.phoneNumbers!.last;
                  }
                },
                icon: const Icon(
                  Ionicons.person_circle_outline,
                  size: 35,
                ),
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Select Biller",
                  style: TextStyle(
                    color: AppColor.greyLightColor,
                    height: 1.2,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                DropdownSearch<BettingProviders>(
                  items: (filter, infiniteScrollProps) => bettingBillers.value,
                  compareFn: (item, selectedItem) {
                    return item.id == selectedItem.id;
                  },
                  selectedItem: selectedBiller.value,
                  key: _dropDownCustomBGKey,
                  popupProps: PopupProps.modalBottomSheet(
                    // disabledItemFn: (item) => item.id == 'Item 3',
                    fit: FlexFit.loose,
                    showSearchBox: true,
                    title: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 28.0),
                        child: AutoSizeText(
                          "Select Biller".toUpperCase(),
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
                      return item.active == false;
                    },
                    itemBuilder: (context, item, isDisabled, isSelected) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(item.title!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    )),
                                Spacer(),
                                if (_dropDownCustomBGKey
                                        .currentState?.getSelectedItem !=
                                    null)
                                  if (_dropDownCustomBGKey
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
                    selectedBiller.value = value;
                    // amountController.text = value!.amount.toString();
                  },

                  // mode: Mode.form,
                  decoratorProps: const DropDownDecoratorProps(
                    decoration: InputDecoration(
                      hintText: "Select Biller",
                      isCollapsed: false,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 14),
                    ),
                  ),

                  clickProps: ClickProps(
                    onTapUp: (details) async {},
                  ),

                  itemAsString: (item) {
                    return "${item.title}";
                  },
                  onBeforePopupOpening: (selectedItem) async {
                    if (bettingBillers.value.isEmpty) {
                      await getbettingBillersRequest(context).then(
                        (value) {
                          bettingBillers.value = value;
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
                  // enabled: selectedPlan.value.isNotEmpty,
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),

            // if (cableNameController.text != '' ||
            //     cableNameController.text.isNotEmpty)
            CustomInput(
              labelText: 'Customer Name',
              controller: bettingNameController,
              hintText: "----",
              validator: ValidationBuilder().required().build(),
              readOnly: true,
            ),

            CustomInput(
              labelText: 'Amount',
              controller: amountController,
              hintText: "Amount",
              prefix: Text(
                currency(context),
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
              validator: ValidationBuilder().required().build(),
              textInputType: const TextInputType.numberWithOptions(),
            ),
            const SizedBox(
              height: 20,
            ),
            Button(
              text: "Subscribe Now",
              press: enableButton.value && selectedBiller.value != ''
                  ? () {
                      final Map<String, String> data = {
                        "amount": amountController.text,
                        "customer_id": bettingNumberController.text,
                        "customer_name": bettingNameController.text,
                        "trx_id": getTrx(),
                        "service_id": selectedBiller.value!.id!
                      };
                      final Map<String, String> viewData = {
                        "Biller Name": selectedBiller.value!.title!,
                        "Betting Number": bettingNumberController.text,
                        "Customer Name": bettingNameController.text,
                        "Amount":
                            "${currency(context)}${amountController.text}",
                      };
                      context.push(
                        '/confirm/transaction',
                        extra: {
                          'function': buyBettingRequest,
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

Widget NetworkCard({
  required String image,
  required String name,
  required TextEditingController amountController,
  required ValueNotifier<String> selected,
  required ValueNotifier<CablePlan?> selectedPlan,
}) {
  return TouchableOpacity(
    onTap: () {
      if (selected.value != name) {
        amountController.text = '';
        selectedPlan.value = null;
      }
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
