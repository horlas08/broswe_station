import 'package:browse_station/core/config/app.constant.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:hive_flutter/adapters.dart';

import '../http.dart';

Future<Response> loginRequest({
  required String username,
  required String password,
}) async {
  final res = await dio.post(loginPath, data: {
    'emailOrUsername': username,
    'password': password,
  });

  return res;
}

Future<Response> registerRequest({
  required String firstName,
  required String lastName,
  required String userName,
  required String email,
  required String phone,
  required String password,
}) async {
  final res = await dio.post(signUpPath, data: {
    'firstName': firstName,
    'lastName': lastName,
    'username': userName,
    'email': email,
    'phonenumber': phone,
    'password': password,
  });

  return res;
}

Future<Response> pinVerifyRequest({
  required String pin,
}) async {
  var appBox = Hive.box('appBox');
  final res = await dio.post(verifyPin, data: {
    'pin': pin,
    'token': appBox.get('token'),
  });

  return res;
}

Future<Response> biometricVerifyRequest() async {
  var appBox = Hive.box('appBox');
  final cacheStore = MemCacheStore();
  final cacheOptions = CacheOptions(
    policy: CachePolicy.noCache,
    store: cacheStore, // Do not cache this request
  );

  final res = await dio.get(getUserDetails,
      data: {
        'token': appBox.get('token'),
      },
      options: Options(extra: cacheOptions.toExtra()));

  return res;
}

Future<Response> resetPasswordRequest({
  required String password,
  required String otp,
  required String email,
}) async {
  var appBox = Hive.box('appBox');
  final res = await dio.post(
    resetPassword,
    data: {
      'new_password': password,
      'otp': otp,
      'emailOrUsername': email,
    },
  );

  return res;
}

Future<Response> sendOtpForResetPasswordRequest({required String email}) async {
  var appBox = Hive.box('appBox');
  final res = await dio.post(
    sendOtp,
    data: {
      'emailOrUsername': email,
    },
  );

  return res;
}

Future<Response> resendOtpForResetPasswordRequest() async {
  var appBox = Hive.box('appBox');
  final res = await dio.post(
    resendOtp,
    data: {
      'token': appBox.get('token'),
    },
  );

  return res;
}
