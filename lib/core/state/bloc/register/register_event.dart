abstract class RegisterEvent {}

class InitEvent extends RegisterEvent {}

class RegisterRequestEvent extends RegisterEvent {
  final String firstname;
  final String lastname;
  final String username;
  final String password;
  final String email;
  final String phone;
  final String code;

  RegisterRequestEvent({
    required this.firstname,
    required this.lastname,
    required this.username,
    required this.password,
    required this.email,
    required this.phone,
    required this.code,
  });
}
