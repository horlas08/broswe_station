import 'package:bloc/bloc.dart';

import '../../../../../data/model/account.dart';
import '../../../../../data/model/user.dart';
import 'app_event.dart';
import 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(AppState(accounts: []).init()) {
    // on<InitEvent>(_init);
    on<AddUserEvent>(_addUser);
    on<UpdateUserEvent>(_updateUser);
    on<AddAccountEvent>(_addAccount);
    on<AddUserSettingsEvent>(_addUserSettings);
  }

  @override
  void onChange(Change<AppState> change) {
    print(change.currentState.toString());
    print(change.nextState.toString());
    print(change.toString());
    super.onChange(change);
  }

  void _addUser(AddUserEvent event, Emitter<AppState> emit) async {
    final user = User.fromMap(event.userData);
    final newUser = state.copyWith(user: user);
    return emit(newUser);
  }

  void _addAccount(AddAccountEvent event, Emitter<AppState> emit) async {
    final List<Account> allAccount = [];
    for (var account in event.accounts) {
      allAccount.add(Account.fromJson(account));
    }
    state.accounts = allAccount;
    emit(state);
  }

  void _addUserSettings(
      AddUserSettingsEvent event, Emitter<AppState> emit) async {
    final newState = state.copyWith(settings: event.settings);
    // state.settings = {...event.settings};
    emit(newState);
  }

  void _updateUser(UpdateUserEvent event, Emitter<AppState> emit) async {
    final user = User.fromMap(event.userData);
    final newUser = state.copyWith(user: user);
    return emit(newUser);
  }
}
