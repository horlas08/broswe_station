import 'package:browse_station/core/state/bloc/repo/app/app_bloc.dart';
import 'package:browse_station/screen/component/app_header2.dart';
import 'package:browse_station/screen/component/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:remixicon/remixicon.dart';

import '../../../core/helper/helper.dart';

class Deposit extends StatelessWidget {
  const Deposit({super.key});

  @override
  Widget build(BuildContext context) {
    final accounts = context.read<AppBloc>().state.accounts;
    final user = context.read<AppBloc>().state.user;
    print(accounts);
    return CustomScaffold(
      header: AppHeader2(title: "Deposit Method"),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Select account",
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'In line with CBN, a NGN50 charge applies to deposits made to the account provided for you.',
          ),
          const SizedBox(
            height: 20,
          ),
          ListCard(
            name: "MoniePoint",
            desc: "View your monnify account details",
            icon: Remix.bank_line,
            margin: EdgeInsets.zero,
            onTap: () {
              final List<Map<String, String>> account = [
                {
                  'account number': accounts![0].accountNumber.toString(),
                  'account name': accounts[0].accountName.toString(),
                  'bank name': accounts[0].bankName.toString(),
                  // 'type': "Monnify",
                }
              ];
              context.pushNamed("myAccount", extra: account);
            },
          ),
          const SizedBox(
            height: 20,
          ),
          ListCard(
            name: "9PSB Account",
            desc: "View your 9 Payment service bank account ",
            icon: Remix.bank_line,
            margin: EdgeInsets.zero,
            onTap: () {
              final List<Map<String, String>> account = [
                {
                  'account number': accounts![1].accountNumber.toString(),
                  'account name': accounts[1].accountName.toString(),
                  'bank name': accounts[1].bankName.toString(),
                  // 'type': "9PSB",
                }
              ];
              context.pushNamed("myAccount", extra: account);
            },
          ),
        ],
      ),
    );
  }
}
