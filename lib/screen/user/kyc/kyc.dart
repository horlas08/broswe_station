import 'package:browse_station/core/config/color.constant.dart';
import 'package:browse_station/core/helper/helper.dart';
import 'package:browse_station/screen/component/app_header2.dart';
import 'package:browse_station/screen/component/custom_input.dart';
import 'package:browse_station/screen/component/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_validator/form_validator.dart';
import 'package:remixicon/remixicon.dart';

import '../../component/button.dart';

class Kyc extends HookWidget {
  const Kyc({super.key});

  @override
  Widget build(BuildContext context) {
    final kycKey = GlobalKey<FormState>();
    final bvnController = useTextEditingController();
    return CustomScaffold(
      header: const AppHeader2(title: "Upgrade Kyc"),
      child: Form(
        key: kycKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Let know you more",
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
            CustomInput(
              labelText: "Bvn",
              controller: bvnController,
              validator: ValidationBuilder().required().minLength(11).build(),
              hintText: "Enter Your 11 digit Bvn Here",
            ),
            Button(
              text: "Enroll Now",
              press: () async {
                if (kycKey.currentState!.validate()) {
                } else {
                  showToast(
                    context,
                    title: "Field Error",
                    desc: "Please Enter Your Bvn Correctly",
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
