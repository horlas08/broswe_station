class RegisterState {
  RegisterState init() {
    return RegisterState();
  }

  RegisterSuccess success(String message, String email,
      Map<String, dynamic> user_data, List<Map<String, dynamic>> accounts) {
    return RegisterSuccess(message, email, user_data, accounts);
  }

  RegisterFailed failed(String message) {
    return RegisterFailed(message);
  }

  RegisterLoading loading() {
    return RegisterLoading();
  }
}

final class RegisterSuccess extends RegisterState {
  String message;
  String email;
  Map<String, dynamic> userData;
  List<Map<String, dynamic>> accounts;

  RegisterSuccess(this.message, this.email, this.userData, this.accounts);
}

final class RegisterLoading extends RegisterState {}

final class RegisterFailed extends RegisterState {
  String message;

  RegisterFailed(this.message);
}
