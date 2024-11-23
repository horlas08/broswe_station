import '../../../../../data/model/account.dart';
import '../../../../../data/model/user.dart';

class AppState {
  User? user;
  List<Account>? accounts;

  AppState({this.user, this.accounts});
  AppState init() {
    return AppState();
  }

  AppState copyWith({
    User? user,
    List<Account>? accounts,
  }) {
    return AppState(
      user: user ?? this.user,
      accounts: accounts ?? this.accounts,
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
