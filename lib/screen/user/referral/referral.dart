import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:browse_station/screen/component/custom_input.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_validator/form_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:toastification/toastification.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

import '../../../core/config/app.constant.dart';
import '../../../core/config/color.constant.dart';
import '../../../core/config/font.constant.dart';
import '../../../core/helper/helper.dart';
import '../../../core/service/http.dart';
import '../../../core/service/request/protected.dart';
import '../../../core/state/bloc/repo/app/app_bloc.dart';
import '../../../core/state/bloc/repo/app/app_state.dart';
import '../../../data/model/bank.dart';
import '../../component/app_header.dart';
import '../../component/button.dart';

final _formKey = GlobalKey<FormState>();
final _dropDownBankKycListKey = GlobalKey<DropdownSearchState<Bank>>();

class Referral extends HookWidget {
  const Referral({super.key});

  @override
  Widget build(BuildContext context) {
    final _oldPinController = useTextEditingController();
    final ValueNotifier<List<Bank>> bankList = useState([]);
    final ValueNotifier<Bank?> selectedBank = useState(null);
    final ValueNotifier<bool> dataIsLoading = useState(false);

    final _newPinController = useTextEditingController();
    final _confirmPinController = useTextEditingController();
    final amountController = useTextEditingController();
    final accountController = useTextEditingController();

    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        final balance = double.tryParse(state.user!.refBal.toString());
        final currencyFormatter =
            NumberFormat.currency(locale: "en_NG", symbol: "₦");
        String formattedCurrency = currencyFormatter.format(balance ?? 0.0);
        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppHeader(
            title: "Referral Program",
            onpress: () => context.pop(),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Refer your friends and earn",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: AppFont.segoui,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "use your referral code to invite your friends and earn once they join, fund their account",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: AppFont.segoui,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Your Referral Code",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: AppFont.segoui,
                          fontSize: 20,
                        ),
                      ),
                      Container(
                        height: 70,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            style: BorderStyle.solid,
                            // strokeAlign: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                state.user!.username!,
                                style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              width: 80,
                              child: TouchableOpacity(
                                onTap: () {
                                  Clipboard.setData(
                                    ClipboardData(
                                      text: state.user!.username!,
                                    ),
                                  ).then(
                                    (value) {
                                      if (!context.mounted) return;
                                      showToast(context,
                                          title: 'success', desc: 'Copied');
                                    },
                                  );
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.copy_sharp,
                                      color: Colors.black,
                                    ),
                                    const Text(
                                      "copy",
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "You will only receive your bonus once your friends or the person you refer have fund their wallet with more than 1,500 Naira",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: AppFont.segoui,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColor.primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Referral Balance",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Text(
                                  "${formattedCurrency}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: AppFont.segoui,
                                  ),
                                ),
                                const Spacer(),
                                TouchableOpacity(
                                  onTap: () async {
                                    // showAppDialog(child: Text('data'),);
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (context) => Form(
                                        key: _formKey,
                                        child: Padding(
                                          padding: const EdgeInsets.all(18.0),
                                          child: Column(children: [
                                            CustomInput(
                                              labelText: "Amount",
                                              controller: amountController,
                                              validator: ValidationBuilder()
                                                  .required()
                                                  .build(),
                                              textInputType: TextInputType
                                                  .numberWithOptions(),
                                            ),
                                            CustomInput(
                                              labelText: "Account Number",
                                              controller: accountController,
                                              validator: ValidationBuilder()
                                                  .required()
                                                  .build(),
                                              textInputType: TextInputType
                                                  .numberWithOptions(),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            DropdownSearch<Bank>(
                                              items: (filter,
                                                      infiniteScrollProps) =>
                                                  bankList.value,
                                              compareFn: (item, selectedItem) {
                                                return item.code ==
                                                    selectedItem.code;
                                              },

                                              selectedItem: selectedBank.value,
                                              key: _dropDownBankKycListKey,
                                              popupProps:
                                                  PopupProps.modalBottomSheet(
                                                // disabledItemFn: (item) => item.id == 'Item 3',
                                                fit: FlexFit.loose,
                                                showSearchBox: true,
                                                title: Center(
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 28.0),
                                                    child: AutoSizeText(
                                                      "Bank List".toUpperCase(),
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20),
                                                      maxLines: 1,
                                                    ),
                                                  ),
                                                ),
                                                containerBuilder:
                                                    (context, popupWidget) {
                                                  return Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 15),
                                                    child: popupWidget,
                                                  );
                                                },

                                                disabledItemFn: (item) {
                                                  return false;
                                                },
                                                itemBuilder: (context, item,
                                                    isDisabled, isSelected) {
                                                  return Container(
                                                    margin: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 10,
                                                        vertical: 10),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(item.name!,
                                                                style:
                                                                    const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                )),
                                                            Spacer(),
                                                            if (_dropDownBankKycListKey
                                                                    .currentState
                                                                    ?.getSelectedItem !=
                                                                null)
                                                              if (_dropDownBankKycListKey
                                                                      .currentState
                                                                      ?.getSelectedItem
                                                                      ?.code ==
                                                                  item.code)
                                                                const Icon(
                                                                  Ionicons
                                                                      .checkmark,
                                                                  color: AppColor
                                                                      .primaryColor,
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
                                                searchFieldProps:
                                                    const TextFieldProps(
                                                  decoration: InputDecoration(
                                                    suffixIcon:
                                                        Icon(Ionicons.search),
                                                    hintText: 'Search here',
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 15,
                                                            horizontal: 14),
                                                  ),
                                                ),
                                              ),
                                              onBeforePopupOpening:
                                                  (selectedItem) async {
                                                if (bankList.value.isEmpty) {
                                                  await getBankListRequest(
                                                          context,
                                                          path: getBankKycList)
                                                      .then(
                                                    (value) {
                                                      bankList.value = value;
                                                      _dropDownBankKycListKey
                                                          .currentState
                                                          ?.openDropDownSearch();
                                                    },
                                                  ).onError(
                                                    (error, stackTrace) {
                                                      if (context.mounted) {
                                                        context.loaderOverlay
                                                            .hide();
                                                        showToast(context,
                                                            title: "error",
                                                            desc: error
                                                                .toString());
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
                                                dropdownButtonProps:
                                                    DropdownButtonProps(
                                                  color: AppColor.primaryColor,
                                                  iconClosed: !dataIsLoading
                                                          .value
                                                      ? const Icon(
                                                          Ionicons
                                                              .chevron_down_outline,
                                                          size: 24,
                                                        )
                                                      : const SizedBox(
                                                          height: 20,
                                                          width: 20,
                                                          child:
                                                              CircularProgressIndicator()),
                                                ),
                                              ),

                                              onChanged: (value) {
                                                print(_dropDownBankKycListKey
                                                    .currentState
                                                    ?.getSelectedItem
                                                    ?.name);
                                                selectedBank.value = value;
                                              },

                                              // mode: Mode.form,
                                              decoratorProps:
                                                  const DropDownDecoratorProps(
                                                decoration: InputDecoration(
                                                  hintText: "Select Bank",
                                                  isCollapsed: false,
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 15,
                                                          horizontal: 14),
                                                ),
                                              ),

                                              itemAsString: (item) {
                                                return "${item.name}";
                                              },

                                              // enabled: selectedPlan.value.isNotEmpty,
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Button(
                                              text: "Withdraw",
                                              press: () async {
                                                FocusManager
                                                    .instance.primaryFocus
                                                    ?.unfocus();

                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  try {
                                                    context.loaderOverlay
                                                        .show();
                                                    final res = await dio.post(
                                                      postWithdrawal,
                                                      data: {
                                                        'amount':
                                                            amountController
                                                                .text,
                                                        'bank_code':
                                                            selectedBank
                                                                .value!.code!,
                                                        'account_no':
                                                            accountController
                                                                .text
                                                      },
                                                      options: Options(
                                                        headers: {
                                                          'Authorization':
                                                              context
                                                                  .read<
                                                                      AppBloc>()
                                                                  .state
                                                                  .user
                                                                  ?.apiKey
                                                        },
                                                      ),
                                                    );
                                                    if (res?.statusCode ==
                                                        HttpStatus.ok) {
                                                      if (context.mounted) {
                                                        context.loaderOverlay
                                                            .hide();
                                                        context.pop();
                                                        showToast(
                                                          context,
                                                          title: 'error',
                                                          desc: res
                                                              .data['message'],
                                                        );
                                                      }
                                                    } else {
                                                      throw Exception(
                                                          res.data['message']);
                                                    }
                                                  } on DioException catch (error) {
                                                    if (context.mounted) {
                                                      context.loaderOverlay
                                                          .hide();
                                                      context.pop();
                                                      showToast(
                                                        context,
                                                        title: 'error',
                                                        desc: error.response
                                                            ?.data['message'],
                                                        type: ToastificationType
                                                            .error,
                                                      );
                                                    }
                                                  } on Exception catch (error) {
                                                    if (context.mounted) {
                                                      context.loaderOverlay
                                                          .hide();
                                                      context.pop();
                                                      showToast(
                                                        context,
                                                        title: 'error',
                                                        desc: error.toString(),
                                                        type: ToastificationType
                                                            .error,
                                                      );
                                                    }
                                                  } finally {
                                                    amountController.text = '';
                                                  }
                                                }
                                              },
                                            )
                                          ]),
                                        ),
                                      ),
                                    );

                                    return;
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Text(
                                      "withdraw",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
