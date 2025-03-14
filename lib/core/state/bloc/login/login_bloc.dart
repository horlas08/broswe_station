import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:browse_station/core/service/request/auth.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInit()) {
    on<LoginInitEvent>(_init);
    on<LoginRequestEvent>(_onLoginRequested);
  }

  void _init(LoginInitEvent event, Emitter<LoginState> emit) async {
    emit(state.init());
  }

  @override
  void onChange(Change<LoginState> change) {
    // TODO: implement onChange
    super.onChange(change);
    print('change ---> $change');
  }

  void _onLoginRequested(
      LoginRequestEvent event, Emitter<LoginState> emit) async {
    try {
      emit(state.loading());
      final res = await loginRequest(
          username: event.username, password: event.password);

      if (res.statusCode == HttpStatus.ok) {
        var appBox = Hive.box('appBox');
        await appBox.put("token", res.data['data']['user_data']['token']);
        await appBox.put("username", res.data['data']['user_data']['username']);
        await appBox.put("email", res.data['data']['user_data']['email']);

        final accounts = (res.data['data']['accounts'] as List)
            .map((itemWord) => itemWord as Map<String, dynamic>)
            .toList();
        final alt_notification =
            Map<String, dynamic>.from(res.data['data']['alt_notification']);
        final settings = Map<String, String>.from(res.data['data']['settings']);
        appBox.put("hasPin", res.data['data']['user_data']['has_pin']);
        return emit(
          state.success(
            res.data['data']['user_data'],
            accounts,
            settings,
            alt_notification,
          ),
        );
      } else {
        print("filed here");
        return emit(
          state.failed(res.data['message']),
        );
      }
    } on DioException catch (err) {
      emit(state.failed(err.response?.data['message'] ?? err.toString()));
    }
  }
}
