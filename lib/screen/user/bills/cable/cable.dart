import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:browse_station/core/helper/helper.dart';
import 'package:browse_station/core/service/request/protected.dart';
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

class Cable extends HookWidget {
  const Cable({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController amountController =
        useTextEditingController(text: '');
    final TextEditingController cableNameController =
        useTextEditingController();
    final TextEditingController cableNumberController =
        useTextEditingController(text: '');

    final ValueNotifier<bool> enableButton = useState(false);

    void _handleFormChange() {
      enableButton.value = _airtimeFormKey.currentState!.validate() ?? true;
    }

    final FocusNode cableNumberFocus = useFocusNode();
    final ValueNotifier<String> selectedBiller = useState('');
    final ValueNotifier<CablePlan?> selectedPlan = useState(null);
    final ValueNotifier<List<CablePlan>> cablePlans = useState([]);
    final ValueNotifier<bool> dataIsLoading = useState(false);

    Future<void> onFocusChange() async {
      if (cableNumberFocus.hasFocus == false &&
          cableNumberController.value.text != '' &&
          selectedPlan.value != null &&
          selectedBiller.value != '') {
        context.loaderOverlay.show();
        try {
          final res = await verifyCableRequest(
              context, cableNumberController, selectedBiller, selectedPlan);
          if (context.mounted) {
            context.loaderOverlay.hide();
            if (res.statusCode != HttpStatus.ok) {
              throw DioException(
                  requestOptions:
                      RequestOptions(data: {'message': res.data['message']}));
            } else {
              cableNameController.text = res.data['data']['customer_name'];
            }
          }
        } on DioException catch (error) {
          if (context.mounted) {
            context.loaderOverlay.hide();
            cableNameController.text = '';
            showToast(context,
                title: "Cable Lookup Failed",
                desc: error.response?.data['message']);
          }
        } on Exception catch (error) {
          if (context.mounted) {
            context.loaderOverlay.hide();
            cableNameController.text = '';
            showToast(
              context,
              title: "Cable Lookup Failed",
              desc: error.toString(),
            );
          }
        }
      }
    }

    useEffect(() {
      cableNumberFocus.addListener(onFocusChange);
      return () => cableNumberFocus.removeListener(onFocusChange);
    }, [cableNumberFocus]);

    useEffect(() {
      if (cableNumberController.text.isNotEmpty) {
        onFocusChange();
      }
      return null;
    }, [selectedBiller.value, selectedPlan.value]);
    useEffect(() {
      if (selectedBiller.value != '') {
        getCablePlanRequest(context, selectedBiller.value).then(
          (value) {
            cablePlans.value = value;
          },
        ).onError(
          (error, stackTrace) {
            if (context.mounted) {
              showToast(context, title: "error", desc: error.toString());
            }
          },
        );
      }

      return null;
    }, [selectedBiller.value]);

    final FlutterNativeContactPicker _contactPicker =
        FlutterNativeContactPicker();
    return CustomScaffold(
      header: const AppHeader2(
        title: 'Buy Cable',
      ),
      headerDesc: 'Subscribe cable for yourself and loved ones',
      child: Form(
        key: _airtimeFormKey,
        onChanged: _handleFormChange,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                NetworkCard(
                  image: "assets/images/cable/dstv.png",
                  name: 'dstv',
                  selected: selectedBiller,
                  amountController: amountController,
                  selectedPlan: selectedPlan,
                ),
                NetworkCard(
                  image: "assets/images/cable/gotv.png",
                  name: 'gotv',
                  selected: selectedBiller,
                  amountController: amountController,
                  selectedPlan: selectedPlan,
                ),
                NetworkCard(
                  image: "assets/images/cable/startimes.png",
                  name: 'startimes',
                  selected: selectedBiller,
                  amountController: amountController,
                  selectedPlan: selectedPlan,
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            const Text(
              "Select Plan",
              style: TextStyle(
                color: AppColor.greyLightColor,
                height: 1.2,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            DropdownSearch<CablePlan>(
              items: (filter, infiniteScrollProps) => cablePlans.value,
              compareFn: (item, selectedItem) {
                print(item.name);
                print(selectedItem.name);
                print(item.id == selectedItem.id);
                return item.id == selectedItem.id;
              },

              selectedItem: selectedPlan.value,
              key: _dropDownCustomBGKey,
              popupProps: PopupProps.modalBottomSheet(
                // disabledItemFn: (item) => item.id == 'Item 3',
                fit: FlexFit.loose,
                showSearchBox: true,
                title: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 28.0),
                    child: AutoSizeText(
                      "Cable plan list for ${selectedBiller.value}"
                          .toUpperCase(),
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
                print(_dropDownCustomBGKey.currentState?.getSelectedItem?.name);
                selectedPlan.value = value;
                amountController.text = value!.amount.toString();
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

              itemAsString: (item) {
                return "${item.name}";
              },

              // enabled: selectedPlan.value.isNotEmpty,
            ),
            const SizedBox(
              height: 20,
            ),
            CustomInput(
              labelText: 'Cable Number',
              isPhone: false,
              controller: cableNumberController,
              hintText: "Cable Number",
              focusNode: cableNumberFocus,
              textInputType: TextInputType.numberWithOptions(),
              validator: ValidationBuilder().required().minLength(10).build(),
              suffixIcon: IconButton(
                onPressed: () async {
                  final contact = await _contactPicker.selectContact();
                  if (contact != null) {
                    cableNumberController.text = contact.phoneNumbers!.last;
                  }
                },
                icon: const Icon(
                  Ionicons.person_circle_outline,
                  size: 35,
                ),
              ),
            ),
            // if (cableNameController.text != '' ||
            //     cableNameController.text.isNotEmpty)
            CustomInput(
              labelText: 'Cable Name',
              controller: cableNameController,
              hintText: "----",
              validator: ValidationBuilder().required().build(),
              readOnly: true,
            ),

            CustomInput(
              labelText: 'Amount',
              controller: amountController,
              hintText: "Amount",
              readOnly: true,
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
              press: enableButton.value && selectedPlan.value != ''
                  ? () {
                      final Map<String, String> data = {
                        "smartcard_number": cableNumberController.text,
                        "trx_id": getTrx(),
                        "service_id":
                            getCableIdByName(network: selectedBiller.value)
                                .toString(),
                        "plan_id": selectedPlan.value!.id!,
                        "customer_name": cableNameController.text
                      };
                      final Map<String, String> viewData = {
                        "Cable Type": selectedBiller.value,
                        "SmartCard Number": cableNumberController.text,
                        "Plan": selectedPlan.value!.name!,
                        "Customer Name": cableNameController.text,
                        "Amount":
                            "${currency(context)}${amountController.text}",
                      };
                      context.push(
                        '/confirm/transaction',
                        extra: {
                          'function': buyCableRequest,
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
