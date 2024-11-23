import 'dart:io';

import 'package:browse_station/core/helper/helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

import '../../../core/config/color.constant.dart';
import '../../../core/service/request/protected.dart';
import '../transaction_item.dart';

class Transaction extends HookWidget {
  const Transaction({super.key});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> loading = useState(true);
    final ValueNotifier<List<dynamic>> transactionList = useState([]);

    useEffect(() {
      try {
        getTransaction(limit: 5).then((res) {
          if ((res.statusCode == HttpStatus.ok ||
                  res.statusCode == HttpStatus.notModified) &&
              res.data.containsKey('transactions') &&
              res.data['transactions'].length > 0) {
            transactionList.value = res.data['transactions'];
          }
          loading.value = false;
        });
      } on DioException catch (err) {
        transactionList.value = [];
      } on Exception catch (err) {
        transactionList.value = [];
      }

      return null;
    }, []);

    return Column(
      children: [
        Row(
          children: [
            Text(
              "Last 5 Transaction",
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontWeight: FontWeight.w900),
            ),
            const Spacer(),
            TouchableOpacity(
              activeOpacity: 0.4,
              onTap: () => context.pushNamed('transactions'),
              child: Text(
                "View All",
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Mulish',
                      color: AppColor.blueColor,
                    ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        SizedBox(
          height: transactionList.value.isEmpty
              ? 50
              : double.parse((80 * transactionList.value.length).toString()),
          child: loading.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : transactionList.value.isNotEmpty
                  ? Column(
                      children: [
                        ...List.generate(
                          transactionList.value.length,
                          (index) {
                            return TouchableOpacity(
                              onTap: () {
                                final data = transactionList.value[index];

                                final Map<String, String> map =
                                    getMapFromTransaction(data: data);

                                context.pushReplacementNamed(
                                  'transactionDetails',
                                  extra: map,
                                );
                              },
                              activeOpacity: 0.98,
                              behavior: HitTestBehavior.translucent,
                              child: TransactionItem(
                                data: transactionList.value[index],
                              ),
                            );
                          },
                        ),
                      ],
                    )
                  : const Center(
                      child: Text(
                        "No Transaction Found",
                        style: TextStyle(fontSize: 26),
                      ),
                    ),
        )
      ],
    );
  }
}
