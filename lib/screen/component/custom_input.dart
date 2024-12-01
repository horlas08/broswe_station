import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phone_form_field/phone_form_field.dart';

import '../../core/config/color.constant.dart';

class CustomInput extends StatelessWidget {
  final String? hintText;
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  final PhoneController? phoneController;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final String? Function(String?)? validator;
  final TextInputType? textInputType;
  final Color? fillColor;
  final bool? filled;
  final bool isEnable;
  final String phoneErrorText;
  final bool isPassword;
  final bool isShowSuffixIcon;
  final bool isIcon;
  final int? maxLength;
  final int? maxLine;

  final VoidCallback? onSuffixTap;
  final bool isSearch;
  final bool isPhone;
  final Widget? prefixIcon;
  final Widget? prefix;
  final Widget? suffixIcon;
  final bool isCountryPicker;
  final TextInputAction inputAction;
  final bool needOutlineBorder;
  final bool needLabel;
  final bool readOnly;
  final bool showCursor;
  final bool autofocus;
  final bool needRequiredSign;
  final String labelText;

  const CustomInput({
    super.key,
    this.readOnly = false,
    this.filled = true,
    this.fillColor,
    this.onChanged,
    this.hintText,
    required this.labelText,
    this.controller,
    this.phoneController,
    this.focusNode,
    this.nextFocus,
    this.validator,
    this.phoneErrorText = "Phone Number Is Required",
    this.textInputType,
    this.isEnable = true,
    this.isPassword = false,
    this.prefixIcon,
    this.prefix,
    this.suffixIcon,
    this.isPhone = false,
    this.isShowSuffixIcon = false,
    this.isIcon = false,
    this.onSuffixTap,
    this.isSearch = false,
    this.isCountryPicker = false,
    this.inputAction = TextInputAction.next,
    this.needOutlineBorder = false,
    this.needLabel = true,
    this.needRequiredSign = false,
    this.showCursor = false,
    this.autofocus = false,
    this.maxLength,
    this.maxLine = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Text(
          labelText,
          style: TextStyle(
            color: AppColor.greyLightColor,
            height: 1.2,
          ),
        ),
        const SizedBox(
          height: 25,
        ),
        if (isPhone)
          PhoneFormField(
            onTapOutside: (v) => FocusManager.instance.primaryFocus?.unfocus(),
            enableSuggestions: true,
            // initialValue:
            //     const PhoneNumber(nsn: '', isoCode: IsoCode.NG),
            controller: phoneController,
            validator: PhoneValidator.compose([
              PhoneValidator.required(
                context,
                errorText: phoneErrorText,
              ),
              PhoneValidator.validMobile(context)
            ]),
            onChanged: (phoneNumber) {
              // phone.value = phoneNumber;
              // print(phoneController.value);
              // print('changed into $phoneNumber'),
            },
            enabled: true,

            isCountrySelectionEnabled: false,
            decoration: InputDecoration(
              // hintText: hintText,
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColor.danger, width: 1),
              ),
              suffixIcon: suffixIcon,
              prefixIcon: prefixIcon,
              focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColor.danger, width: 1),
              ),
              isDense: true,
              isCollapsed: true,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 14, horizontal: 14),
            ),
            countryButtonStyle: const CountryButtonStyle(
              showDialCode: true,
              showIsoCode: false,
              showFlag: false,

              showDropdownIcon: false,

              // flagSize: 14,
              textStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
              ),
            ),
          )
        else
          TextFormField(
            readOnly: readOnly,
            textAlign: TextAlign.left,
            controller: controller,
            inputFormatters: [LengthLimitingTextInputFormatter(maxLength)],
            autofocus: autofocus,
            maxLines: maxLine,
            showCursor: showCursor,
            textInputAction: inputAction,
            enabled: isEnable,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
              // isDense: true,
              prefixIcon: prefixIcon,
              prefix: prefix,
              // hintText: hintText,
              fillColor: fillColor,
              filled: filled,
              suffixIcon: suffixIcon,
              isCollapsed: false,
              // errorText: '',
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 14),
            ),
            onTapOutside: (event) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            focusNode: focusNode,
            validator: validator,
            keyboardType: textInputType,
            obscureText: isPassword ? true : false,
            onFieldSubmitted: (text) => nextFocus != null
                ? FocusScope.of(context).requestFocus(nextFocus)
                : null,
            onChanged: onChanged != null ? (text) => onChanged!(text) : null,
          ),
        Container(
          height: 15,
        ),
      ],
    );
  }
}
