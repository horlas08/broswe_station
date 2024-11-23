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
      Map<String, dynamic> userdata, List<Map<String, dynamic>> account) {
    return LoginSuccess(userData: userdata, accounts: account);
  }
}

class LoginInit extends LoginState {}

class LoginSuccess extends LoginState {
  final Map<String, dynamic> userData;
  final List<Map<String, dynamic>> accounts;

  LoginSuccess({
    required this.userData,
    required this.accounts,
  });
}

class LoginFailed extends LoginState {
  String message;

  LoginFailed(this.message);
}

class LoginLoadingState extends LoginState {}
