import 'dart:ui';

import 'package:browse_station/data/model/app_config.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class AppConfigCubit extends HydratedCubit<AppConfig> {
  AppConfigCubit()
      : super(AppConfig(
          authState: false,
          pinState: false,
          themeMode: 'light',
          enableFingerPrint: true,
          enableNotification: true,
          enableShakeToHideBalance: true,
          autoTheme: false,
        ));

  @override
  void onChange(Change<AppConfig> change) {
    // TODO: implement onChange
    print('change---> ${change.toString()}');
    super.onChange(change);
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    // TODO: implement onError
    print(error);
    super.onError(error, stackTrace);
    print(error);
  }

  changeThemeMode(String mode) async {
    emit(state.copyWith(themeMode: mode));
  }

  changeAutoThemeMode(bool mode) async {
    // SharedPreferences preferences = await SharedPreferences.getInstance();
    // preferences.setString('theme', mode);
    emit(state.copyWith(autoTheme: mode));
  }

  toggleThemeMode() {
    emit(state.copyWith(
        themeMode: state.themeMode == 'light' ? 'dark' : 'light'));
    print(state.themeMode);
  }

  comfirmPinState(bool status) async {
    // SharedPreferences preferences = await SharedPreferences.getInstance();
    // preferences.setString('theme', mode);
    emit(state.copyWith(pinState: status));
  }

  changeAuthState(bool status) async {
    emit(state.copyWith(authState: status));
  }

  enableFingerPrint(bool mode) async {
    emit(state.copyWith(enableFingerPrint: mode));
  }

  enableNotification(bool mode) async {
    final newState = state.copyWith(enableNotification: mode);
    emit(newState);
  }

  changePrimaryColor(Color color) {
    emit(state.copyWith(primaryColor: color));
  }

  enableShakeToHideBalance(bool mode) async {
    emit(state.copyWith(enableShakeToHideBalance: mode));
  }

  @override
  AppConfig? fromJson(Map<String, dynamic> json) => AppConfig.fromJson(json);

  @override
  Map<String, dynamic>? toJson(AppConfig state) {
    return state.toJson();
  }
}
