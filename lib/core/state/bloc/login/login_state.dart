sealed class LoginState {
  LoginState init() {
    return LoginInit();
  }

  LoginFailed failed(String message) {
    return LoginFailed(message);
  }

  LoginLoadingState loading() {
    return LoginLoadingState();
  }

  LoginSuccess success(
    Map<String, dynamic> userdata,
    List<Map<String, dynamic>> account,
    Map<String, String> settings,
    Map<String, dynamic> alt_notification,
  ) {
    return LoginSuccess(
      userData: userdata,
      accounts: account,
      settings: settings,
      alt_notification: alt_notification,
    );
  }
}

class LoginInit extends LoginState {}

class LoginSuccess extends LoginState {
  final Map<String, dynamic> userData;
  final List<Map<String, dynamic>> accounts;
  final Map<String, String> settings;
  final Map<String, dynamic> alt_notification;

  LoginSuccess({
    required this.userData,
    required this.accounts,
    required this.settings,
    required this.alt_notification,
  });
}

class LoginFailed extends LoginState {
  String message;

  LoginFailed(this.message);
}

class LoginLoadingState extends LoginState {}
