import 'package:checklist_app/core/services/snackbar_service.dart';
import 'package:checklist_app/core/util/themes.dart';
import 'package:checklist_app/interface/auth_repository.dart';
import 'package:checklist_app/model/user.dart';
import 'package:flutter/material.dart';

enum AuthState { idle, register, login, logout }

class AuthProvider extends ChangeNotifier {
  final AuthRepository authRepository;
  final SnackBarService snackBarService;
  AuthProvider({required this.authRepository, required this.snackBarService});

  AuthState _authState = AuthState.idle;
  AuthState get authState => _authState;
  void setState(AuthState state) {
    _authState = state;
    notifyListeners();
  }

  ThemeOptions _currentTheme = ThemeOptions.system;
  ThemeOptions get currentTheme => _currentTheme;
  set currentTheme(ThemeOptions value) {
    _currentTheme = value;
    notifyListeners();
  }

  Future<bool> register(UserModel user) async {
    setState(AuthState.register);
    final regEither = await authRepository.register(user);
    setState(AuthState.idle);
    return regEither.fold(
      (exc) {
        snackBarService.displayMessage(exc.message);
        return false;
      },
      (done) => done,
    );
  }

  Future<bool> login(UserModel user) async {
    setState(AuthState.login);
    final regEither = await authRepository.login(user);
    setState(AuthState.idle);
    return regEither.fold(
      (exc) {
        snackBarService.displayMessage(exc.message);
        return false;
      },
      (done) => done,
    );
  }

  Future<bool> logout() async {
    setState(AuthState.logout);
    final regEither = await authRepository.logout();
    setState(AuthState.idle);
    return regEither.fold(
      (exc) {
        snackBarService.displayMessage(exc.message);
        return false;
      },
      (done) => done,
    );
  }
}
