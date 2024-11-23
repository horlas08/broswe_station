import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:browse_station/core/service/request/auth.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

import 'login_verify_state.dart';

class LoginVerifyCubit extends Cubit<LoginVerifyState> {
  LoginVerifyCubit() : super(LoginVerifyInit(authState: false));

  Future<void> onLoginVerifyRequested(String? pin) async {
    try {
      emit(LoginVerifyLoading());
      late Response<dynamic>? res;
      if (pin == null) {
        res = await biometricVerifyRequest();
      } else {
        res = await pinVerifyRequest(pin: pin);
      }

      if (res.data == null) {
        return emit(
            LoginVerifyFailed("App Is Currently Down At This Moment Use Web"));
      }

      if (res.statusCode == HttpStatus.ok) {
        final accounts = (res.data['data']['accounts'] as List)
            .map((itemWord) => itemWord as Map<String, dynamic>)
            .toList();
        final userData = res.data['data']['user_data'];
        var appBox = Hive.box("appBox");
        appBox.put("hasPin", res.data['data']['user_data']['has_pin']);
        emit(LoginVerifySuccess(userData: userData, accounts: accounts));
      } else {
        if (res.data.containsKey('missing_parameters') &&
            !res.data['missing_parameters'].isEmpty) {
          emit(LoginVerifyFailed(res.data['missing_parameters']?[0]));
        } else {
          emit(LoginVerifyFailed(res.data['message']));
        }
      }
    } on DioException catch (error) {
      print('___fromcubbit___');
      print(error);
      print('___fromcubbit___');
      emit(LoginVerifyFailed(
          error.response?.data['message'] ?? error.toString()));
    } on Exception catch (error) {
      emit(LoginVerifyFailed(error.toString()));
    }
  }
}
