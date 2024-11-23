import 'dart:io';
import 'dart:typed_data';

import 'package:browse_station/screen/component/app_header2.dart';
import 'package:browse_station/screen/component/button.dart';
import 'package:browse_station/screen/component/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/helper/helper.dart';
import '../../bills/receipt/receipt.dart';

class TransactionDetails extends HookWidget {
  final Map<String, String> data;
  const TransactionDetails({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final ScreenshotController screenshotController = ScreenshotController();

    final ValueNotifier<bool> loading = useState(false);
    final ValueNotifier<bool> isDownloading = useState(false);

    return CustomScaffold(
      header: const AppHeader2(
        title: 'Transaction Details',
      ),
      headerDesc: 'Below is the details of your transaction',
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.only(top: 40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                ...List.generate(
                  data.length,
                  (index) {
                    return RowList(
                      key: data.keys.toList()[index],
                      value: data.values.toList()[index],
                      showLine: data.values.length != index + 1,
                    );
                  },
                ),
                // ...List.generate(
                //   data.length,
                //   (index) {
                //     return RowList(
                //       key: data.keys.toList()[index],
                //       value: data.values.toList()[index],
                //       showLine: data.values.length != index + 1,
                //     );
                //   },
                // ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Button(
            text: "Download Receipt",
            prefixIcon: isDownloading.value
                ? const SizedBox(
                    width: 30,
                    height: 30,
                    child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        )),
                  )
                : null,
            press: () async {
              if (isDownloading.value) {
                return;
              }
              isDownloading.value = true;
              final image = await screenshotController.captureFromWidget(
                  Receipt(
                    data: data,
                  ),
                  pixelRatio: 6 // Adjust for image clarity
                  );
              if (image != null) {
                // Get a temporary directory to save the image
                final directory = await getDownloadsDirectory();
                final imagePath = '${directory?.path}/receipt.png';

                // Save the image
                File(imagePath).writeAsBytesSync(image);
                isDownloading.value = false;
                if (context.mounted) {
                  showToast(
                    context,
                    title: 'File Saved',
                    desc: "Download Receipt to $imagePath",
                    type: ToastificationType.success,
                  );
                }
              }
            },
          ),
          const SizedBox(
            height: 7,
          ),
          Button(
            text: "Share Receipt",
            prefixIcon: loading.value
                ? const SizedBox(
                    width: 30,
                    height: 30,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  )
                : null,
            press: () async {
              if (loading.value) {
                return;
              }
              loading.value = true;
              final image = await screenshotController.captureFromWidget(
                  Receipt(
                    data: data,
                  ),
                  pixelRatio: 6 // Adjust for image clarity
                  );
              if (image != null) {
                // Get a temporary directory to save the image
                final directory = await getTemporaryDirectory();
                final imagePath = '${directory.path}/receipt.png';

                // Save the image
                File(imagePath).writeAsBytesSync(image);

                // Share the image file
                final result = await Share.shareXFiles([XFile('${imagePath}')],
                    text: 'Transaction Receipt');

                if (context.mounted) {
                  if (result.status == ShareResultStatus.success) {
                    loading.value = false;
                    deleteFile(File(imagePath));
                    showToast(
                      context,
                      title: "success",
                      desc: "Receipt share successful",
                      type: ToastificationType.success,
                    );
                  } else {
                    loading.value = false;
                    showToast(
                      context,
                      title: "error",
                      desc: "Receipt share cancelled",
                      type: ToastificationType.info,
                    );
                  }
                }
              }
            },
          )
        ],
      ),
    );
  }

  Widget buildImage(Uint8List bytes) {
    return Image.memory(bytes);
  }
}
