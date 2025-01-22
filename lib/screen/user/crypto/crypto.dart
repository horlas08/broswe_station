import 'package:browse_station/core/config/color.constant.dart';
import 'package:browse_station/core/service/request/protected.dart';
import 'package:browse_station/screen/component/button.dart';
import 'package:browse_station/screen/component/custom_scaffold.dart';
import 'package:browse_station/screen/user/crypto/preview_crypto.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_validator/form_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shimmer/shimmer.dart';
import 'package:touchable_opacity/touchable_opacity.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';
import 'package:widget_visibility_detector/widget_visibility_detector.dart';

import '../../../data/model/crypto_info.dart';
import '../../component/app_header2.dart';

final cryptoKey = GlobalKey<FormState>();

class Crypto extends HookWidget {
  const Crypto({super.key});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<List<CryptoInfo>> res = useState([]);
    final ValueNotifier<CryptoInfo?> selectedCrypto = useState(null);
    final ValueNotifier<FormData?> formData = useState(null);
    final amountController = useTextEditingController();
    final enableButton = useState<bool>(false);

    void _handleFormChange() {
      enableButton.value = cryptoKey.currentState!.validate() ?? true;
    }

    return CustomScaffold(
      header: const AppHeader2(
        title: 'BUY CRYPTO',
        showBack: true,
      ),
      child: Form(
        key: cryptoKey,
        onChanged: _handleFormChange,
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                hintText: "0.0",
                filled: false,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                alignLabelWithHint: true,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 10,
                ),
                hintStyle: TextStyle(
                  color: AppColor.greyColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                ),
              ),
              readOnly: true,
              validator: ValidationBuilder().required().build(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
              controller: amountController,
              autofocus: true,
            ),
            const SizedBox(
              height: 30,
            ),
            if (res.value.isEmpty)
              WidgetVisibilityDetector(
                onAppear: () async {
                  try {
                    final response = await getAvailableCryptoRequest(context);
                    if (response.isNotEmpty) {
                      selectedCrypto.value = response[0];
                      res.value = response;
                    } else {
                      print('empty');
                    }
                    print("________");
                    print(res.value);
                  } catch (error) {
                    print(error);
                  }
                },
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: ListTile(
                    title: Container(
                      height: 50,
                      width: double.infinity,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            else
              TouchableOpacity(
                child: SelectCrypto(selectedCrypto),
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 25,
                        ),
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                TouchableOpacity(
                                  child: SelectCrypto(
                                    ValueNotifier(res.value[index]),
                                  ),
                                  onTap: () {
                                    selectedCrypto.value = res.value[index];
                                    context.pop();
                                  },
                                ),
                                SizedBox(
                                  height: 20,
                                )
                              ],
                            );
                          },
                          itemCount: res.value.length,
                        ),
                      );
                    },
                  );
                },
              ),
            const SizedBox(
              height: 30,
            ),
            VirtualKeyboard(
              type: VirtualKeyboardType.Numeric,
              fontSize: 25,
              textController: amountController,
              textColor: AppColor.primaryColor,
            ),
            const SizedBox(
              height: 15,
            ),
            Button(
              text: "Continue",
              press: (enableButton.value && selectedCrypto.value != null)
                  ? () {
                      showModalBottomSheet(
                        context: context,
                        isDismissible: false,
                        builder: (context) {
                          return PreviewCrypto(
                            selectedCrypto: selectedCrypto.value,
                            amount: amountController,
                          );
                        },
                      );
                    }
                  : null,
            )
          ],
        ),
      ),
    );
  }
}

Widget SelectCrypto(ValueNotifier<CryptoInfo?> selectedCrypto) {
  print(selectedCrypto.value!.image!);
  return Row(
    children: [
      CircleAvatar(
        radius: 25,
        child: CachedNetworkImage(
          imageUrl: selectedCrypto.value!.image!,
          height: 50,
          width: 50,
          placeholder: (context, url) => const CircularProgressIndicator(
            color: AppColor.primaryColor,
          ),
          errorWidget: (context, url, error) => const Icon(
            Icons.error,
            color: AppColor.primaryColor,
          ),
        ),
      ),
      SizedBox(
        width: 10,
      ),
      Column(
        children: [
          Text(
            "Sell",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              letterSpacing: 2,
            ),
          ),
          Text(
            selectedCrypto.value!.name!,
            style: TextStyle(
              color: AppColor.greyColor,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
      Spacer(),
      Icon(Ionicons.chevron_forward)
    ],
  );
}
