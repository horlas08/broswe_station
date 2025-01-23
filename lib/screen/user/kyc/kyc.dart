import 'package:browse_station/core/config/color.constant.dart';
import 'package:browse_station/core/helper/helper.dart';
import 'package:browse_station/screen/component/app_header2.dart';
import 'package:browse_station/screen/component/custom_input.dart';
import 'package:browse_station/screen/component/custom_scaffold.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_validator/form_validator.dart';
import 'package:remixicon/remixicon.dart';

import '../../../core/service/request/protected.dart';
import '../../../core/state/bloc/repo/app/app_bloc.dart';
import '../../../core/state/bloc/repo/app/app_state.dart';
import '../../../data/model/bank.dart';
import '../../component/button.dart';
import '../../component/transaction_item.dart';

final _dropDownBankKycListKey = GlobalKey<DropdownSearchState<Bank>>();

class Kyc extends HookWidget {
  const Kyc({super.key});

  @override
  Widget build(BuildContext context) {
    final kycKey = GlobalKey<FormState>();
    final bvnController = useTextEditingController();
    final dobController = useTextEditingController();
    final ValueNotifier<String?> dob = useState(null);
    final ValueNotifier<Bank?> selectedBank = useState(null);
    final TextEditingController accountNameController =
        useTextEditingController();
    final ValueNotifier<bool> dataIsLoading = useState(false);

    final TextEditingController ninController =
        useTextEditingController(text: '');
    final FocusNode accountNumberFocus = useFocusNode();
    final ValueNotifier<List<Bank>> bankList = useState([]);

    return CustomScaffold(
      header: const AppHeader2(title: "Upgrade Kyc"),
      child: Form(
        key: kycKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "In compliance with CBN regulations, KYC is required to generate an account and enable withdrawals from the app.",
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.only(top: 40),
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColor.secondaryColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.secondaryColor.withOpacity(0.5),
                      offset: Offset(10, 10),
                    ),
                  ],
                ),
                child: Icon(
                  Remix.bank_fill,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            BlocBuilder<AppBloc, AppState>(
              builder: (context, state) {
                print(state.accounts?.length);
                return Column(
                  children: [
                    if (!(state.user!.kyc > 1))
                      Column(
                        children: [
                          // const Text(
                          //   "Select Bank",
                          //   style: TextStyle(
                          //     color: AppColor.greyLightColor,
                          //     height: 1.2,
                          //   ),
                          // ),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          // DropdownSearch<Bank>(
                          //   items: (filter, infiniteScrollProps) =>
                          //       bankList.value,
                          //   compareFn: (item, selectedItem) {
                          //     return item.code == selectedItem.code;
                          //   },
                          //
                          //   selectedItem: selectedBank.value,
                          //   key: _dropDownBankKycListKey,
                          //   popupProps: PopupProps.modalBottomSheet(
                          //     // disabledItemFn: (item) => item.id == 'Item 3',
                          //     fit: FlexFit.loose,
                          //     showSearchBox: true,
                          //     title: Center(
                          //       child: Padding(
                          //         padding: const EdgeInsets.symmetric(
                          //             vertical: 28.0),
                          //         child: AutoSizeText(
                          //           "Bank List".toUpperCase(),
                          //           style: const TextStyle(
                          //               fontWeight: FontWeight.bold,
                          //               fontSize: 20),
                          //           maxLines: 1,
                          //         ),
                          //       ),
                          //     ),
                          //     containerBuilder: (context, popupWidget) {
                          //       return Container(
                          //         padding: const EdgeInsets.symmetric(
                          //             horizontal: 15),
                          //         child: popupWidget,
                          //       );
                          //     },
                          //
                          //     disabledItemFn: (item) {
                          //       return false;
                          //     },
                          //     itemBuilder:
                          //         (context, item, isDisabled, isSelected) {
                          //       return Container(
                          //         margin: const EdgeInsets.symmetric(
                          //             horizontal: 10, vertical: 10),
                          //         child: Column(
                          //           children: [
                          //             Row(
                          //               children: [
                          //                 Text(item.name!,
                          //                     style: const TextStyle(
                          //                       fontWeight: FontWeight.bold,
                          //                     )),
                          //                 Spacer(),
                          //                 if (_dropDownBankKycListKey
                          //                         .currentState
                          //                         ?.getSelectedItem !=
                          //                     null)
                          //                   if (_dropDownBankKycListKey
                          //                           .currentState
                          //                           ?.getSelectedItem
                          //                           ?.code ==
                          //                       item.code)
                          //                     const Icon(
                          //                       Ionicons.checkmark,
                          //                       color: AppColor.primaryColor,
                          //                     )
                          //               ],
                          //             ),
                          //             const SizedBox(
                          //               height: 5,
                          //             ),
                          //             const Divider()
                          //           ],
                          //         ),
                          //       );
                          //     },
                          //     searchFieldProps: const TextFieldProps(
                          //       decoration: InputDecoration(
                          //         suffixIcon: Icon(Ionicons.search),
                          //         hintText: 'Search here',
                          //         contentPadding: EdgeInsets.symmetric(
                          //             vertical: 15, horizontal: 14),
                          //       ),
                          //     ),
                          //   ),
                          //   onBeforePopupOpening: (selectedItem) async {
                          //     if (bankList.value.isEmpty) {
                          //       await getBankListRequest(context,
                          //               path: getBankKycList)
                          //           .then(
                          //         (value) {
                          //           bankList.value = value;
                          //           _dropDownBankKycListKey.currentState
                          //               ?.openDropDownSearch();
                          //         },
                          //       ).onError(
                          //         (error, stackTrace) {
                          //           if (context.mounted) {
                          //             context.loaderOverlay.hide();
                          //             showToast(context,
                          //                 title: "error",
                          //                 desc: error.toString());
                          //           }
                          //         },
                          //       );
                          //
                          //       return false;
                          //     }
                          //     return null;
                          //   },
                          //   validator: (value) {
                          //     if (value == null) {
                          //       return 'required';
                          //     }
                          //     return null;
                          //   },
                          //   suffixProps: DropdownSuffixProps(
                          //     dropdownButtonProps: DropdownButtonProps(
                          //       color: AppColor.primaryColor,
                          //       iconClosed: !dataIsLoading.value
                          //           ? const Icon(
                          //               Ionicons.chevron_down_outline,
                          //               size: 24,
                          //             )
                          //           : const SizedBox(
                          //               height: 20,
                          //               width: 20,
                          //               child: CircularProgressIndicator()),
                          //     ),
                          //   ),
                          //
                          //   onChanged: (value) {
                          //     print(_dropDownBankKycListKey
                          //         .currentState?.getSelectedItem?.name);
                          //     selectedBank.value = value;
                          //   },
                          //
                          //   // mode: Mode.form,
                          //   decoratorProps: const DropDownDecoratorProps(
                          //     decoration: InputDecoration(
                          //       hintText: "Select Bank",
                          //       isCollapsed: false,
                          //       contentPadding: EdgeInsets.symmetric(
                          //           vertical: 15, horizontal: 14),
                          //     ),
                          //   ),
                          //
                          //   itemAsString: (item) {
                          //     return "${item.name}";
                          //   },
                          //
                          //   // enabled: selectedPlan.value.isNotEmpty,
                          // ),
                          // const SizedBox(
                          //   height: 20,
                          // ),
                          CustomInput(
                            labelText: 'NIN Number',
                            isPhone: false,
                            controller: ninController,
                            hintText: "Your NIN Number",
                            focusNode: accountNumberFocus,
                            textInputType: TextInputType.numberWithOptions(),
                            validator: ValidationBuilder()
                                .required()
                                .minLength(10)
                                .build(),
                          ),
                          CustomInput(
                            labelText: "Bvn",
                            controller: bvnController,
                            readOnly: state.accounts!.length > 1,
                            validator: ValidationBuilder()
                                .required()
                                .minLength(11)
                                .build(),
                            hintText: "Enter Your 11 digit Bvn Here",
                          ),
                          CustomInput(
                            labelText: "Date Of Birth",
                            controller: dobController,
                            readOnly: state.accounts!.length > 1,
                            validator: ValidationBuilder().required().build(),
                            hintText: "",
                            suffixIcon: IconButton(
                              onPressed: () async {
                                final res = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime.utc(1888),
                                  lastDate: DateTime.now(),
                                );
                                if (context.mounted) {
                                  if (res != null) {
                                    DateTime selectedDateTime = DateTime(
                                      res.year,
                                      res.month,
                                      res.day,
                                    );
                                    dob.value =
                                        selectedDateTime.toIso8601String();
                                    dobController.text =
                                        getDateAndYearWordFromString(
                                            selectedDateTime.toString());
                                  }
                                }
                              },
                              icon: Icon(
                                Icons.calendar_month_rounded,
                                color: AppColor.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    Button(
                        text:
                            state.user!.kyc > 1 ? "Kyc Verified" : "Enroll Now",
                        press: state.user!.kyc > 1
                            ? null
                            : () async {
                                if (kycKey.currentState!.validate()) {
                                  await handleKycRequest(
                                    context,
                                    nin: ninController.text,
                                    dob: dob.value!,
                                    bvn: bvnController.text,
                                  );
                                } else {
                                  showToast(
                                    context,
                                    title: "Field Error",
                                    desc: "Please Enter Your Bvn Correctly",
                                  );
                                }
                              }),
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
