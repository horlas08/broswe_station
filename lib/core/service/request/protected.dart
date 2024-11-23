import 'dart:async';
import 'dart:io';

import 'package:browse_station/core/config/app.constant.dart';
import 'package:browse_station/data/model/betting_providers.dart';
import 'package:browse_station/data/model/epin_providers.dart';
import 'package:browse_station/data/model/portraitcuts.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../data/model/bank.dart';
import '../../../data/model/cable_plan.dart';
import '../../../data/model/electricity_providers.dart';
import '../../helper/helper.dart';
import '../../state/bloc/repo/app/app_bloc.dart';
import '../http.dart';

Future<Response> getTransaction({int? limit}) async {
  var appBox = Hive.box('appBox');
  final res = await dio.get(
    limit != null ? transactionPath : transactionPath2,
    data: limit != null
        ? {
            'limit': limit,
            'token': appBox.get('token'),
          }
        : {
            'token': appBox.get('token'),
          },
  );

  return res;
}

Future<Response> validatePinRequest({required String pin}) async {
  var appBox = Hive.box('appBox');
  final res = await dio.post(
    validatePin,
    data: {
      'token': appBox.get('token'),
      'pin': pin,
    },
  );

  return res;
}

Future<Response> buyAirtimeRequest(
  BuildContext context, {
  required String amount,
  required String phone,
  required String network,
  required String trx_id,
  required String airtime_type,
}) async {
  final res = await dio.post(
    buyAirtime,
    data: {
      "amount": amount,
      "phone": phone,
      "trx_id": trx_id,
      "airtime_type": airtime_type,
      "network_id": getNetworkIdByName(network: network)
    },
    options: Options(
      headers: {
        'Authorization': "Bearer ${context.read<AppBloc>().state.user?.apiKey}"
      },
    ),
  );

  return res;
}

Future<Response> buyCableRequest(
  BuildContext context, {
  required String smartcard_number,
  required String trx_id,
  required String service_id,
  required String plan_id,
  required String customer_name,
}) async {
  final res = await dio.post(
    postCable,
    data: {
      "smartcard_number": smartcard_number,
      "trx_id": trx_id,
      "service_id": service_id,
      "plan_id": plan_id,
      "customer_name": customer_name
    },
    options: Options(
      headers: {
        'Authorization': "Bearer ${context.read<AppBloc>().state.user?.apiKey}"
      },
    ),
  );

  return res;
}

Future<Map<String, dynamic>?> getDataPlanRequest(
    BuildContext context, ValueNotifier<String> selectedNetwork) async {
  context.loaderOverlay.show();

  final res = await dio.get(
    getDataPlan,
    options: Options(
      headers: {
        'Authorization': "Bearer ${context.read<AppBloc>().state.user?.apiKey}"
      },
    ),
  );
  if (context.mounted) {
    context.loaderOverlay.hide();
  }
  print(res.statusCode);
  if (res.statusCode == HttpStatus.ok ||
      res.statusCode == HttpStatus.notModified) {
    // print(selectedNetwork.value);
    // print(res.data[selectedNetwork.value.toUpperCase()]);
    return res.data[selectedNetwork.value.toUpperCase()]['data_type'];

    // return DataPlan.fromJsonList(res.data['data']);
  }
  return null;
}

Future<List<CablePlan>> getCablePlanRequest(
    BuildContext context, String selectedNetwork) async {
  context.loaderOverlay.show();
  final res = await dio.get(
    getCableVariation,
    data: {
      'service_id': getCableIdByName(
        network: selectedNetwork,
      ),
    },
    options: Options(
      headers: {
        'Authorization': "Bearer ${context.read<AppBloc>().state.user?.apiKey}"
      },
    ),
  );
  if (context.mounted) {
    context.loaderOverlay.hide();
    if (res.statusCode == HttpStatus.ok) {
      return CablePlan.fromJsonList(res.data['data']);
    } else {
      return [];
    }
  }
  return [];
}

Future<Response> verifyCableRequest(
  BuildContext context,
  TextEditingController cableNumber,
  ValueNotifier<String> selectedBiller,
  ValueNotifier<CablePlan?> selectedPlan,
) async {
  context.loaderOverlay.show();
  final res = await dio.get(
    verifyCable,
    queryParameters: {
      'customer_id': cableNumber.text,
      'plan_id': selectedPlan.value?.id,
      'service_id': getCableIdByName(network: selectedBiller.value),
    },
    options: Options(
      headers: {
        'Authorization': "Bearer ${context.read<AppBloc>().state.user?.apiKey}"
      },
    ),
  );
  return res;
}

Future<Response> buyDataRequest(
  BuildContext context, {
  required String variation_id,
  required String phone,
  required String trx_id,
  required String data_type,
  required String network_id,
}) async {
  var appBox = Hive.box('appBox');
  final res = await dio.get(
    buyData,
    data: {
      "variation_id": variation_id, //variationId,
      "phone": phone, //phone,
      "trx_id": trx_id,
      "data_type": data_type,
      "network_id": int.parse(network_id)
    },
    options: Options(
      headers: {
        'Authorization': "Bearer ${context.read<AppBloc>().state.user?.apiKey}"
      },
    ),
  );

  return res;
}

Future<Response> verifyMeterRequest(
  BuildContext context,
  TextEditingController meterNumber,
  ValueNotifier<ElectricityProviders?> disco,
  TextEditingController meterType,
) async {
  context.loaderOverlay.show();
  final res = await dio.get(
    verifyMeter,
    queryParameters: {
      'meter_number': meterNumber.text,
      'disco': disco.value?.id,
      'meter_type': meterType.text.toLowerCase(),
    },
    options: Options(
      headers: {
        'Authorization': "Bearer ${context.read<AppBloc>().state.user?.apiKey}"
      },
    ),
  );
  return res;
}

Future<Response> verifyBettingRequest(
  BuildContext context,
  TextEditingController bettingId,
  ValueNotifier<BettingProviders?> serviceId,
) async {
  context.loaderOverlay.show();
  final res = await dio.get(
    verifyBetting,
    queryParameters: {
      'customer_id': bettingId.text,
      'service_id': serviceId.value?.id
    },
    options: Options(
      headers: {
        'Authorization': "Bearer ${context.read<AppBloc>().state.user?.apiKey}"
      },
    ),
  );
  return res;
}

Future<List<ElectricityProviders>> getMeterLocationRequest(
    BuildContext context) async {
  context.loaderOverlay.show();
  final res = await dio.get(
    getElectricityDisco,
    options: Options(
      headers: {
        'Authorization': "Bearer ${context.read<AppBloc>().state.user?.apiKey}"
      },
    ),
  );
  if (context.mounted) {
    context.loaderOverlay.hide();
    if (res.statusCode == HttpStatus.ok) {
      return ElectricityProviders.fromJsonList(res.data['data']);
    } else {
      return [];
    }
  }
  return [];
}

Future<Response> buyMeterRequest(
  BuildContext context, {
  required String amount,
  required String meter_number,
  required String trx_id,
  required String disco,
  required String customer_name,
  required String meter_type,
}) async {
  final res = await dio.post(
    postElectricity,
    data: {
      "amount": amount,
      "meter_number": meter_number,
      "trx_id": trx_id,
      "disco": disco,
      "customer_name": customer_name,
      "meter_type": meter_type
    },
    options: Options(
      headers: {
        'Authorization': "Bearer ${context.read<AppBloc>().state.user?.apiKey}"
      },
    ),
  );

  return res;
}

Future<List<BettingProviders>> getbettingBillersRequest(
    BuildContext context) async {
  context.loaderOverlay.show();
  final res = await dio.get(
    getBetting,
    options: Options(
      headers: {
        'Authorization': "Bearer ${context.read<AppBloc>().state.user?.apiKey}"
      },
    ),
  );
  if (context.mounted) {
    context.loaderOverlay.hide();
    if (res.statusCode == HttpStatus.ok) {
      return BettingProviders.fromJsonList(res.data['data']);
    } else {
      return [];
    }
  }
  return [];
}

Future<Response> buyBettingRequest(
  BuildContext context, {
  required String amount,
  required String customer_id,
  required String customer_name,
  required String trx_id,
  required String service_id,
}) async {
  final res = await dio.post(
    postBetting,
    data: {
      "amount": amount,
      "customer_id": customer_id,
      "customer_name": customer_name,
      "trx_id": trx_id,
      "service_id": service_id
    },
    options: Options(
      headers: {
        'Authorization': "Bearer ${context.read<AppBloc>().state.user?.apiKey}"
      },
    ),
  );

  return res;
}

Future<List<Bank>> getBankListRequest(BuildContext context) async {
  context.loaderOverlay.show();
  final res = await dio.get(
    getBankList,
    options: Options(
      headers: {
        'Authorization': "Bearer ${context.read<AppBloc>().state.user?.apiKey}"
      },
    ),
  );
  if (context.mounted) {
    context.loaderOverlay.hide();
    if (res.statusCode == HttpStatus.ok) {
      return Bank.fromJsonList(res.data['data']);
    } else {
      return [];
    }
  }
  return [];
}

Future<Response> verifyAccountNumberRequest(
  BuildContext context,
  TextEditingController accNumber,
  ValueNotifier<Bank?> selectedBank,
) async {
  context.loaderOverlay.show();
  final res = await dio.get(
    verifyAccount,
    queryParameters: {
      'account_no': accNumber.text,
      'bank_code': selectedBank.value?.code
    },
    options: Options(
      headers: {
        'Authorization': "Bearer ${context.read<AppBloc>().state.user?.apiKey}"
      },
    ),
  );
  return res;
}

Future<Response> withdrawRequest(
  BuildContext context, {
  required String amount,
  required String bank_code,
  required String account_no,
}) async {
  final res = await dio.post(
    postWithdraw,
    data: {
      "amount": amount,
      "bank_code": bank_code,
      "account_no": account_no,
    },
    options: Options(
      headers: {
        'Authorization': "Bearer ${context.read<AppBloc>().state.user?.apiKey}"
      },
    ),
  );

  return res;
}

Future<List<PortraitcutsModel>> getPortraitcutsRequest(
    BuildContext context) async {
  context.loaderOverlay.show();
  final res = await dio.get(
    getPortraitcuts,
    options: Options(
      headers: {
        'Authorization': "Bearer ${context.read<AppBloc>().state.user?.apiKey}"
      },
    ),
  );
  if (context.mounted) {
    context.loaderOverlay.hide();
    if (res.statusCode == HttpStatus.ok) {
      return PortraitcutsModel.fromJsonList(res.data['data']);
    } else {
      return [];
    }
  }
  return [];
}

Future<List<EpinProviders>> getEpinRequest(BuildContext context) async {
  context.loaderOverlay.show();
  final res = await dio.get(
    getEpin,
    options: Options(
      headers: {
        'Authorization': "Bearer ${context.read<AppBloc>().state.user?.apiKey}"
      },
    ),
  );
  if (context.mounted) {
    context.loaderOverlay.hide();
    if (res.statusCode == HttpStatus.ok) {
      return EpinProviders.fromJsonList(res.data['data']);
    } else {
      return [];
    }
  }
  return [];
}

Future<Response> portraitcutRequest(
  BuildContext context, {
  required String service_id,
  required String phonenumber,
  required String address,
  required String datetime,
  required String instagram,
}) async {
  final res = await dio.post(
    postPortraitcut,
    data: {
      "service_id": service_id,
      "phonenumber": phonenumber,
      "address": address,
      "datetime": datetime,
      "instagram": instagram
    },
    options: Options(
      headers: {
        'Authorization': "Bearer ${context.read<AppBloc>().state.user?.apiKey}"
      },
    ),
  );

  return res;
}

Future<Response> epinRequest(BuildContext context,
    {required String epin, required String quantity}) async {
  final res = await dio.post(
    buyEpin,
    data: {"epin": epin, "quantity": quantity},
    options: Options(
      headers: {
        'Authorization': "Bearer ${context.read<AppBloc>().state.user?.apiKey}"
      },
    ),
  );

  return res;
}

Future<Response> changePasswordRequest(
  BuildContext context, {
  required String old_password,
  required String password,
  required String confirm_password,
}) async {
  var appBox = Hive.box("appBox");

  final res = await dio.post(
    changePassword,
    data: {
      "old_password": old_password,
      "password": password,
      "confirm_password": confirm_password,
      "token": appBox.get('token'),
    },
    options: Options(
      headers: {
        'Authorization': "Bearer ${context.read<AppBloc>().state.user?.apiKey}"
      },
    ),
  );

  return res;
}

Future<Response> updateProfileRequest(
  BuildContext context, {
  required String firstName,
  required String lastName,
  required String phone,
}) async {
  var appBox = Hive.box('appBox');
  final res = await dio.post(
    profileUpdate,
    data: {
      "firstname": firstName,
      "lastname": lastName,
      "phone": phone,
      "token": appBox.get('token'),
    },
    options: Options(
      headers: {
        'Authorization': "Bearer ${context.read<AppBloc>().state.user?.apiKey}"
      },
    ),
  );

  return res;
}

Future<Response> changePinRequest(
  BuildContext context, {
  required String old_pin,
  required String pin,
  required String confirm_pin,
}) async {
  var appBox = Hive.box("appBox");
  final res = await dio.post(
    changePin,
    data: {
      "old_pin": old_pin,
      "pin": pin,
      "confirm_pin": confirm_pin,
      "token": appBox.get('token'),
    },
    options: Options(
      headers: {
        'Authorization': "Bearer ${context.read<AppBloc>().state.user?.apiKey}"
      },
    ),
  );

  return res;
}
