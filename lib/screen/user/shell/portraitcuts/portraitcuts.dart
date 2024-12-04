import 'package:auto_size_text/auto_size_text.dart';
import 'package:browse_station/core/helper/helper.dart';
import 'package:browse_station/core/service/request/protected.dart';
import 'package:browse_station/data/model/cable_plan.dart';
import 'package:browse_station/data/model/portraitcuts.dart';
import 'package:browse_station/screen/component/app_header2.dart';
import 'package:browse_station/screen/component/button.dart';
import 'package:browse_station/screen/component/custom_input.dart';
import 'package:browse_station/screen/component/custom_scaffold.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_validator/form_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

import '../../../../core/config/color.constant.dart';
import '../../../component/transaction_item.dart';

final _portraitFormKey = GlobalKey<FormState>();

final _dropDownPortraitcutsKey =
    GlobalKey<DropdownSearchState<PortraitcutsModel>>();

class Portraitcuts extends HookWidget {
  const Portraitcuts({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController amountController = useTextEditingController();
    final TextEditingController phoneController = useTextEditingController();
    final TextEditingController addressController = useTextEditingController();
    final TextEditingController dateTimeController = useTextEditingController();
    final TextEditingController instagramUsernameController =
        useTextEditingController(text: '');

    final ValueNotifier<bool> enableButton = useState(false);

    void _handleFormChange() {
      enableButton.value = _portraitFormKey.currentState!.validate() ?? true;
    }

    final ValueNotifier<PortraitcutsModel?> selectedPortraitcuts =
        useState(null);
    final ValueNotifier<List<PortraitcutsModel>> portraitcutsList =
        useState([]);
    final ValueNotifier<bool> dataIsLoading = useState(false);

    return CustomScaffold(
      header: const AppHeader2(
        title: 'Portraitcuts',
        showBack: false,
      ),
      headerDesc: 'Book Haircuts Appointment within Lagos',
      child: Form(
        key: _portraitFormKey,
        onChanged: _handleFormChange,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select Service",
              style: TextStyle(
                color: AppColor.greyLightColor,
                height: 1.2,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            DropdownSearch<PortraitcutsModel>(
              items: (filter, infiniteScrollProps) => portraitcutsList.value,
              compareFn: (item, selectedItem) {
                return item.id == selectedItem.id;
              },

              selectedItem: selectedPortraitcuts.value,
              key: _dropDownPortraitcutsKey,
              popupProps: PopupProps.modalBottomSheet(
                // disabledItemFn: (item) => item.id == 'Item 3',
                fit: FlexFit.loose,
                showSearchBox: true,
                title: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 28.0),
                    child: AutoSizeText(
                      "Portraitcuts Service List".toUpperCase(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                      maxLines: 1,
                    ),
                  ),
                ),
                containerBuilder: (context, popupWidget) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        popupWidget,
                        SizedBox(
                          height: 34,
                        )
                      ],
                    ),
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
                            if (_dropDownPortraitcutsKey
                                    .currentState?.getSelectedItem !=
                                null)
                              if (_dropDownPortraitcutsKey
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
              onBeforePopupOpening: (selectedItem) async {
                if (portraitcutsList.value.isEmpty) {
                  await getPortraitcutsRequest(context).then(
                    (value) {
                      portraitcutsList.value = value;
                      _dropDownPortraitcutsKey.currentState
                          ?.openDropDownSearch();
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
                return null;
              },
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
                selectedPortraitcuts.value = value;
                amountController.text = value!.amount!;
              },

              // mode: Mode.form,
              decoratorProps: const DropDownDecoratorProps(
                decoration: InputDecoration(
                  hintText: "Select Portraitcuts",
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
            if (selectedPortraitcuts.value != null)
              CustomInput(
                labelText: 'Amount',
                isPhone: false,
                maxLength: 11,
                readOnly: true,
                controller: amountController,
                textInputType: TextInputType.numberWithOptions(),
                validator: ValidationBuilder().required().build(),
              ),
            CustomInput(
              labelText: 'Phone Number',
              isPhone: false,
              maxLength: 11,
              controller: phoneController,
              hintText: "Phone Number",
              textInputType: const TextInputType.numberWithOptions(),
              validator: ValidationBuilder()
                  .required()
                  .minLength(11)
                  .maxLength(11)
                  .build(),
            ),
            // if (cableNameController.text != '' ||
            //     cableNameController.text.isNotEmpty)
            CustomInput(
              labelText: 'Address',
              controller: addressController,
              hintText: "Enter your address",
              maxLine: 3,
              validator: ValidationBuilder().required().build(),
            ),

            CustomInput(
              labelText: 'Instagram handler',
              controller: instagramUsernameController,
              hintText: "e.g @qozeem",
              validator: ValidationBuilder().required().build(),
            ),
            CustomInput(
              labelText: 'Date',
              controller: dateTimeController,
              readOnly: true,
              suffixIcon: IconButton(
                onPressed: () async {
                  final date = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(
                      Duration(hours: 1000),
                    ),
                  );
                  if (context.mounted) {
                    if (date != null) {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (time != null) {
                        DateTime selectedDateTime = DateTime(
                          date.year,
                          date.month,
                          date.day,
                          time.hour,
                          time.minute,
                        );
                        dateTimeController.text =
                            selectedDateTime.toLocal().toString();
                      }
                    }
                  }
                },
                icon: const Icon(
                  Ionicons.calendar,
                  color: AppColor.primaryColor,
                ),
              ),
              validator: ValidationBuilder().required().build(),
            ),

            const SizedBox(
              height: 20,
            ),
            Button(
              text: "Book Now",
              press: enableButton.value && selectedPortraitcuts.value != ''
                  ? () {
                      final Map<String, String> data = {
                        "service_id": selectedPortraitcuts.value!.id!,
                        "phonenumber": phoneController.text,
                        "address": addressController.text,
                        "datetime": toDateTimeLocal(
                            DateTime.parse(dateTimeController.text)),
                        "instagram": instagramUsernameController.text
                      };
                      final Map<String, String> viewData = {
                        "Service Name": selectedPortraitcuts.value!.name!,
                        "Phone Number": phoneController.text,
                        "Amount":
                            "${currency(context)}${amountController.text}",
                        "Instagram": instagramUsernameController.text,
                        "Address": addressController.text,
                        "Date": getDateAndYearWordFromString(
                            dateTimeController.text),
                        "Time": getTimeFromDateAndTime(dateTimeController.text),
                      };
                      context.push(
                        '/confirm/transaction',
                        extra: {
                          'function': portraitcutRequest,
                          'data': data,
                          'viewData': viewData,
                        },
                      );
                    }
                  : null,
            ),
            const SizedBox(
              height: 90,
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
