class RegisterState {
  RegisterState init() {
    return RegisterState();
  }

  RegisterSuccess success(
    String message,
    String email,
    Map<String, dynamic> user_data,
    List<Map<String, dynamic>> accounts,
    Map<String, dynamic> alt_notification,
  ) {
    return RegisterSuccess(
        message, email, user_data, accounts, alt_notification);
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
  Map<String, dynamic> alt_notification;

  RegisterSuccess(
    this.message,
    this.email,
    this.userData,
    this.accounts,
    this.alt_notification,
  );
}

final class RegisterLoading extends RegisterState {}

final class RegisterFailed extends RegisterState {
  String message;

  RegisterFailed(this.message);
}
