abstract class AppEvent {}

class InitEvent extends AppEvent {}

class UpdateUserEvent extends AppEvent {
  final Map<String, dynamic> userData;

  UpdateUserEvent({
    required this.userData,
  });
}

class AddUserEvent extends AppEvent {
  final Map<String, dynamic> userData;

  AddUserEvent({
    required this.userData,
  });
}

class AddAccountEvent extends AppEvent {
  final List<Map<String, dynamic>> accounts;

  AddAccountEvent({
    required this.accounts,
  });
}
