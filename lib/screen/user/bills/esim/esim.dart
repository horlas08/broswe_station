import 'package:auto_size_text/auto_size_text.dart';
import 'package:browse_station/core/helper/helper.dart';
import 'package:browse_station/core/service/request/protected.dart';
import 'package:browse_station/data/model/cable_plan.dart';
import 'package:browse_station/screen/component/app_header2.dart';
import 'package:browse_station/screen/component/button.dart';
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
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/config/color.constant.dart';
import '../../../../data/model/esim.dart';

final _esimFormKey = GlobalKey<FormState>();

final _dropDownEsimKey = GlobalKey<DropdownSearchState<EsimModel>>();
final _dropDownEsimTypeKey = GlobalKey<DropdownSearchState<EsimModel>>();

class Esim extends HookWidget {
  const Esim({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController amountController = useTextEditingController();
    final TextEditingController amountNgnController =
        useTextEditingController();
    final TextEditingController phoneController = useTextEditingController();
    final TextEditingController emailController = useTextEditingController();
    final TextEditingController dateTimeController = useTextEditingController();
    final TextEditingController fullNameController =
        useTextEditingController(text: '');

    final ValueNotifier<bool> enableButton = useState(false);

    void _handleFormChange() {
      enableButton.value = _esimFormKey.currentState!.validate() ?? true;
    }

    final ValueNotifier<EsimModel?> selectedEsim = useState(null);
    final ValueNotifier<EsimType?> selectedEsimType = useState(null);
    final ValueNotifier<List<EsimModel>> esimPlanList = useState([]);
    final ValueNotifier<bool> dataIsLoading = useState(false);

    return CustomScaffold(
      header: const AppHeader2(
        title: 'Esim',
        showBack: false,
      ),
      headerDesc: 'Purchase your T-mobile E-sims',
      child: Form(
        key: _esimFormKey,
        onChanged: _handleFormChange,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Select Service Type",
                  style: TextStyle(
                    color: AppColor.greyLightColor,
                    height: 1.2,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                DropdownSearch<EsimType>(
                  items: (filter, infiniteScrollProps) => EsimType.values,
                  compareFn: (item, selectedItem) {
                    return item.name == selectedItem.name;
                  },

                  selectedItem: selectedEsimType.value,
                  key: _dropDownEsimTypeKey,
                  popupProps: PopupProps.modalBottomSheet(
                    // disabledItemFn: (item) => item.id == 'Item 3',
                    fit: FlexFit.loose,
                    showSearchBox: true,
                    title: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 28.0),
                        child: AutoSizeText(
                          "Esim Types".toUpperCase(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                          maxLines: 1,
                        ),
                      ),
                    ),
                    containerBuilder: (context, popupWidget) {
                      return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: popupWidget);
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
                                Text(item.name.capitalize(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    )),
                                Spacer(),
                                if (_dropDownEsimTypeKey
                                        .currentState?.getSelectedItem !=
                                    null)
                                  if (_dropDownEsimTypeKey.currentState
                                          ?.getSelectedItem?.name ==
                                      item.name)
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
                    selectedEsimType.value = value;
                    esimPlanList.value = [];
                    selectedEsim.value = null;
                  },

                  // mode: Mode.form,
                  decoratorProps: const DropDownDecoratorProps(
                    decoration: InputDecoration(
                      hintText: "Select Esim Type",
                      isCollapsed: false,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 14),
                    ),
                  ),

                  itemAsString: (item) {
                    return item.name.capitalize();
                  },

                  // enabled: selectedPlan.value.isNotEmpty,
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
            Column(
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
                DropdownSearch<EsimModel>(
                  items: (filter, infiniteScrollProps) => esimPlanList.value,
                  compareFn: (item, selectedItem) {
                    return item.id == selectedItem.id;
                  },

                  selectedItem: selectedEsim.value,
                  key: _dropDownEsimKey,
                  popupProps: PopupProps.modalBottomSheet(
                    // disabledItemFn: (item) => item.id == 'Item 3',
                    fit: FlexFit.loose,
                    showSearchBox: true,
                    title: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 28.0),
                        child: AutoSizeText(
                          "Esim Service List".toUpperCase(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                          maxLines: 1,
                        ),
                      ),
                    ),
                    containerBuilder: (context, popupWidget) {
                      return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: popupWidget);
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
                                if (_dropDownEsimKey
                                        .currentState?.getSelectedItem !=
                                    null)
                                  if (_dropDownEsimKey
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
                    if (selectedEsimType.value == null) {
                      showToast(context,
                          title: "error", desc: "Please Select Type");
                      return false;
                    }
                    if (esimPlanList.value.isEmpty) {
                      try {
                        context.loaderOverlay.show();
                        final res = await getEsimRequest(
                          context,
                          selectedEsimType.value!.name,
                        );
                        if (context.mounted) {
                          if (res.isNotEmpty) {
                            context.loaderOverlay.hide();
                            esimPlanList.value = res;
                            _dropDownEsimKey.currentState?.openDropDownSearch();
                          }
                        }
                      } on DioException catch (error) {
                        if (context.mounted) {
                          context.loaderOverlay.hide();
                          showToast(
                            context,
                            title: "error",
                            desc: error.response?.data['message'],
                          );
                        }
                      } on Exception catch (error) {
                        if (context.mounted) {
                          context.loaderOverlay.hide();
                          showToast(context,
                              title: "error", desc: error.toString());
                        }
                      } finally {
                        if (context.mounted) context.loaderOverlay.hide();
                      }

                      //     .then(
                      //   (value) {

                      //   },
                      // ).onError(
                      //   (error, stackTrace) {
                      //     if (context.mounted) {
                      //       showToast(context,
                      //           title: "error", desc: error.toString());
                      //     }
                      //   },
                      // );

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
                              child: CircularProgressIndicator(),
                            ),
                    ),
                  ),

                  onChanged: (value) {
                    selectedEsim.value = value;
                    amountController.text = value!.amount_usd!;
                    amountNgnController.text = value.amount_ngn!;
                  },

                  // mode: Mode.form,
                  decoratorProps: const DropDownDecoratorProps(
                    decoration: InputDecoration(
                      hintText: "Select Esim",
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
              ],
            ),

            if (selectedEsim.value != null)
              Column(
                children: [
                  CustomInput(
                    labelText: 'Amount',
                    isPhone: false,
                    maxLength: 11,
                    readOnly: true,
                    controller: amountController,
                    prefix: const Text(
                      "\$",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    textInputType: TextInputType.numberWithOptions(),
                    validator: ValidationBuilder().required().build(),
                  ),
                  CustomInput(
                    labelText: 'Amount In NGN',
                    isPhone: false,
                    maxLength: 11,
                    readOnly: true,
                    controller: amountNgnController,
                    prefix: const Text(
                      "NGN",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    textInputType: TextInputType.numberWithOptions(),
                    validator: ValidationBuilder().required().build(),
                  ),
                ],
              ),

            // if (cableNameController.text != '' ||
            //     cableNameController.text.isNotEmpty)
            CustomInput(
              labelText: 'Email',
              controller: emailController,
              hintText: "Enter your email",
              validator: ValidationBuilder().email().required().build(),
            ),

            CustomInput(
              labelText: 'Full name',
              controller: fullNameController,
              hintText: "e.g john peter",
              validator: ValidationBuilder().required().build(),
            ),

            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () async {
                    try {
                      final Uri _url = Uri.parse(
                          'https://browsestations.com/user/esim-refill');
                      await launchUrl(_url);
                    } catch (error) {
                      if (context.mounted) {
                        showToast(context,
                            title: "error", desc: error.toString());
                      }
                    }
                  },
                  child: const Text("Refill T-Mobile esim"),
                ),
                Spacer(),
                TextButton(
                  onPressed: () {
                    context.go('/');
                  },
                  child: Text("Go Home"),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Button(
              text: "Buy Now",
              press: enableButton.value && selectedEsim.value != ''
                  ? () {
                      final Map<String, String> data = {
                        "plan_type": selectedEsimType.value!.name.toLowerCase(),
                        "plan_id": selectedEsim.value!.id!,
                        "email": emailController.text,
                        "fullname": fullNameController.text
                      };
                      final Map<String, String> viewData = {
                        "Plan Type": selectedEsimType.value!.name,
                        "Plan": selectedEsim.value!.name!,
                        "Name": fullNameController.text,
                        "Amount":
                            "${currency(context)}${amountController.text}",
                        "Amount In NGN":
                            "${currency(context)}${amountNgnController.text}",
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
