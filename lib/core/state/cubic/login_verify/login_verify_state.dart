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

  LoginVerifySuccess({
    required this.userData,
    required this.accounts,
  });
}

class LoginVerifyLoading extends LoginVerifyState {}
