import 'package:auto_size_text/auto_size_text.dart';
import 'package:browse_station/core/service/request/protected.dart';
import 'package:browse_station/core/state/bloc/repo/app/app_bloc.dart';
import 'package:browse_station/data/model/cable_plan.dart';
import 'package:browse_station/data/model/country.dart';
import 'package:browse_station/data/model/product.dart';
import 'package:browse_station/screen/component/app_header2.dart';
import 'package:browse_station/screen/component/button.dart';
import 'package:browse_station/screen/component/custom_input.dart';
import 'package:browse_station/screen/component/custom_scaffold.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_validator/form_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

import '../../../../core/config/color.constant.dart';
import '../../../../core/helper/helper.dart';
import '../../../../data/model/user.dart';

final _portraitFormKey = GlobalKey<FormState>();

final _dropDownCountryKey = GlobalKey<DropdownSearchState<Country>>();
final _dropDownProductKey = GlobalKey<DropdownSearchState<Product>>();
final _dropDownPricesKey = GlobalKey<DropdownSearchState<num>>();

class GiftCard extends HookWidget {
  const GiftCard({super.key});

  @override
  Widget build(BuildContext context) {
    final User user = context.read<AppBloc>().state.user!;
    final TextEditingController countryController = useTextEditingController();
    final TextEditingController productIdController =
        useTextEditingController();
    final TextEditingController quantityController =
        useTextEditingController(text: '1');
    final TextEditingController amountController = useTextEditingController();

    final TextEditingController emailController =
        useTextEditingController(text: user.email);
    final TextEditingController phoneController =
        useTextEditingController(text: user.phoneNumber);

    final ValueNotifier<bool> enableButton = useState(false);
    final ValueNotifier<List<num>> giftCardPrices = useState([]);

    void _handleFormChange() {
      enableButton.value = _portraitFormKey.currentState!.validate() ?? true;
    }

    final ValueNotifier<Country?> selectedCountry = useState(null);
    final ValueNotifier<Product?> selectedProduct = useState(null);
    final ValueNotifier<num?> selectedGiftCardPrice = useState(null);

    final ValueNotifier<List<Country>> countriesList = useState([]);
    final ValueNotifier<List<Product>> productsList = useState([]);
    final ValueNotifier<bool> dataIsLoading = useState(false);

    return CustomScaffold(
      header: const AppHeader2(
        title: 'Buy Gift Card',
        showBack: true,
      ),
      // headerDesc: 'Instantly withdraw your funds',
      child: Form(
        key: _portraitFormKey,
        onChanged: _handleFormChange,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Select Country",
                  style: TextStyle(
                    color: AppColor.greyLightColor,
                    height: 1.2,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                DropdownSearch<Country>(
                  items: (filter, infiniteScrollProps) => countriesList.value,
                  compareFn: (item, selectedItem) {
                    return item.isoName == selectedItem.isoName;
                  },

                  selectedItem: selectedCountry.value,
                  key: _dropDownCountryKey,
                  popupProps: PopupProps.modalBottomSheet(
                    // disabledItemFn: (item) => item.id == 'Item 3',
                    fit: FlexFit.loose,
                    showSearchBox: true,
                    title: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 28.0),
                        child: AutoSizeText(
                          "Country List".toUpperCase(),
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
                                if (_dropDownCountryKey
                                        .currentState?.getSelectedItem !=
                                    null)
                                  if (_dropDownCountryKey.currentState
                                          ?.getSelectedItem?.isoName ==
                                      item.isoName)
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
                    if (countriesList.value.isEmpty) {
                      await getCountryRequest(context).then(
                        (value) {
                          countriesList.value = value;
                          _dropDownCountryKey.currentState
                              ?.openDropDownSearch();
                        },
                      ).onError(
                        (error, stackTrace) {
                          if (context.mounted) {
                            context.loaderOverlay.hide();
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
                    selectedCountry.value = value;
                    productsList.value = [];
                    selectedProduct.value = null;
                    selectedGiftCardPrice.value = null;
                    // amountController.text = value!.amount!;
                  },

                  // mode: Mode.form,
                  decoratorProps: const DropDownDecoratorProps(
                    decoration: InputDecoration(
                      hintText: "Select Country",
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

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Select Product",
                  style: TextStyle(
                    color: AppColor.greyLightColor,
                    height: 1.2,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                DropdownSearch<Product>(
                  items: (filter, infiniteScrollProps) => productsList.value,
                  compareFn: (item, selectedItem) {
                    return item.productId == selectedItem.productId;
                  },

                  selectedItem: selectedProduct.value,
                  key: _dropDownProductKey,
                  popupProps: PopupProps.modalBottomSheet(
                    fit: FlexFit.loose,
                    showSearchBox: true,
                    title: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 28.0),
                        child: AutoSizeText(
                          "Product List ${selectedCountry.value?.currencyName}"
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
                    itemBuilder: (context, item, isDisabled, isSelected) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  item.productName!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Spacer(),
                                if (_dropDownProductKey
                                        .currentState?.getSelectedItem !=
                                    null)
                                  if (_dropDownProductKey.currentState
                                          ?.getSelectedItem?.productId ==
                                      item.productId)
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
                    if (selectedCountry.value == null) {
                      showToast(context,
                          title: "Error", desc: "Please select country");
                      return false;
                    }
                    if (productsList.value.isEmpty) {
                      try {
                        final res = await getProductRequest(
                            context, selectedCountry.value!.isoName!);
                        if (res.isNotEmpty) {
                          print(productsList.value.length);
                          print(res.length);
                          productsList.value = res;
                        }
                      } on DioException catch (error) {
                        if (context.mounted) {
                          context.loaderOverlay.hide();
                          showToast(context,
                              title: "error",
                              desc: error.response?.data['message']());
                          return false;
                        }
                      } on Exception catch (error) {
                        if (context.mounted) {
                          context.loaderOverlay.hide();
                          showToast(context,
                              title: "error", desc: error.toString());
                          return false;
                        }
                      }
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
                    selectedProduct.value = value;
                    print(value!.fixedRecipientDenominations);
                    List<num> intList = value.fixedRecipientDenominations!
                        .whereType<num>() // Filter only integers
                        .cast<num>() // Safely cast to int
                        .toList();
                    print(intList);
                    selectedGiftCardPrice.value = null;
                    giftCardPrices.value = intList;
                  },

                  // mode: Mode.form,
                  decoratorProps: const DropDownDecoratorProps(
                    decoration: InputDecoration(
                      hintText: "Select Product",
                      isCollapsed: false,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 14),
                    ),
                  ),

                  itemAsString: (item) {
                    return "${item.productName}";
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
                  "Available Price",
                  style: TextStyle(
                    color: AppColor.greyLightColor,
                    height: 1.2,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                DropdownSearch<num>(
                  items: (filter, infiniteScrollProps) => giftCardPrices.value,
                  compareFn: (item, selectedItem) {
                    return item == selectedItem;
                  },

                  selectedItem: selectedGiftCardPrice.value,
                  key: _dropDownPricesKey,
                  popupProps: PopupProps.modalBottomSheet(
                    // disabledItemFn: (item) => item.status != "ACTIVE",
                    fit: FlexFit.loose,
                    showSearchBox: true,
                    title: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 28.0),
                        child: AutoSizeText(
                          "Gift Card Available Amount".toUpperCase(),
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
                    itemBuilder: (context, item, isDisabled, isSelected) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  item.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Spacer(),
                                if (_dropDownPricesKey
                                        .currentState?.getSelectedItem !=
                                    null)
                                  if (_dropDownPricesKey
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
                  onBeforePopupOpening: (selectedItem) async {
                    if (selectedProduct.value == null) {
                      showToast(context,
                          title: "Error", desc: "Please select gift card type");
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
                    selectedGiftCardPrice.value = value;
                    amountController.text = selectedProduct
                        .value!
                        .fixedSenderDenominations![
                            giftCardPrices.value.indexOf(value!)]
                        .toString();
                  },

                  // mode: Mode.form,
                  decoratorProps: const DropDownDecoratorProps(
                    decoration: InputDecoration(
                      hintText: "Select Product",
                      isCollapsed: false,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 14),
                    ),
                  ),

                  itemAsString: (item) {
                    return "\$${item}";
                  },

                  // enabled: selectedPlan.value.isNotEmpty,
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),

            if (selectedGiftCardPrice.value != null)
              Column(
                children: [
                  CustomInput(
                    labelText: 'Amount',
                    isPhone: false,
                    maxLength: 11,
                    readOnly: true,
                    prefix: Text('NGN'),
                    controller: amountController,
                    textInputType: TextInputType.numberWithOptions(),
                    validator: ValidationBuilder().required().build(),
                  ),
                  CustomInput(
                    labelText: 'Quantity',
                    controller: quantityController,
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
                  CustomInput(
                    labelText: 'Email',
                    controller: emailController,
                    hintText: "Enter your address",
                    validator: ValidationBuilder().email().required().build(),
                  ),
                ],
              ),

            // if (cableNameController.text != '' ||
            //     cableNameController.text.isNotEmpty)

            const SizedBox(
              height: 20,
            ),
            Button(
              text: "Order Now",
              press: enableButton.value && selectedCountry.value != ''
                  ? () {
                      final Map<String, String> data = {
                        "country": countryController.text,
                        "productid":
                            selectedProduct.value!.productId!.toString(),
                        "quantity": quantityController.text,
                        "amount": selectedGiftCardPrice.value.toString(),
                        "amountngn": amountController.text,
                        "email": emailController.text,
                        "phone": phoneController.text
                      };
                      final Map<String, String> viewData = {
                        "Country": selectedCountry.value!.name!,
                        "product":
                            selectedProduct.value!.productName!.toString(),
                        "Quantity": quantityController.text,
                        "Amount": "\$${selectedGiftCardPrice.value.toString()}",
                        "Amount in naira": "N ${amountController.text}",
                        "Email": emailController.text,
                        "Phone": phoneController.text
                      };
                      context.push(
                        '/confirm/transaction',
                        extra: {
                          'function': giftCardRequest,
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
