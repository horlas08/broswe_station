import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:hive_flutter/adapters.dart';

import '../../../service/request/auth.dart';
import 'register_event.dart';
import 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterState().init()) {
    on<InitEvent>(_init);
    on<RegisterRequestEvent>(_onRegisterRequest);
  }

  void _init(InitEvent event, Emitter<RegisterState> emit) async {
    emit(state.init());
  }

  @override
  void onChange(Change<RegisterState> change) {
    super.onChange(change);
    print('$change');
  }

  void _onRegisterRequest(
      RegisterRequestEvent event, Emitter<RegisterState> emit) async {
    try {
      emit(state.loading());
      final res = await registerRequest(
        firstName: event.firstname,
        lastName: event.lastname,
        userName: event.username,
        password: event.password,
        phone: event.phone,
        email: event.email,
        code: event.code,
        ref_code: event.ref_code,
      );

      // if (res == null) {
      //   emit(state.failed("Request Timeout Kindly Try And Login Before Retry"));
      // }

      if (res.statusCode == 200) {
        try {
          var appBox = Hive.box('appBox');
          await appBox.put("token", res.data['token']);
          await appBox.put("username", res.data['user_data']['username']);
          await appBox.put("email", res.data['user_data']['email']);

          final accounts = (res.data['accounts'] as List)
              .map((itemWord) => itemWord as Map<String, dynamic>)
              .toList();
          emit(
            state.success(res.data['message'], res.data['user_data']['email'],
                res.data['user_data'], accounts),
          );
        } catch (error) {
          print(error);
          emit(state.failed(error.toString()));
        }
      } else {
        emit(state.failed('${res.data['message']}'));
      }
    } on DioException catch (err) {
      emit(state.failed(err.response?.data['message'] ?? err.toString()));
      emit(state.init());
    }
    emit(state.init());
  }
}
