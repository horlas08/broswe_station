sealed class LoginVerifyState {
  LoginVerifyInit init() {
    return LoginVerifyInit(authState: false);
  }
}

class LoginVerifyInit extends LoginVerifyState {
  final bool authState;

  LoginVerifyInit({required this.authState});
}

class LoginVerifyRequested extends LoginVerifyState {}

class LoginVerifyFailed extends LoginVerifyState {
  final String message;

  LoginVerifyFailed(this.message);
}

class LoginVerifySuccess extends LoginVerifyState {
  final Map<String, dynamic> userData;
  final List<Map<String, dynamic>> accounts;
  final Map<String, String> settings;
  final Map<String, dynamic> alt_notification;

  LoginVerifySuccess({
    required this.userData,
    required this.accounts,
    required this.settings,
    required this.alt_notification,
  });
}

class LoginVerifyLoading extends LoginVerifyState {}
