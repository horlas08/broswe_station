import 'package:auto_size_text/auto_size_text.dart';
import 'package:browse_station/core/helper/helper.dart';
import 'package:browse_station/core/service/request/protected.dart';
import 'package:browse_station/data/model/cable_plan.dart';
import 'package:browse_station/data/model/epin_providers.dart';
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

final _educationFormKey = GlobalKey<FormState>();

final _dropDownEdusKey = GlobalKey<DropdownSearchState<PortraitcutsModel>>();

class Education extends HookWidget {
  const Education({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController amountController = useTextEditingController();
    final TextEditingController quantityController = useTextEditingController();

    final ValueNotifier<bool> enableButton = useState(false);

    void _handleFormChange() {
      enableButton.value = _educationFormKey.currentState!.validate() ?? true;
    }

    final ValueNotifier<EpinProviders?> selectedEpin = useState(null);
    final ValueNotifier<List<EpinProviders>> epinList = useState([]);
    final ValueNotifier<bool> dataIsLoading = useState(false);

    return CustomScaffold(
      header: const AppHeader2(title: 'Education'),
      headerDesc: 'Purchase Education Pins (Weac, Neco etc)',
      child: Form(
        key: _educationFormKey,
        onChanged: _handleFormChange,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select Examination",
              style: TextStyle(
                color: AppColor.greyLightColor,
                height: 1.2,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            DropdownSearch<EpinProviders>(
              items: (filter, infiniteScrollProps) => epinList.value,
              compareFn: (item, selectedItem) {
                return item.id == selectedItem.id;
              },

              selectedItem: selectedEpin.value,
              key: _dropDownEdusKey,
              popupProps: PopupProps.modalBottomSheet(
                // disabledItemFn: (item) => item.id == 'Item 3',
                fit: FlexFit.loose,
                showSearchBox: false,
                title: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 28.0),
                    child: AutoSizeText(
                      "Examination Service List".toUpperCase(),
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
                  return item.status != "1";
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
                            if (_dropDownEdusKey
                                    .currentState?.getSelectedItem !=
                                null)
                              if (_dropDownEdusKey
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
                if (epinList.value.isEmpty) {
                  await getEpinRequest(context).then(
                    (value) {
                      epinList.value = value;
                      _dropDownEdusKey.currentState?.openDropDownSearch();
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
                selectedEpin.value = value;
                amountController.text = value!.amount!;
              },

              // mode: Mode.form,
              decoratorProps: const DropDownDecoratorProps(
                decoration: InputDecoration(
                  hintText: "Select Examination",
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
            if (selectedEpin.value != null)
              CustomInput(
                labelText: 'Amount Per One',
                isPhone: false,
                maxLength: 11,
                readOnly: true,
                controller: amountController,
                textInputType: TextInputType.numberWithOptions(),
                validator: ValidationBuilder().required().build(),
              ),
            CustomInput(
              labelText: 'Quantity',
              isPhone: false,
              controller: quantityController,
              textInputType: TextInputType.numberWithOptions(),
              validator: ValidationBuilder().required().build(),
            ),
            const SizedBox(
              height: 20,
            ),
            Button(
              text: "Buy Now",
              press: enableButton.value && selectedEpin.value != ''
                  ? () {
                      final Map<String, String> data = {
                        "epin": selectedEpin.value!.id!,
                        "quantity": quantityController.text
                      };
                      final Map<String, String> viewData = {
                        "Exam Type": selectedEpin.value!.name!,
                        "quantity": quantityController.text,
                        "Total Amount": (int.parse(quantityController.text) *
                                int.parse(amountController.text))
                            .toString()
                      };
                      context.push(
                        '/confirm/transaction',
                        extra: {
                          'function': epinRequest,
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
