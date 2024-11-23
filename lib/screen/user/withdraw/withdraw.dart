import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:browse_station/core/helper/helper.dart';
import 'package:browse_station/core/service/request/protected.dart';
import 'package:browse_station/data/model/bank.dart';
import 'package:browse_station/data/model/cable_plan.dart';
import 'package:browse_station/screen/component/app_header2.dart';
import 'package:browse_station/screen/component/custom_input.dart';
import 'package:browse_station/screen/component/custom_scaffold.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_validator/form_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

import '../../../../core/config/color.constant.dart';
import '../../component/button.dart';

final _airtimeFormKey = GlobalKey<FormState>();

final _dropDownBankListKey = GlobalKey<DropdownSearchState<Bank>>();

class Withdraw extends HookWidget {
  const Withdraw({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController amountController = useTextEditingController();
    final TextEditingController accountNameController =
        useTextEditingController();
    final TextEditingController accountNumberController =
        useTextEditingController(text: '');

    final ValueNotifier<bool> enableButton = useState(false);

    void _handleFormChange() {
      enableButton.value = _airtimeFormKey.currentState!.validate() ?? true;
    }

    final FocusNode accountNumberFocus = useFocusNode();
    // final ValueNotifier<String> selectedBiller = useState('');
    final ValueNotifier<Bank?> selectedBank = useState(null);
    final ValueNotifier<List<Bank>> bankList = useState([]);
    final ValueNotifier<bool> dataIsLoading = useState(false);

    Future<void> onFocusChange() async {
      if (accountNumberFocus.hasFocus == false &&
          accountNumberController.value.text != '' &&
          selectedBank.value != null) {
        context.loaderOverlay.show();
        try {
          final res = await verifyAccountNumberRequest(
              context, accountNumberController, selectedBank);
          if (context.mounted) {
            context.loaderOverlay.hide();
            if (res.statusCode != HttpStatus.ok) {
              throw DioException(
                  requestOptions:
                      RequestOptions(data: {'message': res.data['message']}));
            } else {
              accountNameController.text = res.data['data']['account_name'];
            }
          }
        } on DioException catch (error) {
          if (context.mounted) {
            context.loaderOverlay.hide();
            accountNameController.text = '';
            showToast(context,
                title: "Bank Lookup Failed",
                desc: error.response?.data['message']);
          }
        } on Exception catch (error) {
          if (context.mounted) {
            context.loaderOverlay.hide();
            accountNameController.text = '';
            showToast(
              context,
              title: "Bank Lookup Failed",
              desc: error.toString(),
            );
          }
        }
      }
    }

    useEffect(() {
      accountNumberFocus.addListener(onFocusChange);
      return () => accountNumberFocus.removeListener(onFocusChange);
    }, [accountNumberFocus]);

    useEffect(() {
      if (accountNumberController.text.isNotEmpty) {
        onFocusChange();
      }
      return null;
    }, [selectedBank.value]);

    return CustomScaffold(
      header: const AppHeader2(
        title: 'Withdraw',
      ),
      headerDesc: 'Instantly withdraw your funds',
      child: Form(
        key: _airtimeFormKey,
        onChanged: _handleFormChange,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select Bank",
              style: TextStyle(
                color: AppColor.greyLightColor,
                height: 1.2,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            DropdownSearch<Bank>(
              items: (filter, infiniteScrollProps) => bankList.value,
              compareFn: (item, selectedItem) {
                return item.code == selectedItem.code;
              },

              selectedItem: selectedBank.value,
              key: _dropDownBankListKey,
              popupProps: PopupProps.modalBottomSheet(
                // disabledItemFn: (item) => item.id == 'Item 3',
                fit: FlexFit.loose,
                showSearchBox: true,
                title: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 28.0),
                    child: AutoSizeText(
                      "Bank List".toUpperCase(),
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
                            if (_dropDownBankListKey
                                    .currentState?.getSelectedItem !=
                                null)
                              if (_dropDownBankListKey
                                      .currentState?.getSelectedItem?.code ==
                                  item.code)
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
                if (bankList.value.isEmpty) {
                  await getBankListRequest(context).then(
                    (value) {
                      bankList.value = value;
                      _dropDownBankListKey.currentState?.openDropDownSearch();
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
                print(_dropDownBankListKey.currentState?.getSelectedItem?.name);
                selectedBank.value = value;
              },

              // mode: Mode.form,
              decoratorProps: const DropDownDecoratorProps(
                decoration: InputDecoration(
                  hintText: "Select Bank",
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
              labelText: 'Account Number',
              isPhone: false,
              maxLength: 10,
              controller: accountNumberController,
              hintText: "Account Number",
              focusNode: accountNumberFocus,
              textInputType: TextInputType.numberWithOptions(),
              validator: ValidationBuilder()
                  .required()
                  .minLength(10)
                  .maxLength(10)
                  .build(),
            ),
            // if (cableNameController.text != '' ||
            //     cableNameController.text.isNotEmpty)
            CustomInput(
              labelText: 'Account Name',
              controller: accountNameController,
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
              text: "Withdraw Now",
              press: enableButton.value && selectedBank.value != ''
                  ? () {
                      final Map<String, String> data = {
                        "amount": amountController.text,
                        "bank_code": selectedBank.value!.code!,
                        "account_no": accountNumberController.text
                      };
                      final Map<String, String> viewData = {
                        "Account Number": accountNumberController.text,
                        "Account Name": accountNameController.text,
                        "Bank Name": selectedBank.value!.name!,
                        "Amount":
                            "${currency(context)}${amountController.text}",
                      };
                      context.push(
                        '/confirm/transaction',
                        extra: {
                          'function': withdrawRequest,
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
