import 'dart:io';

import 'package:browse_station/core/config/color.constant.dart';
import 'package:browse_station/core/service/request/protected.dart';
import 'package:browse_station/screen/component/app_header2.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

import '../../../../core/helper/helper.dart';
import '../../../component/transaction_item.dart';

class Transactions extends HookWidget {
  const Transactions({super.key});

  @override
  Widget build(BuildContext context) {
    RefreshController _refreshController =
        RefreshController(initialRefresh: false);
    void _onRefresh() async {
      // monitor network fetch
      await Future.delayed(Duration(milliseconds: 1000));
      // if failed,use refreshFailed()
      _refreshController.refreshCompleted();
    }

    final ValueNotifier<List<dynamic>> transactionList = useState([]);
    final ValueNotifier<bool> loading = useState(true);

    useEffect(() {
      try {
        getTransaction().then(
          (res) {
            if ((res.statusCode == HttpStatus.ok ||
                    res.statusCode == HttpStatus.notModified) &&
                res.data.containsKey('transactions') &&
                res.data['transactions'].length > 0) {
              transactionList.value = res.data['transactions'];
            }
            loading.value = false;
          },
        );
      } on DioException catch (err) {
        transactionList.value = [];
      } on Exception catch (err) {
        transactionList.value = [];
      }

      return null;
    }, []);
    return Scaffold(
      backgroundColor: AppColor.scaffordBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(1),
          child: loading.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : transactionList.value.isNotEmpty
                  ? Column(
                      children: [
                        const AppHeader2(
                          title: "Transaction",
                          titleColor: AppColor.primaryColor,
                          iconData: Icons.notifications_active_outlined,
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 18.0),
                            child: SmartRefresher(
                              onRefresh: _onRefresh,
                              controller: _refreshController,
                              header: const WaterDropHeader(),
                              child: ListView.builder(
                                  primary: false,
                                  shrinkWrap: true,
                                  itemCount: transactionList.value.length,
                                  itemBuilder: (context, index) {
                                    return TouchableOpacity(
                                      onTap: () {
                                        final data =
                                            transactionList.value[index];

                                        final Map<String, String> map =
                                            getMapFromTransaction(data: data);

                                        context.pushNamed(
                                          'transactionDetails',
                                          extra: map,
                                        );
                                      },
                                      activeOpacity: 0.4,
                                      behavior: HitTestBehavior.translucent,
                                      child: TransactionItem(
                                        data: transactionList.value[index],
                                      ),
                                    );
                                  }),
                            ),
                          ),
                        ),
                      ],
                    )
                  : const Center(
                      child: Text(
                        "No Transaction Found",
                        style: TextStyle(fontSize: 26),
                      ),
                    ),
        ),
      ),
    );
  }
}
