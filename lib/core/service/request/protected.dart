import 'dart:async';
import 'dart:io';

import 'package:browse_station/core/config/app.constant.dart';
import 'package:browse_station/data/model/betting_providers.dart';
import 'package:browse_station/data/model/crypto_info.dart';
import 'package:browse_station/data/model/epin_providers.dart';
import 'package:browse_station/data/model/esim.dart';
import 'package:browse_station/data/model/portraitcuts.dart';
import 'package:browse_station/data/model/product.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:toastification/toastification.dart';

import '../../../data/model/bank.dart';
import '../../../data/model/cable_plan.dart';
import '../../../data/model/country.dart';
import '../../../data/model/electricity_providers.dart';
import '../../helper/helper.dart';
import '../../state/bloc/repo/app/app_bloc.dart';
import '../../state/bloc/repo/app/app_event.dart';
import '../http.dart';

Future<Response> getTransaction({int? limit, Options? option}) async {
  var appBox = Hive.box('appBox');
  final res = await dio.get(limit != null ? transactionPath : transactionPath2,
      data: limit != null
          ? {
              'limit': limit,
              'token': appBox.get('token'),
            }
          : {
              'token': appBox.get('token'),
            },
      options: option);

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
  // required String promocode,
}) async {
  final res = await dio.post(
    buyAirtime,
    data: {
      "amount": amount,
      "phone": phone,
      "trx_id": trx_id,
      "airtime_type": airtime_type,
      "network_id": getNetworkIdByName(network: network),
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
    final response = res.data;

    final Map<String, dynamic> data = (response as Map).map(
      (key, value) {
        return MapEntry(key.toString().toUpperCase(), value);
      },
    );

    return data[selectedNetwork.value.toUpperCase()]['data_type'];

    // return DataPlan.fromJsonList(res.data['data']);
  }
  return null;
}

Future<List<CablePlan>> getCablePlanRequest(
    BuildContext context, String selectedNetwork) async {
  context.loaderOverlay.show();
  final cacheStore = MemCacheStore();
  final cacheOptions = CacheOptions(
    policy: CachePolicy.noCache, store: cacheStore, // Do not cache this request
  );
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
      extra: cacheOptions.toExtra(),
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
  required String promocode,
}) async {
  var appBox = Hive.box('appBox');
  final res = await dio.get(
    buyData,
    data: {
      "variation_id": variation_id, //variationId,
      "phone": phone, //phone,
      "trx_id": trx_id,
      "data_type": data_type,
      "network_id": int.parse(network_id),
      "promocode": 'promocode'
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

Future<List<CryptoInfo>> getAvailableCryptoRequest(BuildContext context) async {
  // context.loaderOverlay.show();
  final res = await dio.get(
    getAvailableCrypto,
    options: Options(
      headers: {
        'Authorization': "Bearer ${context.read<AppBloc>().state.user?.apiKey}"
      },
    ),
  );
  print(res.statusCode);
  if (context.mounted) {
    // context.loaderOverlay.hide();
    if (res.statusCode == HttpStatus.ok || res.statusCode == 304) {
      print(res);
      final cryptoList = CryptoInfo.fromJsonList(res.data['data']);
      print(cryptoList);
      return cryptoList;
    } else {
      return [];
    }
  }
  return [];
}

Future<Response> buyCryptoRequest(
  BuildContext context, {
  required FormData formData,
}) async {
  final res = await dio.post(
    postSellCrypto,
    data: formData,
    options: Options(
      contentType: Headers.multipartFormDataContentType,
      headers: {
        Headers.contentTypeHeader: Headers.multipartFormDataContentType,
        'Authorization': "Bearer ${context.read<AppBloc>().state.user?.apiKey}"
      },
    ),
  );

  return res;
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

Future<List<Bank>> getBankListRequest(BuildContext context,
    {String path = getBankList}) async {
  context.loaderOverlay.show();
  final res = await dio.get(
    path,
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

Future<Response> giftCardRequest(
  BuildContext context, {
  required String country,
  required String productid,
  required String quantity,
  required String amount,
  required String amountngn,
  required String email,
  required String phone,
}) async {
  final res = await dio.post(
    postGiftCard,
    data: {
      "country": country,
      "productid": productid,
      "quantity": quantity,
      "amount": amount,
      "amountngn": amountngn,
      "email": email,
      "phone": phone
    },
    options: Options(
      headers: {
        'Authorization': "Bearer ${context.read<AppBloc>().state.user?.apiKey}"
      },
    ),
  );

  return res;
}

Future<Response> epinRequest(
  BuildContext context, {
  required String plan_type,
  required String plan_id,
  required String email,
  required String fullname,
}) async {
  final res = await dio.post(
    postEpin,
    data: {
      "plan_type": plan_type,
      "plan_id": plan_id,
      "email": email,
      "fullname": fullname
    },
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

Future<Response> validatePromoCode(
  BuildContext context, {
  required String code,
}) async {
  var appBox = Hive.box("appBox");
  final cacheStore = MemCacheStore();
  final cacheOptions = CacheOptions(
      policy: CachePolicy.noCache, store: cacheStore, maxStale: Durations.short1
      // Do not cache this request
      );
  final res = await dio.post(
    "${verifyPromoCode}?promocode=${code}",
    // data: {
    //   "promocode": code,
    //   // "token": appBox.get('token'),
    // },
    options: Options(
      headers: {
        'Authorization': "Bearer ${context.read<AppBloc>().state.user?.apiKey}",
      },
      extra: cacheOptions.toExtra(),
    ),
  );
  print("_______");
  print(res.statusCode);
  print("_______");
  return res;
}

Future<Response> commissionWithdrawRequest(BuildContext context,
    {required String amount}) async {
  var appBox = Hive.box("appBox");
  final res = await dio.post(
    commissionWithdrawal,
    data: {
      "amount": amount,
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

handleUpgrade(BuildContext context) async {
  context.loaderOverlay.show();
  var appBox = Hive.box('appBox');
  final resp = await dio.put(
    upgradeToAgent,
    data: {
      'token': appBox.get("token"),
    },
  );

  if (resp.statusCode == HttpStatus.ok) {
    final response = await refreshUSerDetail();

    if (response?.statusCode == HttpStatus.ok && context.mounted) {
      final userData = response?.data['data']['user_data'];
      final alt_notification = response?.data['data']['alt_notification'];
      userData.addAll({"alt_notification": alt_notification});
      context.read<AppBloc>().add(
            UpdateUserEvent(
              userData: userData,
            ),
          );

      context.loaderOverlay.hide();
      showToast(context,
          title: "success",
          desc: resp.data['message'],
          type: ToastificationType.success);
      return;
    }
  } else {
    if (context.mounted) {
      context.loaderOverlay.hide();
      showToast(context, title: "error", desc: resp.data['message']);
      return;
    }
  }
}

refreshUserDetails(BuildContext context, {bool showLoading = true}) async {
  if (showLoading) context.loaderOverlay.show();
  var appBox = Hive.box('appBox');
  try {
    final response = await refreshUSerDetail();
    if (response?.statusCode == HttpStatus.ok && context.mounted) {
      final userData = response?.data['data']['user_data'];
      final alt_notification = response?.data['data']['alt_notification'];
      userData.addAll({"alt_notification": alt_notification});
      context.read<AppBloc>().add(
            UpdateUserEvent(
              userData: userData,
            ),
          );

      if (showLoading) context.loaderOverlay.hide();
      if (showLoading) {
        showToast(context,
            title: "success",
            desc: 'Refresh successful',
            type: ToastificationType.success);
      }
      return;
    } else {
      throw Exception(response?.data['message']);
    }
  } on DioException catch (err) {
    if (showLoading) context.loaderOverlay.hide();
    // showToast(context,
    //     title: "error", desc: 'Refresh failed', type: ToastificationType.error);
  } on Exception catch (err) {
    if (showLoading) context.loaderOverlay.hide();
    // showToast(context,
    //     title: "error", desc: 'Refresh failed', type: ToastificationType.error);
  }
}

Future<List<Country>> getCountryRequest(BuildContext context) async {
  context.loaderOverlay.show();

  final res = await dio.get(
    getCountryVariation,
    options: Options(headers: {
      'Authorization': "Bearer ${context.read<AppBloc>().state.user?.apiKey}"
    }),
  );
  if (context.mounted) {
    context.loaderOverlay.hide();
    if (res.statusCode == HttpStatus.ok) {
      return Country.fromJsonList(res.data['data']);
    } else {
      return [];
    }
  }
  return [];
}

Future<List<Product>> getProductRequest(
    BuildContext context, String selectedProductId) async {
  context.loaderOverlay.show();
  final cacheStore = MemCacheStore();
  final cacheOptions = CacheOptions(
    policy: CachePolicy.noCache, store: cacheStore, // Do not cache this request
  );
  final res = await dio.get(
    getProductVariation,
    queryParameters: {
      'iso': selectedProductId,
    },
    options: Options(
      headers: {
        'Authorization': "Bearer ${context.read<AppBloc>().state.user?.apiKey}"
      },
      extra: cacheOptions.toExtra(),
    ),
  );
  if (context.mounted) {
    context.loaderOverlay.hide();
    if (res.statusCode == HttpStatus.ok) {
      return Product.fromJsonList(res.data['data']);
    } else {
      return [];
    }
  }
  return [];
}

Future<List<EsimModel>> getEsimRequest(
    BuildContext context, String selectedProductId) async {
  final cacheStore = MemCacheStore();
  final cacheOptions = CacheOptions(
    policy: CachePolicy.noCache, store: cacheStore, // Do not cache this request
  );
  final res = await dio.get(
    getEsimPlans,
    data: {
      'type': selectedProductId,
    },
    options: Options(
      headers: {
        'Authorization': "Bearer ${context.read<AppBloc>().state.user?.apiKey}"
      },
      extra: cacheOptions.toExtra(),
    ),
  );
  if (context.mounted) {
    if (res.statusCode == HttpStatus.ok) {
      return EsimModel.fromJsonList(res.data['data']);
    } else {
      return [];
    }
  }
  return [];
}

Future handleKycRequest(
  BuildContext context, {
  required String bvn,
  required String nin,
  required String dob,
}) async {
  try {
    context.loaderOverlay.show();

    var appBox = Hive.box('appBox');
    final resp = await dio.post(
      kycLevel,
      data: {
        "bvn": bvn,
        "nin": nin,
        "dob": dob,
      },
      options: Options(
        headers: {
          'Authorization':
              "Bearer ${context.read<AppBloc>().state.user?.apiKey}"
        },
      ),
    );

    if (resp.statusCode == HttpStatus.ok) {
      final response = await refreshUSerDetail();

      if (response?.statusCode == HttpStatus.ok && context.mounted) {
        final userData = response?.data['data']['user_data'];
        final alt_notification = response?.data['data']['alt_notification'];
        userData.addAll({"alt_notification": alt_notification});
        context.read<AppBloc>().add(
              UpdateUserEvent(
                userData: userData,
              ),
            );

        context
            .read<AppBloc>()
            .add(AddAccountEvent(accounts: response?.data['data']['accounts']));
        context.loaderOverlay.hide();
        showToast(context,
            title: "success",
            desc: resp.data['message'],
            type: ToastificationType.success);
        return;
      }
    } else {
      if (context.mounted) {
        context.loaderOverlay.hide();
        showToast(context, title: "error", desc: resp.data['message']);
        return;
      }
    }
  } on DioException catch (error) {
    if (context.mounted) {
      context.loaderOverlay.hide();
      showToast(context, title: "error", desc: error.response?.data['message']);
      return;
    }
  } on Exception catch (error) {
    if (context.mounted) {
      context.loaderOverlay.hide();
      showToast(context, title: "error", desc: error.toString());
      return;
    }
  }
}
