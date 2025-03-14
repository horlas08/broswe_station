import '../../../../../data/model/account.dart';
import '../../../../../data/model/user.dart';

class AppState {
  User? user;
  List<Account>? accounts;
  Map<String, String>? settings;

  AppState({this.user, this.accounts, this.settings});

  AppState init() {
    return AppState();
  }

  AppState copyWith({
    User? user,
    List<Account>? accounts,
    Map<String, String>? settings,
  }) {
    return AppState(
      user: user ?? this.user,
      accounts: accounts ?? this.accounts,
      settings: settings ?? this.settings,
    );
  }

  AppState duplicateWith({
    User? user,
    List<Account>? accounts,
  }) {
    return AppState(
      user: user ?? this.user,
      accounts: accounts ?? this.accounts,
    );
  }
}

// final class AppInitState extends AppState {
//   AppInitState({User? user, List<Account>? account}) : super();
// }
