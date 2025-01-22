import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:browse_station/core/config/color.constant.dart';
import 'package:browse_station/core/helper/helper.dart';
import 'package:browse_station/data/model/crypto_info.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:toastification/toastification.dart';

import '../../../core/service/request/protected.dart';
import '../../component/button.dart';

final ImagePicker picker = ImagePicker();

class PreviewCrypto extends HookWidget {
  final CryptoInfo? selectedCrypto;
  final TextEditingController amount;

  const PreviewCrypto({super.key, this.selectedCrypto, required this.amount});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<File?> pickedFile = useState(null);
    final ValueNotifier<XFile?> imagePicked = useState(null);
    final ValueNotifier<FormData?> formData = useState(null);
    Future _pickImage({required ImageSource source}) async {
      final XFile? image = await picker.pickImage(
        source: source,
        imageQuality: 100,
        maxHeight: 500,
        maxWidth: 500,
      );
      if (image != null) {
        imagePicked.value = image;
        File file = File(image.path);
        pickedFile.value = file;

        String fileName = file.path.split('/').last;
        print(fileName.split('.').last);
        print(fileName);
        var formInfo = FormData.fromMap({
          'crypto_id': selectedCrypto!.id!,
          'amount': amount.text,
          'proof_of_payment': await MultipartFile.fromFile(
            file.path,
            filename: fileName,
            contentType: DioMediaType('image', fileName.split('.').last),
          ),
        });

        formData.value = formInfo;
        print("_____");
        print(formInfo.files[0].value.filename);
        if (context.mounted) {
          showToast(
            context,
            title: "success",
            desc: "Image Picked Successfully",
            type: ToastificationType.success,
          );
        }

        // if (context.mounted) {
        //   context.loaderOverlay.show();
        //   final resp = await dio.post(profileUpdate,
        //       data: formData,
        //       options: Options(
        //         contentType: Headers.multipartFormDataContentType,
        //         headers: {
        //           Headers.contentTypeHeader:
        //               Headers.multipartFormDataContentType
        //         },
        //       ),
        //       queryParameters: {'token': appBox.get("token")});
        //   print(resp);
        //   if (resp.statusCode == HttpStatus.ok && context.mounted) {
        //     final res = await refreshUSerDetail();
        //
        //     if (res == null && context.mounted) {
        //       context.loaderOverlay.hide();
        //     }
        //
        //     if (res?.statusCode == HttpStatus.ok && context.mounted) {
        //       context.read<AppBloc>().add(
        //           UpdateUserEvent(userData: res?.data['data']['user_data']));
        //
        //       context.loaderOverlay.hide();
        //
        //       showToast(
        //         context,
        //         title: "success",
        //         desc: resp.data['message'],
        //         type: ToastificationType.success,
        //       );
        //     } else {
        //       if (context.mounted) context.loaderOverlay.hide();
        //     }
        //   }
        // }
      }
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 15,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              "Crypto CheckOut Preview",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            CachedNetworkImage(
              imageUrl: selectedCrypto!.qrCode!,
              height: 150,
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SelectableText(
                  "Wallet Address",
                  style: TextStyle(
                    color: AppColor.primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    await Clipboard.setData(
                      ClipboardData(
                        text: selectedCrypto!.walletAddress!,
                      ),
                    );
                    if (context.mounted) {
                      showToast(
                        context,
                        title: 'Copied',
                        desc: 'Wallet Address Copied Successfully',
                        type: ToastificationType.success,
                      );
                    }
                  },
                  icon: Icon(
                    Ionicons.copy,
                    color: AppColor.primaryColor,
                  ),
                )
              ],
            ),
            AutoSizeText(
              selectedCrypto!.walletAddress!,
              maxLines: 3,
            ),
            SizedBox(
              height: 20,
            ),
            RowList(
              key: "Coin",
              value: selectedCrypto!.name!,
            ),
            RowList(
              key: "Quantity To Sell",
              value:
                  "${amount.text} ${selectedCrypto!.symbol} = ${(double.parse(selectedCrypto!.rate!) * double.parse(amount.text))}₦",
            ),
            RowList(
              key: "Rate",
              value:
                  "1 ${selectedCrypto!.symbol!} =  ${selectedCrypto!.rate!}₦",
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () async {
                try {
                  imagePicked.value = null;
                  pickedFile.value = null;
                  await _pickImage(source: ImageSource.gallery);
                } catch (e) {
                  showToast(context, title: "error", desc: e.toString());
                }
              },
              child: Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColor.primaryColor,
                      style: BorderStyle.solid,
                    )),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (pickedFile.value == null || imagePicked.value == null)
                        Wrap(
                          runAlignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          verticalDirection: VerticalDirection.down,
                          direction: Axis.vertical,
                          children: [
                            Icon(
                              Ionicons.cloud_upload_outline,
                              color: AppColor.primaryColor,
                              size: 64,
                            ),
                            Text("Upload Prove Of Send")
                          ],
                        )
                      else
                        Column(
                          children: [
                            Icon(
                              Ionicons.checkmark_done_sharp,
                              color: Colors.green,
                              size: 64,
                            ),
                            Text("Image Name: ${imagePicked.value!.name}")
                          ],
                        )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            if (!(pickedFile.value == null || imagePicked.value == null))
              Row(
                children: [
                  SizedBox(
                    width: 150,
                    child: Button(
                      text: "Cancel",
                      press: () {
                        context.pop();
                      },
                    ),
                  ),
                  Spacer(),
                  SizedBox(
                    width: 150,
                    child: Button(
                      text: "Submit",
                      press: () async {
                        try {
                          print(formData);
                          context.loaderOverlay.show();
                          final res = await buyCryptoRequest(context,
                              formData: formData.value!);
                          if (context.mounted) {
                            if (res.statusCode == HttpStatus.ok) {
                              context.loaderOverlay.hide();
                              context.go("/transaction/successful",
                                  extra: res.data['message']);
                            } else {
                              throw Exception(res.data['message']);
                            }
                          }
                        } on DioException catch (error) {
                          if (context.mounted) {
                            context.loaderOverlay.hide();
                            context.pop();
                            showToast(context,
                                title: " Validate Error",
                                desc: error.response?.data['message'] ??
                                    error.toString());
                          }
                        } on Exception catch (error) {
                          if (context.mounted) {
                            context.loaderOverlay.hide();
                            showToast(context,
                                title: " Validate Error",
                                desc: error.toString());
                          }
                        } finally {
                          if (context.mounted) {
                            context.loaderOverlay.hide();
                          }
                        }
                      },
                    ),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
